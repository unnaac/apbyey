import 'package:flutter/material.dart';

class NotifikasiScreen extends StatelessWidget {
  const NotifikasiScreen({Key? key}) : super(key: key);

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
              child: ListView(
                children: [
                  notificationCard('Mahasiswa', 'Selamat berpuasa!', '2 jam yang lalu'),
                  notificationCard('Anda', 'Tetap semangat!', '2 jam yang lalu'),
                  notificationCard('Anda', 'Kamu pasti bisa!', '2 jam yang lalu'),
                ],
              ),
            ),
          ),
          // Bottom Navigation
          Container(
            color: Colors.white,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Column(
                  children: [
                    Icon(Icons.home, color: Colors.grey),
                    Text('Beranda', style: TextStyle(fontSize: 12, color: Colors.grey)),
                  ],
                ),
                Column(
                  children: [
                    Icon(Icons.list, color: Colors.grey),
                    Text('Linimasa', style: TextStyle(fontSize: 12, color: Colors.grey)),
                  ],
                ),
                Column(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.red,
                        shape: BoxShape.circle,
                      ),
                      padding: EdgeInsets.all(12),
                      child: Icon(Icons.sentiment_satisfied, color: Colors.white),
                    ),
                  ],
                ),
                Column(
                  children: [
                    Icon(Icons.notifications, color: Colors.red),
                    Text('Notifikasi', style: TextStyle(fontSize: 12, color: Colors.red)),
                  ],
                ),
                Column(
                  children: [
                    Icon(Icons.person, color: Colors.grey),
                    Text('Akun', style: TextStyle(fontSize: 12, color: Colors.grey)),
                  ],
                ),
              ],
            ),
          ),
        ],
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
