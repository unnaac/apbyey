import 'package:flutter/material.dart';

class DetailLaporanPage extends StatelessWidget {
  final Map laporan;

  DetailLaporanPage({required this.laporan});

  @override
  Widget build(BuildContext context) {
    final tanggal = laporan['tanggal'] ?? '-';
    final anonim = laporan['anonim'] == true
        ? 'Anonim'
        : (laporan['username'] ?? 'Tidak diketahui');
    final status = laporan['status'] ?? 'Tidak diketahui';
    final deskripsi = laporan['deskripsi'] ?? '-';
    final lokasi = laporan['lokasi'] ?? '-';
    final uploadedFile = laporan['uploadedFile'] ?? null;

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
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(tanggal.toString().substring(0, 10),
                  style: TextStyle(color: Colors.grey)),
              SizedBox(height: 10),
              Text(anonim, style: TextStyle(fontWeight: FontWeight.bold)),
              Text(status, style: TextStyle(color: Colors.grey)),
              SizedBox(height: 10),
              Text("Deskripsi", style: TextStyle(fontWeight: FontWeight.bold)),
              Text(deskripsi),
              SizedBox(height: 10),
              Text("Lokasi", style: TextStyle(fontWeight: FontWeight.bold)),
              Text(lokasi),
              SizedBox(height: 10),
              Text("Bukti", style: TextStyle(fontWeight: FontWeight.bold)),
              Container(
                height: 200,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: uploadedFile != null && uploadedFile != ''
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image.network(
                          uploadedFile,
                          fit: BoxFit.cover,
                        ),
                      )
                    : Center(child: Text("Tidak ada bukti")),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
