import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'dart:html' as html;
import '../../data/models/visibility_report_model.dart';
import '../providers/reports_providers.dart';

class VisibilityReportForm extends ConsumerStatefulWidget {
  final int journeyPlanId;
  final int clientId;
  final int userId;

  const VisibilityReportForm({
    super.key,
    required this.journeyPlanId,
    required this.clientId,
    required this.userId,
  });

  @override
  ConsumerState<VisibilityReportForm> createState() =>
      _VisibilityReportFormState();
}

class _VisibilityReportFormState extends ConsumerState<VisibilityReportForm> {
  final _formKey = GlobalKey<FormState>();
  final _activityController = TextEditingController();
  final _commentController = TextEditingController();
  XFile? _selectedImage;

  @override
  void dispose() {
    _activityController.dispose();
    _commentController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    try {
      final XFile? image = await picker.pickImage(
        source: ImageSource.camera,
        imageQuality: 80,
      );
      if (image != null) {
        setState(() {
          _selectedImage = image;
        });
      }
    } catch (e) {
      // On web, camera might not be available, try gallery
      try {
        final XFile? image = await picker.pickImage(
          source: ImageSource.gallery,
          imageQuality: 80,
        );
        if (image != null) {
          setState(() {
            _selectedImage = image;
          });
        }
      } catch (galleryError) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to access camera/gallery: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _submitReport() async {
    if (!_formKey.currentState!.validate()) return;

    // Check if photo is selected
    if (_selectedImage == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please take a photo of the visibility activity'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    try {
      final report = VisibilityReportModel(
        journeyPlanId: widget.journeyPlanId,
        clientId: widget.clientId,
        userId: widget.userId,
        comment: _activityController.text.trim(),
      );

      final success = await ref
          .read(reportsNotifierProvider.notifier)
          .submitVisibilityReport(report);

      if (success && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
                '✅ Visibility Activity report submitted successfully! You can submit more reports or check out.'),
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

  Widget _buildImagePreview() {
    if (_selectedImage == null) return const SizedBox.shrink();

    return Container(
      width: double.infinity,
      height: 200,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(8),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: _buildImageWidget(),
      ),
    );
  }

  Widget _buildImageWidget() {
    if (_selectedImage == null) return const SizedBox.shrink();

    // Check if running on web
    if (identical(0, 0.0)) {
      // Web platform - use Image.memory
      return FutureBuilder<html.File>(
        future: _selectedImage!
            .readAsBytes()
            .then((bytes) => html.File([bytes], _selectedImage!.name)),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Image.network(
              html.Url.createObjectUrlFromBlob(snapshot.data!),
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  color: Colors.grey[200],
                  child: const Center(
                    child: Icon(Icons.image_not_supported,
                        size: 50, color: Colors.grey),
                  ),
                );
              },
            );
          }
          return Container(
            color: Colors.grey[200],
            child: const Center(child: CircularProgressIndicator()),
          );
        },
      );
    } else {
      // Mobile platform - use Image.file
      return Image.file(
        File(_selectedImage!.path),
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return Container(
            color: Colors.grey[200],
            child: const Center(
              child:
                  Icon(Icons.image_not_supported, size: 50, color: Colors.grey),
            ),
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final reportsState = ref.watch(reportsNotifierProvider);
    final isCompleted = ref
        .read(reportsNotifierProvider.notifier)
        .isReportCompleted('VISIBILITY_ACTIVITY');

    return Scaffold(
      appBar: AppBar(
        title: const Text('Visibility Activity Report'),
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
                        'Visibility Activity report completed',
                        style: TextStyle(
                          color: Colors.green[700],
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),

              // Activity Description
              TextFormField(
                controller: _activityController,
                decoration: const InputDecoration(
                  labelText: 'Activity Description *',
                  hintText: 'Describe the visibility activity...',
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter activity description';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Comments (Optional)
              TextFormField(
                controller: _commentController,
                decoration: const InputDecoration(
                  labelText: 'Comments (Optional)',
                  hintText: 'Enter any additional comments',
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
              ),
              const SizedBox(height: 16),

              // Photo Section
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.grey[50],
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.grey[200]!),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.camera_alt, color: Colors.grey[600]),
                        const SizedBox(width: 8),
                        Text(
                          'Activity Photo *',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: Colors.grey[700],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    if (_selectedImage != null) ...[
                      _buildImagePreview(),
                      const SizedBox(height: 16),
                    ],
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: _pickImage,
                        icon: Icon(_selectedImage != null
                            ? Icons.camera_alt
                            : Icons.camera_alt),
                        label: Text(_selectedImage != null
                            ? 'Retake Photo'
                            : 'Take Photo'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: _selectedImage != null
                              ? Colors.orange
                              : Theme.of(context).colorScheme.primary,
                          foregroundColor: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
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
                          'Submit Visibility Activity Report',
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
