import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'navbar.dart';
import 'auth.dart';
import 'login.dart';
import 'package:flutter/services.dart';
import 'jadwalkonseling.dart';
import 'riwayatKsl.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({Key? key}) : super(key: key);

  @override
  _DashboardPageState createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  int _selectedIndex = 0;
  final Auth _auth = Auth();
  String username = "Loading...";
  String nik = "";

  @override
  void initState() {
    super.initState();
    _getUserData();
  }

  Future<void> _getUserData() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      DatabaseReference userRef =
          FirebaseDatabase.instance.ref().child("users").child(user.uid);
      userRef.once().then((DatabaseEvent event) {
        DataSnapshot snapshot = event.snapshot;
        if (snapshot.value != null) {
          Map<dynamic, dynamic> userData =
              snapshot.value as Map<dynamic, dynamic>;
          setState(() {
            username = userData["username"] ?? "User";
            nik = userData["nik"] ?? "Unknown";
          });
        }
      });
    }
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
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
        child: SingleChildScrollView(
          child: Column(
            children: [
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
                          backgroundImage: AssetImage('assets/profile.png'),
                        ),
                        const SizedBox(width: 10),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(username,
                                style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white)),
                            Text(nik,
                                style: const TextStyle(
                                    fontSize: 14, color: Colors.white)),
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
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Hai, $username!",
                                  style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black)),
                              Text("Apa kabar hari ini?",
                                  style: TextStyle(
                                      fontSize: 14, color: Colors.black)),
                            ],
                          ),
                          ElevatedButton(
                            onPressed:
                                _signOut, // Memanggil fungsi signOut yang benar
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red,
                              foregroundColor: Colors.white,
                            ),
                            child: const Text("Cerita disini Logout"),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: GridView.count(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisCount: 4,
                  children: [
                    _buildFeatureIcon("Buat Laporan", "assets/report.png", () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => JadwalScreen()));
                    }),
                    _buildFeatureIcon("Riwayat Laporan", "assets/history.png",
                        () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => JadwalScreen()));
                    }),
                    _buildFeatureIcon("Jadwal Konseling", "assets/schedule.png",
                        () {
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
                              builder: (context) => RiwayatKonselingPage()));
                    }),
                    _buildFeatureIcon("Emosiku", "assets/emotion.png", () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => JadwalScreen()));
                    }),
                    _buildFeatureIcon("Catatan Harian", "assets/journal.png",
                        () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => JadwalScreen()));
                    }),
                    _buildFeatureIcon("Suara Telutizen", "assets/forum.png",
                        () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => JadwalScreen()));
                    }),
                    _buildFeatureIcon("FAQ", "assets/faq.png", () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => JadwalScreen()));
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
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFFED1E28),
        onPressed: () {},
        child: const Icon(Icons.emoji_emotions, color: Colors.white),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
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
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 4,
                  offset: Offset(2, 2),
                ),
              ],
            ),
            child: Image.asset(assetPath, width: 40, height: 40),
          ),
          const SizedBox(height: 5),
          Text(label,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 10)),
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
