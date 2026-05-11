class FuelRecord {
  final String id;
  final DateTime date;
  final double liters;
  final double cost;
  final double odometer;

  FuelRecord({
    required this.id,
    required this.date,
    required this.liters,
    required this.cost,
    required this.odometer,
  });

  factory FuelRecord.fromMap(Map<String, dynamic> map, String documentId) {
    return FuelRecord(
      id: documentId,
      date: DateTime.parse(map['date']),
      liters: (map['liters'] ?? 0.0).toDouble(),
      cost: (map['cost'] ?? 0.0).toDouble(),
      odometer: (map['odometer'] ?? 0.0).toDouble(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'date': date.toIso8601String(),
      'liters': liters,
      'cost': cost,
      'odometer': odometer,
    };
  }
}
