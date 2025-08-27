import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../../../core/constants/app_colors.dart';
import '../providers/journey_plans_providers.dart';
import '../../../clients/presentation/providers/clients_providers.dart';
import '../../../clients/domain/entities/client.dart';

class CreateJourneyPlanSheet extends ConsumerStatefulWidget {
  const CreateJourneyPlanSheet({super.key});

  @override
  ConsumerState<CreateJourneyPlanSheet> createState() =>
      _CreateJourneyPlanSheetState();
}

class _CreateJourneyPlanSheetState
    extends ConsumerState<CreateJourneyPlanSheet> {
  final _formKey = GlobalKey<FormState>();
  final _notesController = TextEditingController();

  DateTime _selectedDate = DateTime.now();
  TimeOfDay _selectedTime = TimeOfDay.now();
  int? _selectedClientId;
  bool _isLoading = false;



  @override
  void initState() {
    super.initState();
    // Load clients when the form opens
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(clientsNotifierProvider.notifier).loadClients();
    });
  }

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
        left: 16,
        right: 16,
        top: 16,
      ),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Header
            Row(
              children: [
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.close),
                ),
                const Expanded(
                  child: Text(
                    'Create Journey Plan',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(width: 48), // Balance the close button
              ],
            ),
            const SizedBox(height: 16),

            // Client Selection
            _buildClientDropdown(),
            const SizedBox(height: 16),

            // Date Selection
            _buildDatePicker(),
            const SizedBox(height: 16),

            // Time Selection
            _buildTimePicker(),
            const SizedBox(height: 16),

            // Notes
            _buildNotesField(),
            const SizedBox(height: 24),

            // Create Button
            _buildCreateButton(),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildClientDropdown() {
    final clientsState = ref.watch(clientsNotifierProvider);
    
    if (clientsState.isLoading && clientsState.clients.isEmpty) {
      return const InputDecorator(
        decoration: InputDecoration(
          labelText: 'Select Client *',
          border: OutlineInputBorder(),
          prefixIcon: Icon(Icons.business),
        ),
        child: Row(
          children: [
            SizedBox(
              height: 20,
              width: 20,
              child: CircularProgressIndicator(strokeWidth: 2),
            ),
            SizedBox(width: 16),
            Text('Loading clients...'),
          ],
        ),
      );
    }
    
    if (clientsState.error != null && clientsState.clients.isEmpty) {
      return InputDecorator(
        decoration: const InputDecoration(
          labelText: 'Select Client *',
          border: OutlineInputBorder(),
          prefixIcon: Icon(Icons.business),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Error loading clients: ${clientsState.error}',
              style: const TextStyle(color: Colors.red),
            ),
            TextButton(
              onPressed: () {
                ref.read(clientsNotifierProvider.notifier).loadClients();
              },
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }
    
    if (clientsState.clients.isEmpty && !clientsState.isLoading) {
      return const InputDecorator(
        decoration: InputDecoration(
          labelText: 'Select Client *',
          border: OutlineInputBorder(),
          prefixIcon: Icon(Icons.business),
        ),
        child: Text('No clients available'),
      );
    }
    
    return DropdownButtonFormField<int>(
      value: _selectedClientId,
      decoration: const InputDecoration(
        labelText: 'Select Client *',
        border: OutlineInputBorder(),
        prefixIcon: Icon(Icons.business),
      ),
      items: clientsState.clients.map<DropdownMenuItem<int>>((client) {
        return DropdownMenuItem<int>(
          value: client.id,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                client.name,
                style: const TextStyle(fontWeight: FontWeight.w500),
              ),
              Text(
                client.location ?? 'No location',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
        );
      }).toList(),
      onChanged: (value) {
        setState(() {
          _selectedClientId = value;
        });
      },
      validator: (value) {
        if (value == null) {
          return 'Please select a client';
        }
        return null;
      },
    );
  }

  Widget _buildDatePicker() {
    return InkWell(
      onTap: () => _selectDate(context),
      child: InputDecorator(
        decoration: const InputDecoration(
          labelText: 'Date *',
          border: OutlineInputBorder(),
          prefixIcon: Icon(Icons.calendar_today),
        ),
        child: Text(
          DateFormat('EEEE, MMMM dd, yyyy').format(_selectedDate),
          style: const TextStyle(fontSize: 16),
        ),
      ),
    );
  }

  Widget _buildTimePicker() {
    return InkWell(
      onTap: () => _selectTime(context),
      child: InputDecorator(
        decoration: const InputDecoration(
          labelText: 'Time *',
          border: OutlineInputBorder(),
          prefixIcon: Icon(Icons.access_time),
        ),
        child: Text(
          _selectedTime.format(context),
          style: const TextStyle(fontSize: 16),
        ),
      ),
    );
  }

  Widget _buildNotesField() {
    return TextFormField(
      controller: _notesController,
      decoration: const InputDecoration(
        labelText: 'Notes (Optional)',
        border: OutlineInputBorder(),
        prefixIcon: Icon(Icons.note),
        hintText: 'Add any additional notes about this visit...',
      ),
      maxLines: 3,
      maxLength: 500,
    );
  }

  Widget _buildCreateButton() {
    return ElevatedButton(
      onPressed: _isLoading ? null : _createJourneyPlan,
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(vertical: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      child: _isLoading
          ? const SizedBox(
              height: 20,
              width: 20,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              ),
            )
          : const Text(
              'Create Journey Plan',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _selectedTime,
    );
    if (picked != null && picked != _selectedTime) {
      setState(() {
        _selectedTime = picked;
      });
    }
  }

  Future<void> _createJourneyPlan() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (_selectedClientId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a client')),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      await ref.read(journeyPlansNotifierProvider.notifier).createJourneyPlan(
            clientId: _selectedClientId!,
            date: _selectedDate,
            time:
                '${_selectedTime.hour.toString().padLeft(2, '0')}:${_selectedTime.minute.toString().padLeft(2, '0')}',
            notes: _notesController.text.trim().isEmpty
                ? null
                : _notesController.text.trim(),
          );

      if (mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Journey Plan created successfully!'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error creating journey plan: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }
}
