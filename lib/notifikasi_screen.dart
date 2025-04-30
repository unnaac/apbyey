import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'navbar.dart';
import 'teluzen.dart';
import 'akun_screen.dart';
import 'dashboard.dart';

class NotifikasiScreen extends StatefulWidget {
  const NotifikasiScreen({Key? key}) : super(key: key);

  @override
  _NotifikasiScreenState createState() => _NotifikasiScreenState();
}

class _NotifikasiScreenState extends State<NotifikasiScreen> {
  final DatabaseReference _database = FirebaseDatabase.instance.ref();
  List<Map<String, dynamic>> notifikasiList = [];
  bool isLoading = true;
  int _selectedIndex = 2;

  @override
  void initState() {
    super.initState();
    fetchNotifikasi();
  }

  Future<void> fetchNotifikasi() async {
    try {
      final snapshot = await _database.child('notifikasi').get();

      if (snapshot.exists) {
        final data = Map<String, dynamic>.from(snapshot.value as Map);
        List<Map<String, dynamic>> listNotifikasi = [];

        data.forEach((key, value) {
          listNotifikasi.add({
            'key': key,
            ...Map<String, dynamic>.from(value),
          });
        });

        // Sort berdasarkan time terbaru
        listNotifikasi
            .sort((a, b) => (b['time'] ?? '').compareTo(a['time'] ?? ''));

        setState(() {
          notifikasiList = listNotifikasi;
          isLoading = false;
        });
      } else {
        setState(() {
          isLoading = false;
        });
      }
    } catch (e) {
      print('Error fetching notifikasi: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  void _onItemTapped(int index) {
    if (index == 0) {
      // Indeks 0 adalah tombol "Dashboard"
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => DashboardPage()),
      );
    } else if (index == 1) {
      // Indeks 1 adalah tombol "Linimasa"
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) =>
                TeluzenScreen()), // Ganti dengan nama screen yang sesuai
      );
    } else if (index == 2) {
      // Indeks 2 adalah tombol "Notifikasi"
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => NotifikasiScreen()),
      );
    } else if (index == 3) {
      // Indeks 3 adalah tombol "Akun"
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) =>
                AkunScreen()), // Ganti dengan nama screen yang sesuai
      );
    } else {
      setState(() {
        _selectedIndex = index;
      });
      // Tambahkan logika untuk indeks lain jika diperlukan
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // Header
          Container(
            color: Colors.red,
            child: Column(
              children: [
                Container(
                  height: 64,
                  color: Colors.white,
                  child: Row(
                    children: [
                      IconButton(
                        icon: Icon(Icons.arrow_back, color: Colors.black),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                      Text(
                        'Notifikasi',
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          // Notifications List
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: isLoading
                  ? Center(child: CircularProgressIndicator())
                  : notifikasiList.isEmpty
                      ? Center(child: Text('Belum ada notifikasi'))
                      : ListView.builder(
                          itemCount: notifikasiList.length,
                          itemBuilder: (context, index) {
                            final notif = notifikasiList[index];
                            return notificationCard(
                              notif['title'] ?? '',
                              notif['message'] ?? '',
                              notif['time'] ?? '',
                            );
                          },
                        ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: CustomNavBar(
        onItemTapped: _onItemTapped,
        selectedIndex: _selectedIndex,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.red,
        child: Icon(Icons.sentiment_satisfied),
        onPressed: () {
          // TODO: Aksi tombol tengah
        },
      ),
    );
  }

  Widget notificationCard(String title, String message, String time) {
    return Card(
      elevation: 2,
      margin: EdgeInsets.symmetric(vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: TextStyle(fontWeight: FontWeight.bold)),
                SizedBox(height: 4),
                Text(message),
              ],
            ),
            Text(time, style: TextStyle(color: Colors.grey)),
          ],
        ),
      ),
    );
  }
}
