import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // Gantikan import system.dart dengan ini
import 'package:flutter_time_picker_spinner/flutter_time_picker_spinner.dart';
import 'buatjadwal.dart';
import 'dashboard.dart';
import 'clipper.dart';

class BuatTeluzenScreen extends StatefulWidget {
  @override
  State<BuatTeluzenScreen> createState() => _BuatTeluzenScreenState();
}

class _BuatTeluzenScreenState extends State<BuatTeluzenScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _textController = TextEditingController();
  String? _username;

  @override
  void initState() {
    super.initState();
    _loadUsername();
  }

  void _loadUsername() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      DatabaseReference userRef = FirebaseDatabase.instance.ref('users').child(user.uid);
      final snapshot = await userRef.get();
      if (snapshot.exists) {
        setState(() {
          _username = snapshot.child('username').value as String?;
        });
      } else {
        setState(() {
          _username = 'Username tidak tersedia';
        });
      }
    }
  }

  // Fungsi untuk mendapatkan waktu sekarang dalam format yang rapi
  String getCurrentFormattedTime() {
    DateTime now = DateTime.now();
    return "${now.day.toString().padLeft(2, '0')}-${now.month.toString().padLeft(2, '0')}-${now.year} ${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}";
  }

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
                      "Kirim Suara Telutizen",
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
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 1,
                    blurRadius: 0.1,
                    offset: Offset(0, 1),)
                ],
              ),
              child: Column(
                children: [
                  ListTile(
                    leading: CircleAvatar(),
                    title: Text(
                      _username ?? 'Loading...',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    dense: true,
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 0,
                      vertical: 0,
                    ),
                  ),
                  Form(
                    key: _formKey,
                    child: TextFormField(
                      controller: _textController,
                      keyboardType: TextInputType.multiline,
                      cursorColor: Colors.black,
                      maxLines: 15,
                      textInputAction: TextInputAction.newline,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey[700],
                      ),
                      decoration: InputDecoration(
                        hintText: 'Ketik disini',
                        hintStyle: TextStyle(color: Colors.grey[700]),
                        suffixStyle: TextStyle(color: Colors.black),
                        fillColor: Colors.white,
                        filled: true,
                        border: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.white.withOpacity(0.3),
                            width: 1.5,
                          ),
                          borderRadius: const BorderRadius.all(
                            Radius.circular(8),
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.white.withOpacity(0.3),
                            width: 1.5,
                          ),
                          borderRadius: const BorderRadius.all(
                            Radius.circular(8),
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.white.withOpacity(0.3),
                            width: 1.5,
                          ),
                          borderRadius: const BorderRadius.all(
                            Radius.circular(8),
                          ),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          vertical: 5,
                          horizontal: 10,
                        ),
                      ),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Teks tidak boleh kosong!';
                        }
                        return null;
                      },
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      OutlinedButton(
                        onPressed: () async {
                          if (_formKey.currentState?.validate() ?? false) {
                            String postText = _textController.text;
                            final user = FirebaseAuth.instance.currentUser;
                            if (user != null) {
                              DatabaseReference postsRef = FirebaseDatabase.instance.ref('posts');
                              
                              // Simpan waktu dalam format yang sudah rapi
                              String formattedTime = getCurrentFormattedTime();
                              
                              await postsRef.push().set({
                                'userId': user.uid,
                                'username': _username,
                                'text': postText,
                                'timestamp': formattedTime, // Simpan waktu yang sudah diformat
                              });

                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('Post berhasil dikirim!')),
                              );
      
                              // Tunggu sebentar agar SnackBar terlihat
                              await Future.delayed(Duration(milliseconds: 500));

                              // Update lastPostTime di user data (tetap disimpan di database)
                              DatabaseReference userRef = FirebaseDatabase.instance.ref('users').child(user.uid);
                              await userRef.update({
                                'lastPostTime': formattedTime
                              });

                              Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(builder: (context) => DashboardPage()),
                                (Route<dynamic> route) => false,
                              );

                              _formKey.currentState!.reset();
                              _textController.clear();
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                content: Text('Gagal mengirim, silakan login terlebih dahulu!'),
                              ));
                            }
                          }
                        },
                        style: OutlinedButton.styleFrom(
                          minimumSize: Size(100, 36),
                          side: BorderSide(
                            color: Colors.red,
                            width: 1,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                        child: Text(
                          'Kirim',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.red,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}