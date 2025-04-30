import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'navbar.dart';
import 'auth.dart';
import 'login.dart';
import 'package:flutter/services.dart';
import 'jadwalkonseling.dart';
import 'riwayatKsl.dart';
import 'buatteluzen.dart';
import 'laporan.dart';
import 'riwayatlaporan.dart';
import 'emosiku_screen.dart';
import 'catatan_harian_screen.dart';
import 'faq.dart';
import 'teluzen.dart';
import 'notifikasi_screen.dart';
import 'akun_screen.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({Key? key}) : super(key: key);

  @override
  _DashboardPageState createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  int _selectedIndex = 0;
  final Auth _auth = Auth();
  late Future<Map<String, dynamic>> _userDataFuture;

  @override
  void initState() {
    super.initState();
    _userDataFuture = _getUserData();
  }

  Future<Map<String, dynamic>> _getUserData() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      DatabaseReference userRef =
          FirebaseDatabase.instance.ref().child("users").child(user.uid);
      DatabaseEvent event = await userRef.once();

      if (event.snapshot.value != null) {
        Map<dynamic, dynamic> data =
            event.snapshot.value as Map<dynamic, dynamic>;
        return {
          'username': data['username'] ?? 'User',
          'nik': data['nik'] ?? '',
          'email': data['email'] ?? '',
          'phone': data['phone'] ?? '',
        };
      }
    }
    return {
      'username': 'User',
      'nik': '',
      'email': '',
      'phone': '',
    };
  }

  void _onItemTapped(int index) {
    if (index == 1) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => TeluzenScreen()),
      );
    } else if (index == 2) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => NotifikasiScreen()),
      );
    } else if (index == 3) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => AkunScreen()),
      );
    } else {
      setState(() {
        _selectedIndex = index;
      });
    }
  }

  Future<void> _signOut() async {
    await _auth.signOut();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const LoginPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
      ),
    );

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: null,
      body: SafeArea(
        child: FutureBuilder<Map<String, dynamic>>(
          future: _userDataFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            final userData = snapshot.data ??
                {
                  'username': 'User',
                  'nik': '',
                  'email': '',
                  'phone': '',
                };

            return SingleChildScrollView(
              child: Column(
                children: [
                  // Header Section
                  Container(
                    padding: const EdgeInsets.all(16.0),
                    decoration: const BoxDecoration(
                      color: Color(0xFFED1E28),
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(30),
                        bottomRight: Radius.circular(30),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const CircleAvatar(
                              radius: 25,
                              backgroundImage: AssetImage('assets/profile.png'),
                            ),
                            const SizedBox(width: 10),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  userData['username'],
                                  style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white),
                                ),
                                Text(
                                  userData['nik'],
                                  style: const TextStyle(
                                      fontSize: 14, color: Colors.white),
                                ),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        Container(
                          padding: const EdgeInsets.all(16.0),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black12,
                                blurRadius: 6,
                                offset: Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Hai, ${userData['username']}!",
                                    style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black),
                                  ),
                                  const Text(
                                    "Apa kabar hari ini?",
                                    style: TextStyle(
                                        fontSize: 14, color: Colors.black),
                                  ),
                                ],
                              ),
                              ElevatedButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => EmosikuScreen()),
                                  );
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.red,
                                  foregroundColor: Colors.white,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                                child: const Text("Cerita disini"),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Features Grid
                  const SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: GridView.count(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      crossAxisCount: 4,
                      children: [
                        _buildFeatureIcon("Buat Laporan", "assets/report.png",
                            () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => LaporanPage()));
                        }),
                        _buildFeatureIcon(
                            "Riwayat Laporan", "assets/history.png", () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => RiwayatLaporanPage()));
                        }),
                        _buildFeatureIcon(
                            "Jadwal Konseling", "assets/schedule.png", () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => JadwalScreen()));
                        }),
                        _buildFeatureIcon(
                            "Riwayat Konseling", "assets/counseling.png", () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      RiwayatKonselingPage()));
                        }),
                        _buildFeatureIcon("Emosiku", "assets/emotion.png", () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => EmosikuScreen()));
                        }),
                        _buildFeatureIcon(
                            "Catatan Harian", "assets/journal.png", () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => CatatanHarianScreen()));
                        }),
                        _buildFeatureIcon("Suara Telutizen", "assets/forum.png",
                            () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => BuatTeluzenScreen()));
                        }),
                        _buildFeatureIcon("FAQ", "assets/faq.png", () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => FaqScreen()));
                        }),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text("Berita Telkom University",
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 10),
                        _buildNewsCard("Alur Konseling Via Hotline",
                            "Konseling BK (Whatsapp Only)"),
                        _buildNewsCard(
                            "Begini Cara Menggunakan Layanan BK", "13.43 WIB"),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),

      // Floating Action Button
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFFED1E28),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => EmosikuScreen()),
          );
        },
        child: const Icon(Icons.emoji_emotions, color: Colors.white),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,

      // Bottom Navigation Bar
      bottomNavigationBar: CustomNavBar(
        onItemTapped: _onItemTapped,
        selectedIndex: _selectedIndex,
      ),
    );
  }

  Widget _buildFeatureIcon(String label, String assetPath, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 4,
                  offset: const Offset(2, 2),
                )
              ],
            ),
            child: Image.asset(assetPath, width: 30, height: 30),
          ),
          const SizedBox(height: 5),
          Text(
            label,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 10),
          ),
        ],
      ),
    );
  }

  Widget _buildNewsCard(String title, String subtitle) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: ListTile(
        leading: Image.asset("assets/alur.png", width: 40, height: 40),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(subtitle),
      ),
    );
  }
}
