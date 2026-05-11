import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/models/maintenance_record.dart';
import '../../logic/maintenance/maintenance_cubit.dart';

class AddRecordScreen extends StatefulWidget {
  final MaintenanceRecord?
  existingRecord; // If null, we are adding. If not, we are editing.

  const AddRecordScreen({Key? key, this.existingRecord}) : super(key: key);

  @override
  State<AddRecordScreen> createState() => _AddRecordScreenState();
}

class _AddRecordScreenState extends State<AddRecordScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _titleController;
  late TextEditingController _costController;
  late TextEditingController _notesController;

  @override
  void initState() {
    super.initState();
    // Pre-fill the controllers if we are editing an existing record
    _titleController = TextEditingController(
      text: widget.existingRecord?.title ?? '',
    );
    _costController = TextEditingController(
      text: widget.existingRecord != null
          ? widget.existingRecord!.cost.toString()
          : '',
    );
    _notesController = TextEditingController(
      text: widget.existingRecord?.notes ?? '',
    );
  }

  @override
  void dispose() {
    _titleController.dispose();
    _costController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.existingRecord != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(isEditing ? 'Edit Service Record' : 'Add Service Record'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(
                  labelText: 'Service Title (e.g., Oil Change, Bi-LED Install)',
                  border: OutlineInputBorder(),
                ),
                validator: (value) =>
                    value!.isEmpty ? 'Please enter a title' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _costController,
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                decoration: const InputDecoration(
                  labelText: 'Cost',
                  prefixText: '\$ ',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty)
                    return 'Please enter a cost';
                  if (double.tryParse(value) == null)
                    return 'Enter a valid number';
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _notesController,
                maxLines: 3,
                decoration: const InputDecoration(
                  labelText: 'Additional Notes / Error Codes',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  backgroundColor: Colors.blueGrey.shade800,
                  foregroundColor: Colors.white,
                ),
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    final updatedRecord = MaintenanceRecord(
                      id: isEditing
                          ? widget.existingRecord!.id
                          : '', // Keep same ID if editing
                      title: _titleController.text.trim(),
                      date: isEditing
                          ? widget.existingRecord!.date
                          : DateTime.now(),
                      cost: double.parse(_costController.text.trim()),
                      notes: _notesController.text.trim(),
                    );

                    if (isEditing) {
                      context.read<MaintenanceCubit>().updateRecord(
                        updatedRecord,
                      );
                    } else {
                      context.read<MaintenanceCubit>().addRecord(updatedRecord);
                    }

                    Navigator.pop(context);
                  }
                },
                child: Text(
                  isEditing ? 'Update Record' : 'Save Record',
                  style: const TextStyle(fontSize: 16),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
