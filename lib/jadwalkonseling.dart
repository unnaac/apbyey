import 'package:flutter/material.dart';
import 'buatjadwal.dart'; // Hapus salah satu impor yang sama
import 'clipper.dart';

class JadwalScreen extends StatefulWidget {
  const JadwalScreen({super.key});

  @override
  State<JadwalScreen> createState() => _JadwalScreenState();
}

class _JadwalScreenState extends State<JadwalScreen> {
  String selectedDay = "Senin";

  // Daftar konselor dalam bentuk list
  final List<Map<String, dynamic>> konselors = [
    {
      "name": "Rosi Hernawati, M.Psi., Psikolog",
      "details": [
        "Tumbuh kembang anak & remaja",
        "Perlindungan & pencegahan kekerasan",
        "Pemilihan karir",
      ],
      "days": ["Selasa", "Minggu"],
    },
    {
      "name": "Shinta Putrinanda, M.Psi., Psikolog",
      "details": ["Motivasi", "Pemilihan karir", "Gangguan kecemasan"],
      "days": ["Senin", "Kamis", "Minggu"],
    },
    {
      "name": "Dian Puspitasari, M.Psi., Psikolog",
      "details": ["Kesehatan mental", "Manajemen stres", "Relasi keluarga"],
      "days": ["Selasa", "Sabtu"],
    },
    {
      "name": "Budi Santoso, M.Psi., Psikolog",
      "details": ["Konseling pasangan", "Masalah pernikahan", "Trauma"],
      "days": ["Jumat"],
    },
    {
      "name": "Nadia Lestari, M.Psi., Psikolog",
      "details": ["Kecanduan digital", "Gangguan tidur", "Psikologi remaja"],
      "days": ["Selasa"],
    },
    {
      "name": "Agus Prasetyo, M.Psi., Psikolog",
      "details": ["Konseling karir", "Pengembangan diri", "Public speaking"],
      "days": ["Jumat", "Kamis"],
    },
    {
      "name": "Tania Nurhaliza, M.Psi., Psikolog",
      "details": ["Perilaku anak", "Psikologi pendidikan", "Isolasi sosial"],
      "days": ["Jumat", "Minggu"],
    },
    {
      "name": "Yoga Rahman, M.Psi., Psikolog",
      "details": ["Manajemen emosi", "Motivasi hidup", "Self healing"],
      "days": ["Sabtu", "Minggu"],
    },
  ];

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
                      icon: const Icon(Icons.arrow_back, color: Colors.white),
                      onPressed: () => Navigator.pop(context),
                    ),
                    const SizedBox(width: 10),
                    const Text(
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
                scrollDirection: Axis.horizontal,
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
                              selectedDay = day;
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
                            side: const BorderSide(color: Colors.red),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),

            // Hanya tampilkan konselor sesuai hari yang dipilih
            ...konselors
                .where((k) => (k['days'] as List).contains(selectedDay))
                .map((k) => _buildKonselorCard(
                      k['name'] as String,
                      List<String>.from(k['details'] as List),
                      List<String>.from(k['days'] as List),
                    ))
                .toList(),
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
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 1,
            blurRadius: 0.1,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.person, color: Colors.red),
              const SizedBox(width: 8),
              Text(name, style: const TextStyle(fontWeight: FontWeight.bold)),
            ],
          ),
          const Divider(),
          const SizedBox(height: 8),
          ...details.map((detail) => Text("• $detail")),
          const SizedBox(height: 10),
          Row(
            children: [
              Wrap(
                spacing: 4,
                children: days.map((day) {
                  return Chip(
                    label: Text(
                      day,
                      style: const TextStyle(color: Colors.red, fontSize: 12),
                    ),
                    backgroundColor: Colors.red.withOpacity(0.2),
                  );
                }).toList(),
              ),
              const Spacer(),
              TextButton(
                onPressed: () {
                  // Menambahkan kode untuk mengirim data psikolog ke halaman booking
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => BookingScreen(
                        selectedPsikolog: name, // Mengirim nama psikolog
                        availableDays: days,
                      ),
                    ),
                  );
                },
                style: TextButton.styleFrom(
                  side: const BorderSide(color: Colors.red),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                child: const Text(
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
