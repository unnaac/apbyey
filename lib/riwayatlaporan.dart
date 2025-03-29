import 'package:flutter/material.dart';

class RiwayatLaporanPage extends StatelessWidget {
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
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: List.generate(5, (index) => _buildLaporanCard(context)),
        ),
      ),
    );
  }

  Widget _buildLaporanCard(BuildContext context) {
    return Card(
      margin: EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Judul Laporan", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            SizedBox(height: 5),
            Text("Tanggal: 25 Maret 2025", style: TextStyle(color: Colors.grey)),
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
                  child: Text("Diproses", style: TextStyle(color: Colors.black)),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFFED1E28),
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => DetailLaporanPage()),
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

class DetailLaporanPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFFED1E28),
        title: Text("Detail Laporan", style: TextStyle(color: Colors.white)),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("12 Februari 2025", style: TextStyle(color: Colors.grey)),
            SizedBox(height: 10),
            Text("Anonim", style: TextStyle(fontWeight: FontWeight.bold)),
            Text("Korban", style: TextStyle(color: Colors.grey)),
            SizedBox(height: 10),
            Text("Deskripsi", style: TextStyle(fontWeight: FontWeight.bold)),
            Text("Saat di kampus, saya mengalami pelecehan seksual. Kejadiannya di KUI."),
            SizedBox(height: 10),
            Text("Lokasi", style: TextStyle(fontWeight: FontWeight.bold)),
            Text("Jl. Telekomunikasi No.1 Kabupaten Bandung"),
            SizedBox(height: 10),
            Text("Bukti", style: TextStyle(fontWeight: FontWeight.bold)),
            Container(
              height: 100,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
