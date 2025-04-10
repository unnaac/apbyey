import 'package:flutter/material.dart';
import 'navbar.dart';
import 'detailKsl.dart';

class RiwayatKonselingPage extends StatelessWidget {
  const RiwayatKonselingPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          // Header Merah
          Stack(
            children: [
              Container(
                height: 100,
                decoration: const BoxDecoration(
                  color: Colors.red,
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(30),
                    bottomRight: Radius.circular(30),
                  ),
                ),
              ),
              Positioned(
                top: 40,
                left: 10,
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back,
                          color: Color.fromARGB(255, 255, 255, 255)),
                      onPressed: () => Navigator.pop(context),
                    ),
                    const Text(
                      "Riwayat Konseling",
                      style: TextStyle(
                        color: Color.fromARGB(255, 255, 255, 255),
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16.0),
              children: [
                _buildConsultationCard(
                    context,
                    "12 Februari 2025",
                    "Rosi Hernawati, M.Psi., Psikolog",
                    "Stres belajar, gangguan tidur, sulit fokus."),
                _buildConsultationCard(context, "10 Februari 2025",
                    "Dr. John Doe, Psikolog", "Stres kerja, kecemasan."),
                _buildConsultationCard(context, "5 Februari 2025",
                    "Jane Smith, M.Psi., Psikolog", "Depresi, gangguan tidur."),
              ],
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
      bottomNavigationBar: CustomNavBar(
        onItemTapped: (index) {},
        selectedIndex: 1,
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
                child: const Text(
                  "Lanjut",
                  style: TextStyle(color: Colors.white),
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
