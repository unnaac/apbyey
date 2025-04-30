import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:intl/intl.dart';

class LaporanDB {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final DatabaseReference _database = FirebaseDatabase.instance.ref();

  // Function to save laporan data to Firebase
  Future<void> saveLaporan({
    required String deskripsi,
    required String lokasi,
    required String anonim,
    required String status,
    required DateTime tanggal, 
    String? uploadedFile,
  }) async {
    User? user = _firebaseAuth.currentUser;

    if (user != null) {
      String formattedTanggal = DateFormat('dd-MM-yyyy').format(tanggal);

      final now = DateTime.now();
      String formattedTimestamp = DateFormat('dd-MM-yyyy HH:mm')
          .format(now); 

      final laporanRef = _database.child('laporan').push();
      final data = {
        'deskripsi': deskripsi,
        'lokasi': lokasi,
        'anonim': anonim,
        'status': status,
        'tanggal': formattedTanggal, 
        'timestamp': formattedTimestamp, 
        'uploadedFile': uploadedFile ?? '',
      };

      if (anonim == "Tidak") {
        data['userId'] = user.uid;
      }

      await laporanRef.set(data);
    }
  }
}
