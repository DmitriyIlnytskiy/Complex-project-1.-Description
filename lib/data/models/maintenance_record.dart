class MaintenanceRecord {
  final String id;
  final String title;
  final DateTime date;
  final double cost;
  final String notes;

  MaintenanceRecord({
    required this.id,
    required this.title,
    required this.date,
    required this.cost,
    this.notes = '',
  });

  factory MaintenanceRecord.fromMap(
    Map<String, dynamic> map,
    String documentId,
  ) {
    return MaintenanceRecord(
      id: documentId,
      title: map['title'] ?? '',
      date: DateTime.parse(map['date']),
      cost: (map['cost'] ?? 0.0).toDouble(),
      notes: map['notes'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'date': date.toIso8601String(),
      'cost': cost,
      'notes': notes,
    };
  }
}
