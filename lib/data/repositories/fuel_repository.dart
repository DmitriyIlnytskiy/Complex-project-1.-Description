import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/fuel_record.dart';

class FuelRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String userId;

  FuelRepository({required this.userId});

  Future<List<FuelRecord>> getFuelRecords() async {
    final snapshot = await _firestore
        .collection('users')
        .doc(userId)
        .collection('fuel_logs')
        .orderBy('odometer', descending: true)
        .get();

    return snapshot.docs
        .map((doc) => FuelRecord.fromMap(doc.data(), doc.id))
        .toList();
  }

  Future<void> addFuelRecord(FuelRecord record) async {
    await _firestore
        .collection('users')
        .doc(userId)
        .collection('fuel_logs')
        .add(record.toMap());
  }
}
