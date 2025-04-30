import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'detaillaporan.dart';

class RiwayatLaporanPage extends StatefulWidget {
  @override
  _RiwayatLaporanPageState createState() => _RiwayatLaporanPageState();
}

class _RiwayatLaporanPageState extends State<RiwayatLaporanPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final DatabaseReference _database = FirebaseDatabase.instance.ref();
  List<Map<dynamic, dynamic>> laporanList = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchLaporan();
  }

  Future<void> fetchLaporan() async {
    User? user = _auth.currentUser;
    if (user == null) return;

    final snapshot = await _database
        .child('laporan')
        .orderByChild('userId')
        .equalTo(user.uid)
        .get();

    if (snapshot.exists) {
      List<Map<dynamic, dynamic>> tempList = [];
      snapshot.children.forEach((child) {
        final data = Map<dynamic, dynamic>.from(child.value as Map);
        data['id'] = child.key;
        tempList.add(data);
      });

      setState(() {
        laporanList = tempList;
        isLoading = false;
      });
    } else {
      setState(() {
        laporanList = [];
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFFED1E28),
        title: Text("Riwayat Laporan", style: TextStyle(color: Colors.white)),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : laporanList.isEmpty
              ? Center(child: Text("Belum ada laporan."))
              : ListView.builder(
                  padding: const EdgeInsets.all(16.0),
                  itemCount: laporanList.length,
                  itemBuilder: (context, index) {
                    return _buildLaporanCard(context, laporanList[index]);
                  },
                ),
    );
  }

  Widget _buildLaporanCard(BuildContext context, Map laporan) {
    return Card(
      margin: EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Laporan - ${laporan['tanggal'].toString().substring(0, 10)}",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            SizedBox(height: 5),
            Text("Status: ${laporan['status'] ?? '-'}",
                style: TextStyle(color: Colors.grey)),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Text("${laporan['anonim'] ?? 'Anonim'}",
                      style: TextStyle(color: Colors.black)),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFFED1E28)),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            DetailLaporanPage(laporan: laporan),
                      ),
                    );
                  },
                  child: Text("Detail", style: TextStyle(color: Colors.white)),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
