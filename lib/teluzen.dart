import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_time_picker_spinner/flutter_time_picker_spinner.dart';
import 'package:telu/buatjadwal.dart';
import 'package:telu/buatteluzen.dart';
import 'package:telu/clipper.dart';
import 'package:telu/komentar.dart';

class TeluzenScreen extends StatefulWidget {
  @override
  State<TeluzenScreen> createState() => _TeluzenScreenState();
}

class _TeluzenScreenState extends State<TeluzenScreen> {
  // Variabel untuk melacak status "suka"
  bool isLiked = false;

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(statusBarColor: Colors.red),
    );
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
                child: Row(
                  children: [
                    IconButton(
                      icon: Icon(Icons.arrow_back, color: Colors.white),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                    SizedBox(width: 10),
                    Text(
                      "Suara Teluzen",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Container(
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
                children: [
                  ListTile(
                    leading: CircleAvatar(),
                    title: Text(
                      'Nathan Dava',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: Text(
                      '2 Jam yang lalu',
                      style: TextStyle(fontSize: 10),
                    ),
                    trailing: IconButton(
                      onPressed: () {
                        _showBottomSheet(context);
                      },
                      icon: Icon(Icons.menu, size: 20),
                    ),
                    dense: true,
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 0,
                      vertical: 0,
                    ),
                  ),
                  Text(
                    'Lorem ipsum dolor sit amet, consectetur adipisicing elit. Officiis officia nesciunt voluptate perferendis a esse tenetur impedit minima vel',
                    style: TextStyle(fontSize: 12),
                  ),
                  Divider(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TextButton.icon(
                        style: ButtonStyle(
                          padding: MaterialStateProperty.all(
                            EdgeInsets.symmetric(horizontal: 0, vertical: 0),
                          ),
                        ),
                        onPressed: () {
                          setState(() {
                            isLiked = !isLiked; // Toggle status "suka"
                          });
                        },
                        icon: Icon(
                          isLiked ? Icons.favorite : Icons.favorite_border,
                          color: isLiked ? Colors.red : Colors.red,
                          size: 18,
                        ),
                        label: Text("Suka", style: TextStyle(fontSize: 12)),
                      ),
                      TextButton.icon(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => KomenScreen(),
                            ),
                          );
                        },
                        icon: Icon(Icons.comment, color: Colors.blue, size: 18),
                        label: Text("Komentar", style: TextStyle(fontSize: 12)),
                      ),
                      TextButton.icon(
                        onPressed: () {},
                        icon: Icon(Icons.share, color: Colors.green, size: 18),
                        label: Text("Bagikan", style: TextStyle(fontSize: 12)),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => BuatTeluzenScreen()),
          );
        },
        backgroundColor: Colors.red,
        child: Icon(Icons.post_add_rounded, color: Colors.white),
      ),
    );
  }

  void _showBottomSheet(BuildContext context) {
    showModalBottomSheet(
      backgroundColor: Colors.white,
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(16),
        ), // Sudut atas melengkung
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                dense: true,
                leading: Icon(Icons.edit, color: Colors.blue),
                title: Text(
                  'Edit',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                ),
                onTap: () {
                  Navigator.pop(context);
                  // Tambahkan aksi edit di sini
                },
              ),
              ListTile(
                dense: true,
                leading: Icon(Icons.delete, color: Colors.red),
                title: Text(
                  'Hapus',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                ),
                onTap: () {
                  Navigator.pop(context);
                  // Tambahkan aksi hapus di sini
                },
              ),
            ],
          ),
        );
      },
    );
  }
}