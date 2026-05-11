import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/maintenance_record.dart';

class MaintenanceRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String userId; // Passed in after Auth

  MaintenanceRepository({required this.userId});

  Future<List<MaintenanceRecord>> getRecords() async {
    try {
      final snapshot = await _firestore
          .collection('users')
          .doc(userId)
          .collection('maintenance_logs')
          .orderBy('date', descending: true)
          .get();

      return snapshot.docs
          .map((doc) => MaintenanceRecord.fromMap(doc.data(), doc.id))
          .toList();
    } catch (e) {
      throw Exception('Failed to load maintenance records: $e');
    }
  }

  Future<void> addRecord(MaintenanceRecord record) async {
    try {
      await _firestore
          .collection('users')
          .doc(userId)
          .collection('maintenance_logs')
          .add(record.toMap());
    } catch (e) {
      throw Exception('Failed to add record: $e');
    }
  }

  Future<void> deleteRecord(String recordId) async {
    try {
      await _firestore
          .collection('users')
          .doc(userId)
          .collection('maintenance_logs')
          .doc(recordId)
          .delete();
    } catch (e) {
      throw Exception('Failed to delete record: $e');
    }
  }

  Future<void> updateRecord(MaintenanceRecord record) async {
    try {
      await _firestore
          .collection('users')
          .doc(userId)
          .collection('maintenance_logs')
          .doc(record.id)
          .update(record.toMap());
    } catch (e) {
      throw Exception('Failed to update record: $e');
    }
  }
}
