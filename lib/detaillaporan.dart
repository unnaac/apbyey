import 'package:flutter/material.dart';

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
