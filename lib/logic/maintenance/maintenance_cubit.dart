import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/models/maintenance_record.dart';
import '../../data/repositories/maintenance_repository.dart';

abstract class MaintenanceState {}

class MaintenanceInitial extends MaintenanceState {}

class MaintenanceLoading extends MaintenanceState {}

class MaintenanceLoaded extends MaintenanceState {
  final List<MaintenanceRecord> records;
  MaintenanceLoaded(this.records);
}

class MaintenanceError extends MaintenanceState {
  final String message;
  MaintenanceError(this.message);
}

class MaintenanceCubit extends Cubit<MaintenanceState> {
  final MaintenanceRepository repository;

  MaintenanceCubit({required this.repository}) : super(MaintenanceInitial());

  Future<void> fetchRecords() async {
    emit(MaintenanceLoading());
    try {
      final records = await repository.getRecords();
      emit(MaintenanceLoaded(records));
    } catch (e) {
      emit(MaintenanceError(e.toString()));
    }
  }

  Future<void> addRecord(MaintenanceRecord record) async {
    // Optional: emit a loading state for spinner
    try {
      await repository.addRecord(record);
      // After successfully adding to Firebase, fetch the updated list
      await fetchRecords();
    } catch (e) {
      emit(MaintenanceError(e.toString()));
    }
  }

  Future<void> deleteRecord(String recordId) async {
    try {
      await repository.deleteRecord(recordId);
      // Fetch the updated list after deleting!
      await fetchRecords();
    } catch (e) {
      emit(MaintenanceError(e.toString()));
    }
  }

  Future<void> updateRecord(MaintenanceRecord record) async {
    try {
      await repository.updateRecord(record);
      // Fetch the updated list after saving the edits!
      await fetchRecords();
    } catch (e) {
      emit(MaintenanceError(e.toString()));
    }
  }
}
