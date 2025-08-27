import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../data/models/product_availability_report_model.dart';
import '../../data/models/product_availability_item_model.dart';
import '../providers/reports_providers.dart';
import '../../../products/data/models/product_model.dart';
import '../../../products/presentation/widgets/product_selection_widget.dart';

class ProductAvailabilityReportForm extends ConsumerStatefulWidget {
  final int journeyPlanId;
  final int clientId;
  final int userId;

  const ProductAvailabilityReportForm({
    super.key,
    required this.journeyPlanId,
    required this.clientId,
    required this.userId,
  });

  @override
  ConsumerState<ProductAvailabilityReportForm> createState() =>
      _ProductAvailabilityReportFormState();
}

class _ProductAvailabilityReportFormState
    extends ConsumerState<ProductAvailabilityReportForm> {
  final _formKey = GlobalKey<FormState>();
  final List<ProductAvailabilityItemModel> _products = [];
  final Map<int, TextEditingController> _quantityControllers = {};

  @override
  void dispose() {
    for (final controller in _quantityControllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  void _addProduct(ProductModel product) {
    if (_products.any((p) => p.productId == product.id)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${product.productName} is already added'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    setState(() {
      _products.add(ProductAvailabilityItemModel(
        productName: product.productName,
        productId: product.id,
        quantity: 0,
      ));
      _quantityControllers[product.id] = TextEditingController();
    });
  }

  void _removeProduct(int index) {
    final product = _products[index];
    setState(() {
      _products.removeAt(index);
      _quantityControllers[product.productId!]?.dispose();
      _quantityControllers.remove(product.productId);
    });
  }

  Future<void> _submitReport() async {
    if (!_formKey.currentState!.validate()) return;

    if (_products.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please add at least one product'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    try {
      // Update quantities from controllers
      for (int i = 0; i < _products.length; i++) {
        final product = _products[i];
        final controller = _quantityControllers[product.productId];
        if (controller != null && controller.text.isNotEmpty) {
          _products[i] = product.copyWith(
            quantity: int.parse(controller.text),
          );
        }
      }

      // Submit each product as a separate report
      bool allSuccess = true;
      for (final product in _products) {
        final report = ProductAvailabilityReportModel(
          journeyPlanId: widget.journeyPlanId,
          clientId: widget.clientId,
          userId: widget.userId,
          productName: product.productName,
          productId: product.productId,
          quantity: product.quantity,
        );

        final success = await ref
            .read(reportsNotifierProvider.notifier)
            .submitProductAvailabilityReport(report);

        if (!success) {
          allSuccess = false;
          break;
        }
      }

      if (allSuccess && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
                '✅ Product Availability report submitted successfully! You can submit more reports or check out.'),
            backgroundColor: Colors.green,
          ),
        );

        // Navigate back to reports selection page
        context.pop();
      } else if (mounted) {
        final error = ref.read(reportsNotifierProvider).error;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content:
                Text('❌ Error submitting report: ${error ?? 'Unknown error'}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('❌ Error submitting report: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final reportsState = ref.watch(reportsNotifierProvider);
    final isCompleted = ref
        .read(reportsNotifierProvider.notifier)
        .isReportCompleted('PRODUCT_AVAILABILITY');

    return Scaffold(
      appBar: AppBar(
        title: const Text('Product Availability Report'),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Status indicator
              if (isCompleted)
                Container(
                  padding: const EdgeInsets.all(12),
                  margin: const EdgeInsets.only(bottom: 16),
                  decoration: BoxDecoration(
                    color: Colors.green[50],
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.green[200]!),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.check_circle, color: Colors.green[600]),
                      const SizedBox(width: 8),
                      Text(
                        'Product Availability report completed',
                        style: TextStyle(
                          color: Colors.green[700],
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),

              // Product Selection
              ProductSelectionWidget(
                label: 'Add Product',
                hint: 'Search and select products to add',
                selectedProduct: null,
                onProductSelected: (product) {
                  if (product != null) {
                    _addProduct(product);
                  }
                },
                isRequired: false,
              ),
              const SizedBox(height: 16),

              // Products List
              if (_products.isNotEmpty) ...[
                Text(
                  'Selected Products (${_products.length})',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 8),
                Expanded(
                  child: ListView.builder(
                    itemCount: _products.length,
                    itemBuilder: (context, index) {
                      final product = _products[index];
                      final controller =
                          _quantityControllers[product.productId];

                      return Card(
                        margin: const EdgeInsets.only(bottom: 8),
                        child: Padding(
                          padding: const EdgeInsets.all(12),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          product.productName,
                                          style: const TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                        Text(
                                          'Code: ${product.productId}',
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: Colors.grey[600],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.remove_circle,
                                        color: Colors.red),
                                    onPressed: () => _removeProduct(index),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              TextFormField(
                                controller: controller,
                                decoration: const InputDecoration(
                                  labelText: 'Quantity *',
                                  hintText: 'Enter quantity',
                                  border: OutlineInputBorder(),
                                ),
                                keyboardType: TextInputType.number,
                                validator: (value) {
                                  if (value == null || value.trim().isEmpty) {
                                    return 'Please enter quantity';
                                  }
                                  if (int.tryParse(value) == null) {
                                    return 'Please enter a valid number';
                                  }
                                  return null;
                                },
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],

              const SizedBox(height: 24),

              // Submit button
              SizedBox(
                height: 50,
                child: ElevatedButton(
                  onPressed: reportsState.isLoading ? null : _submitReport,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    foregroundColor: Colors.white,
                  ),
                  child: reportsState.isLoading
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor:
                                AlwaysStoppedAnimation<Color>(Colors.white),
                          ),
                        )
                      : const Text(
                          'Submit Product Availability Report',
                          style: TextStyle(fontSize: 16),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
