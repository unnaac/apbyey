import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'detailKsl.dart';
import 'clipper.dart';

class RiwayatKonselingPage extends StatefulWidget {
  const RiwayatKonselingPage({Key? key}) : super(key: key);

  @override
  _RiwayatKonselingPageState createState() => _RiwayatKonselingPageState();
}

class _RiwayatKonselingPageState extends State<RiwayatKonselingPage> {
  final DatabaseReference _database = FirebaseDatabase.instance.ref();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  List<Map<String, dynamic>> riwayatKonseling = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchRiwayat();
  }

  Future<void> fetchRiwayat() async {
    final User? user = _auth.currentUser;
    if (user != null) {
      try {
        final uid = user.uid;
        final snapshot = await _database
            .child('jadwal_konseling')
            .orderByChild('userId')
            .equalTo(uid)
            .get();

        if (snapshot.exists) {
          final data = Map<String, dynamic>.from(snapshot.value as Map);
          final List<Map<String, dynamic>> tempList = [];

          data.forEach((key, value) {
            tempList.add({'key': key, ...Map<String, dynamic>.from(value)});
          });

          // Urutkan berdasarkan timestamp
          tempList.sort(
              (a, b) => (b['timestamp'] ?? 0).compareTo(a['timestamp'] ?? 0));

          setState(() {
            riwayatKonseling = tempList;
            isLoading = false;
          });
        } else {
          setState(() {
            isLoading = false;
            riwayatKonseling = [];
          });
        }
      } catch (e) {
        print("Error fetching data: $e");
        setState(() {
          isLoading = false;
        });
      }
    } else {
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          ClipPath(
            clipper: MyClipper(),
            child: Container(
              color: Colors.red,
              height: 120,
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.white),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                  const SizedBox(width: 10),
                  const Text(
                    "Riwayat Konseling",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),
          Expanded(
            child: isLoading
                ? const Center(child: CircularProgressIndicator())
                : riwayatKonseling.isEmpty
                    ? const Center(child: Text("Belum ada riwayat konseling."))
                    : ListView.builder(
                        padding: const EdgeInsets.all(16.0),
                        itemCount: riwayatKonseling.length,
                        itemBuilder: (context, index) {
                          final item = riwayatKonseling[index];
                          return _buildConsultationCard(
                            context,
                            item['tanggal'] ?? '-',
                            item['psikolog'] ?? '-',
                            item['jenis_kunjungan'] ??
                                '-', // ganti diagnosis jadi jenis_kunjungan
                          );
                        },
                      ),
          ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFFED1E28),
        onPressed: () {},
        child: const Icon(Icons.emoji_emotions, color: Colors.white),
      ),
    );
  }

  Widget _buildConsultationCard(BuildContext context, String date,
      String psychologist, String diagnosis) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16.0),
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: const [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 4,
            offset: Offset(2, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                date,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  minimumSize: const Size(120, 40),
                ),
                child: Text(
                  diagnosis,
                  style: const TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(psychologist),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => DetailKonselingPage(
                        date: date,
                        psychologist: psychologist,
                        diagnosis: diagnosis,
                      ),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                    side: const BorderSide(color: Colors.red),
                  ),
                  minimumSize: const Size(120, 40),
                ),
                child: const Text(
                  "Lihat Detail",
                  style: TextStyle(color: Colors.red),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
