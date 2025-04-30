// emosikudb.dart
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:intl/intl.dart';

class EmosiDB {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final DatabaseReference _database = FirebaseDatabase.instance.ref();

  Future<void> saveEmosi({
    required String mood,
    required String faktor,
    required String catatan,
    required DateTime tanggal,
  }) async {
    User? user = _firebaseAuth.currentUser;
    if (user == null) throw Exception("User not logged in");

    final String tanggalHariIni = DateFormat('dd-MM-yyyy').format(tanggal);

    await _database.child("emosiku/${user.uid}/$tanggalHariIni").set({
      "mood": mood,
      "faktor": faktor,
      "catatan": catatan,
      "timestamp": DateFormat('dd-MM-yyyy HH:mm:ss').format(tanggal),
    });
  }

  Future<List<Map<String, dynamic>>> getEmosiData() async {
    final user = _firebaseAuth.currentUser;
    if (user == null) return [];

    try {
      final snapshot = await _database.child("emosiku/${user.uid}").get();
      if (!snapshot.exists) return [];

      final List<Map<String, dynamic>> records = [];
      final data = Map<String, dynamic>.from(snapshot.value as Map);

      data.forEach((key, value) {
        records.add({
          'id': key,
          ...Map<String, dynamic>.from(value),
        });
      });

      // Sort by timestamp (newest first)
      records.sort((a, b) {
        final dateA = DateFormat('dd-MM-yyyy HH:mm').parse(a['timestamp']);
        final dateB = DateFormat('dd-MM-yyyy HH:mm').parse(b['timestamp']);
        return dateB.compareTo(dateA);
      });

      return records;
    } catch (e) {
      throw Exception("Failed to fetch data: $e");
    }
  }
}
