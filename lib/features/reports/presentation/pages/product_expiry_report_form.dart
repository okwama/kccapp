import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../data/models/product_expiry_report_model.dart';
import '../providers/reports_providers.dart';
import '../../../products/data/models/product_model.dart';
import '../../../products/presentation/widgets/product_selection_widget.dart';

class ProductExpiryReportForm extends ConsumerStatefulWidget {
  final int journeyPlanId;
  final int clientId;
  final int userId;

  const ProductExpiryReportForm({
    super.key,
    required this.journeyPlanId,
    required this.clientId,
    required this.userId,
  });

  @override
  ConsumerState<ProductExpiryReportForm> createState() =>
      _ProductExpiryReportFormState();
}

class _ProductExpiryReportFormState
    extends ConsumerState<ProductExpiryReportForm> {
  final _formKey = GlobalKey<FormState>();
  ProductModel? _selectedProduct;
  final _quantityController = TextEditingController();
  final _batchNumberController = TextEditingController();
  final _commentsController = TextEditingController();
  DateTime? _selectedDate;

  @override
  void dispose() {
    _quantityController.dispose();
    _batchNumberController.dispose();
    _commentsController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate:
          DateTime.now().add(const Duration(days: 365 * 2)), // 2 years from now
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  Future<void> _submitReport() async {
    if (!_formKey.currentState!.validate()) return;

    if (_selectedDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select an expiry date'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    try {
      final report = ProductExpiryReportModel(
        journeyPlanId: widget.journeyPlanId,
        clientId: widget.clientId,
        userId: widget.userId,
        productName: _selectedProduct?.productName ?? '',
        productId: _selectedProduct?.id,
        quantity: int.parse(_quantityController.text),
        expiryDate: _selectedDate!,
        batchNumber: _batchNumberController.text.trim(),
        comments: _commentsController.text.trim().isEmpty
            ? null
            : _commentsController.text.trim(),
      );

      final success = await ref
          .read(reportsNotifierProvider.notifier)
          .submitProductExpiryReport(report);

      if (success && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
                '✅ Product Expiry report submitted successfully! You can submit more reports or check out.'),
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
        .isReportCompleted('PRODUCT_EXPIRY');

    return Scaffold(
      appBar: AppBar(
        title: const Text('Product Expiry Report'),
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
                        'Product Expiry report completed',
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
                label: 'Product',
                hint: 'Search and select a product',
                selectedProduct: _selectedProduct,
                onProductSelected: (product) {
                  setState(() {
                    _selectedProduct = product;
                  });
                },
                isRequired: true,
              ),
              const SizedBox(height: 16),

              // Quantity
              TextFormField(
                controller: _quantityController,
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
              const SizedBox(height: 16),

              // Expiry Date
              InkWell(
                onTap: () => _selectDate(context),
                child: InputDecorator(
                  decoration: InputDecoration(
                    labelText: 'Expiry Date *',
                    border: const OutlineInputBorder(),
                    suffixIcon: const Icon(Icons.calendar_today),
                  ),
                  child: Text(
                    _selectedDate == null
                        ? 'Select expiry date'
                        : '${_selectedDate!.day}/${_selectedDate!.month}/${_selectedDate!.year}',
                    style: TextStyle(
                      color: _selectedDate == null
                          ? Colors.grey[600]
                          : Colors.black,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Batch Number
              TextFormField(
                controller: _batchNumberController,
                decoration: const InputDecoration(
                  labelText: 'Batch Number *',
                  hintText: 'Enter batch number',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter batch number';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Comments (Optional)
              TextFormField(
                controller: _commentsController,
                decoration: const InputDecoration(
                  labelText: 'Comments (Optional)',
                  hintText: 'Enter any additional comments',
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
              ),
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
                          'Submit Product Expiry Report',
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
