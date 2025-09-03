import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../../../core/constants/app_colors.dart';
import '../providers/journey_plans_providers.dart';
import '../../../clients/presentation/providers/clients_providers.dart';
import '../../../clients/domain/entities/client.dart';
import '../../../clients/presentation/providers/clients_state.dart';

class CreateJourneyPlanPage extends ConsumerStatefulWidget {
  const CreateJourneyPlanPage({super.key});

  @override
  ConsumerState<CreateJourneyPlanPage> createState() =>
      _CreateJourneyPlanPageState();
}

class _CreateJourneyPlanPageState extends ConsumerState<CreateJourneyPlanPage> {
  final _formKey = GlobalKey<FormState>();
  final _notesController = TextEditingController();
  final _searchController = TextEditingController();

  DateTime _selectedDate = DateTime.now();
  TimeOfDay _selectedTime = TimeOfDay.now();
  int? _selectedClientId;
  bool _isLoading = false;
  List<Client> _filteredClients = [];
  bool _isSearching = false;

  @override
  void initState() {
    super.initState();
    // Load clients when the page opens
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(clientsNotifierProvider.notifier).loadClients();
    });
  }

  @override
  void dispose() {
    _notesController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _filterClients(String query) {
    final clientsState = ref.read(clientsNotifierProvider);
    if (query.isEmpty) {
      setState(() {
        _filteredClients = clientsState.clients;
        _isSearching = false;
      });
    } else {
      setState(() {
        _filteredClients = clientsState.clients
            .where((client) =>
                client.name.toLowerCase().contains(query.toLowerCase()) ||
                (client.location?.toLowerCase().contains(query.toLowerCase()) ??
                    false))
            .toList();
        _isSearching = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Create Journey Plan'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: Form(
        key: _formKey,
        child: Column(
          children: [
            // Top section with date and time side by side
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  // Date Selection
                  Expanded(child: _buildDatePicker()),
                  const SizedBox(width: 16),
                  // Time Selection
                  Expanded(child: _buildTimePicker()),
                ],
              ),
            ),

            // Client Search and Selection
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: _buildClientSearchSection(),
            ),

            // Client List - takes remaining space
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: _buildClientListSection(),
              ),
            ),

            // Create Button at bottom
            Padding(
              padding: const EdgeInsets.all(16),
              child: _buildCreateButton(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildClientSearchSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Select Client *',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),

        // Search TextField
        TextField(
          controller: _searchController,
          decoration: InputDecoration(
            hintText: 'Search clients by name or location...',
            prefixIcon: const Icon(Icons.search),
            suffixIcon: _searchController.text.isNotEmpty
                ? IconButton(
                    icon: const Icon(Icons.clear),
                    onPressed: () {
                      _searchController.clear();
                      _filterClients('');
                    },
                  )
                : null,
            border: const OutlineInputBorder(),
            filled: true,
            fillColor: Colors.grey[50],
          ),
          onChanged: _filterClients,
        ),
      ],
    );
  }

  Widget _buildClientListSection() {
    final clientsState = ref.watch(clientsNotifierProvider);

    if (clientsState.isLoading && clientsState.clients.isEmpty) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (clientsState.error != null && clientsState.clients.isEmpty) {
      return _buildErrorState(clientsState.error!);
    }

    if (clientsState.clients.isEmpty && !clientsState.isLoading) {
      return const Center(
        child: Text('No clients available'),
      );
    }

    return _buildClientList(clientsState);
  }

  Widget _buildErrorState(String error) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.red[50],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.red[200]!),
      ),
      child: Column(
        children: [
          Text(
            'Error loading clients: $error',
            style: const TextStyle(color: Colors.red),
          ),
          const SizedBox(height: 8),
          ElevatedButton(
            onPressed: () {
              ref.read(clientsNotifierProvider.notifier).loadClients();
            },
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }

  Widget _buildClientList(ClientsState clientsState) {
    final clientsToShow =
        _isSearching ? _filteredClients : clientsState.clients;

    if (clientsToShow.isEmpty && _isSearching) {
      return Container(
        padding: const EdgeInsets.all(20),
        child: const Center(
          child: Text(
            'No clients found matching your search',
            style: TextStyle(color: Colors.grey),
          ),
        ),
      );
    }

    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey[300]!),
        borderRadius: BorderRadius.circular(8),
      ),
      child: ListView.builder(
        itemCount: clientsToShow.length,
        itemBuilder: (context, index) {
          final client = clientsToShow[index];
          final isSelected = _selectedClientId == client.id;

          return ListTile(
            leading: CircleAvatar(
              backgroundColor:
                  isSelected ? AppColors.primary : Colors.grey[300],
              child: Icon(
                Icons.business,
                color: isSelected ? Colors.white : Colors.grey[600],
              ),
            ),
            title: Text(
              client.name,
              style: TextStyle(
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                color: isSelected ? AppColors.primary : Colors.black87,
              ),
            ),
            subtitle: Text(
              client.location ?? 'No location',
              style: TextStyle(
                fontSize: 12,
                color: isSelected
                    ? AppColors.primary.withOpacity(0.7)
                    : Colors.grey[600],
              ),
            ),
            trailing: isSelected
                ? Icon(
                    Icons.check_circle,
                    color: AppColors.primary,
                  )
                : null,
            onTap: () {
              setState(() {
                _selectedClientId = client.id;
              });
            },
            tileColor: isSelected ? AppColors.primary.withOpacity(0.1) : null,
          );
        },
      ),
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
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
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
