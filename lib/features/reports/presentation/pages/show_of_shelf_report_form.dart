import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../data/models/show_of_shelf_report_model.dart';
import '../providers/reports_providers.dart';
import '../../../products/data/models/product_model.dart';
import '../../../products/presentation/widgets/product_selection_widget.dart';

class ShowOfShelfReportForm extends ConsumerStatefulWidget {
  final int journeyPlanId;
  final int clientId;
  final int userId;

  const ShowOfShelfReportForm({
    super.key,
    required this.journeyPlanId,
    required this.clientId,
    required this.userId,
  });

  @override
  ConsumerState<ShowOfShelfReportForm> createState() =>
      _ShowOfShelfReportFormState();
}

class _ShowOfShelfReportFormState extends ConsumerState<ShowOfShelfReportForm> {
  final _formKey = GlobalKey<FormState>();
  final _totalItemsController = TextEditingController();
  final _companyItemsController = TextEditingController();
  final _commentsController = TextEditingController();
  ProductModel? _selectedProduct;

  @override
  void dispose() {
    _totalItemsController.dispose();
    _companyItemsController.dispose();
    _commentsController.dispose();
    super.dispose();
  }

  Future<void> _submitReport() async {
    if (!_formKey.currentState!.validate()) return;

    try {
      final report = ShowOfShelfReportModel(
        journeyPlanId: widget.journeyPlanId,
        clientId: widget.clientId,
        userId: widget.userId,
        productName: _selectedProduct?.productName ?? '',
        productId: _selectedProduct?.id,
        totalItemsOnShelf: int.parse(_totalItemsController.text),
        companyItemsOnShelf: int.parse(_companyItemsController.text),
        comments: _commentsController.text.trim().isEmpty
            ? null
            : _commentsController.text.trim(),
      );

      final success = await ref
          .read(reportsNotifierProvider.notifier)
          .submitShowOfShelfReport(report);

      if (success && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content:
                Text('✅ Show of Shelf report submitted successfully! You can submit more reports or check out.'),
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
        .isReportCompleted('SHOW_OF_SHELF');

    return Scaffold(
      appBar: AppBar(
        title: const Text('Show of Shelf Report'),
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
                        'Show of Shelf report completed',
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

              // Total Items on Shelf
              TextFormField(
                controller: _totalItemsController,
                decoration: const InputDecoration(
                  labelText: 'Total Items on Shelf *',
                  hintText: 'Enter total number of items',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter total items on shelf';
                  }
                  if (int.tryParse(value) == null) {
                    return 'Please enter a valid number';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Company Items on Shelf
              TextFormField(
                controller: _companyItemsController,
                decoration: const InputDecoration(
                  labelText: 'Company Items on Shelf *',
                  hintText: 'Enter number of company items',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter company items on shelf';
                  }
                  if (int.tryParse(value) == null) {
                    return 'Please enter a valid number';
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
                          'Submit Show of Shelf Report',
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
