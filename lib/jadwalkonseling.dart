import 'package:flutter/material.dart';
import 'buatjadwal.dart';
import 'clipper.dart';

class JadwalScreen extends StatefulWidget {
  const JadwalScreen({super.key});

  @override
  State<JadwalScreen> createState() => _JadwalScreenState();
}

class _JadwalScreenState extends State<JadwalScreen> {
  String selectedDay = "Senin";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            ClipPath(
              clipper: MyClipper(),
              child: Container(
                color: Colors.red,
                height: 120,
                padding: EdgeInsets.only(top: 40, left: 16),
                child: Row(
                  children: [
                    IconButton(
                      icon: Icon(Icons.arrow_back, color: Colors.white),
                      onPressed: () => Navigator.pop(context),
                    ),
                    SizedBox(width: 10),
                    Text(
                      "Jadwal Konseling",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal, // Scroll ke samping
                child: Row(
                  children: [
                    for (var day in [
                      "Senin",
                      "Selasa",
                      "Rabu",
                      "Kamis",
                      "Jumat",
                      "Sabtu",
                      "Minggu",
                    ])
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4.0),
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              selectedDay = day; // Simpan hari yang dipilih
                            });
                          },
                          child: Chip(
                            label: Text(
                              day,
                              style: TextStyle(
                                color: selectedDay == day
                                    ? Colors.white
                                    : Colors.red,
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                              ),
                            ),
                            backgroundColor:
                                selectedDay == day ? Colors.red : Colors.white,
                            side: BorderSide(color: Colors.red),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
            _buildKonselorCard(
              "Rosi Hernawati, M.Psi., Psikolog",
              [
                "Tumbuh kembang anak & remaja",
                "Perlindungan & pencegahan kekerasan",
                "Pemilihan karir",
              ],
              ["Selasa"],
            ),
            _buildKonselorCard(
              "Shinta Putrinanda, M.Psi., Psikolog",
              ["Motivasi", "Pemilihan karir", "Gangguan kecemasan"],
              ["Senin", "Kamis"],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildKonselorCard(
    String name,
    List<String> details,
    List<String> days,
  ) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      width: double.infinity,
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white, // Warna background
        borderRadius: BorderRadius.circular(10), // Sudut membulat
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 1,
            blurRadius: 0.1,
            offset: Offset(0, 1), // Efek bayangan
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.person, color: Colors.red),
              SizedBox(width: 8),
              Text(name, style: TextStyle(fontWeight: FontWeight.bold)),
            ],
          ),
          Divider(),
          SizedBox(height: 8),
          ...details.map((detail) => Text("• $detail")),
          SizedBox(height: 10),
          Row(
            children: [
              Wrap(
                spacing: 4, // Jarak antar Chip
                children: days.map((day) {
                  return Chip(
                    label: Text(
                      day,
                      style: TextStyle(color: Colors.red, fontSize: 12),
                    ),
                    backgroundColor: Colors.red.withOpacity(0.2),
                  );
                }).toList(),
              ),
              Spacer(),
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => BookingScreen()),
                  );
                },
                style: TextButton.styleFrom(
                  side: BorderSide(color: Colors.red),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                child: Text(
                  "Buat Jadwal",
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
