import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/models/fuel_record.dart';
import '../../data/repositories/fuel_repository.dart';

abstract class FuelState {}

class FuelInitial extends FuelState {}

class FuelLoading extends FuelState {}

class FuelLoaded extends FuelState {
  final List<FuelRecord> records;
  final double averageEfficiency; // L/100km

  FuelLoaded(this.records, this.averageEfficiency);
}

class FuelError extends FuelState {
  final String message;
  FuelError(this.message);
}

class FuelCubit extends Cubit<FuelState> {
  final FuelRepository repository;

  FuelCubit({required this.repository}) : super(FuelInitial());

  Future<void> fetchFuelRecords() async {
    emit(FuelLoading());
    try {
      final records = await repository.getFuelRecords();
      double efficiency = _calculateEfficiency(records);
      emit(FuelLoaded(records, efficiency));
    } catch (e) {
      emit(FuelError(e.toString()));
    }
  }

  Future<void> addFuelRecord(FuelRecord record) async {
    try {
      await repository.addFuelRecord(record);
      await fetchFuelRecords();
    } catch (e) {
      emit(FuelError(e.toString()));
    }
  }

  // Business Logic: Calculate L/100km based on the last two fill-ups
  double _calculateEfficiency(List<FuelRecord> records) {
    if (records.length < 2)
      return 0.0; // Need at least 2 records to calculate distance

    // Sort by odometer just in case
    records.sort((a, b) => a.odometer.compareTo(b.odometer));

    double totalLiters = 0;
    double totalDistance = records.last.odometer - records.first.odometer;

    // We don't count the first fill-up's liters because it got us to the starting line
    for (int i = 1; i < records.length; i++) {
      totalLiters += records[i].liters;
    }

    if (totalDistance == 0) return 0.0;
    return (totalLiters / totalDistance) * 100;
  }
}
