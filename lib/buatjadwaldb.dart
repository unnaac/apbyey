import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:intl/intl.dart';

class JadwalDB {
  // Mengubah nama class menjadi JadwalDB
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final DatabaseReference _database = FirebaseDatabase.instance.ref();
  static const String _jadwalPath = 'jadwal_konseling'; // Mengubah nama path

  // Fungsi untuk menyimpan data jadwal ke database
  Future<void> simpanJadwal({
    required String jenisKunjungan,
    required String media,
    required DateTime tanggal,
    required String waktu,
    required String psikolog,
  }) async {
    final user = _firebaseAuth.currentUser;
    if (user == null) throw Exception("User not logged in");

    final formattedDate = DateFormat('dd-MM-yyyy').format(tanggal);

    // Validasi ulang di server-side
    final existingRef =
        _database.child(_jadwalPath).orderByChild('psikolog').equalTo(psikolog);

    final existingSnapshot = await existingRef.get();

    if (existingSnapshot.exists) {
      final bookings = Map<String, dynamic>.from(existingSnapshot.value as Map);
      final isBooked = bookings.values
          .any((b) => b['tanggal'] == formattedDate && b['waktu'] == waktu);

      if (isBooked) {
        throw Exception('Slot sudah dipesan');
      }
    }

    // Jika valid, simpan data
    await _database.child(_jadwalPath).push().set({
      'jenis_kunjungan': jenisKunjungan,
      'media': media,
      'tanggal': formattedDate,
      'waktu': waktu,
      'psikolog': psikolog,
      'userId': user.uid,
      'timestamp': ServerValue.timestamp,
    });
  }

  // Anda bisa menambahkan fungsi lain sesuai kebutuhan,
  // seperti mengambil jadwal pengguna, dll.
}
