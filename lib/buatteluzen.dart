import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_time_picker_spinner/flutter_time_picker_spinner.dart';
import 'package:telu/buatjadwal.dart';
import 'package:telu/clipper.dart';

class BuatTeluzenScreen extends StatefulWidget {
  @override
  State<BuatTeluzenScreen> createState() => _BuatTeluzenScreenState();
}

class _BuatTeluzenScreenState extends State<BuatTeluzenScreen> {
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
                      "Kirim Suara Teluzen",
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
                      onPressed: () {},
                      icon: Icon(Icons.menu, size: 20),
                    ),
                    dense: true,
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 0,
                      vertical: 0,
                    ),
                  ),
                  TextFormField(
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
                        return 'Email tidak boleh kosong!';
                      }
                      return null;
                    },
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      IconButton(
                        onPressed: () {},
                        icon: Icon(Icons.add_link, color: Colors.red),
                      ),
                      OutlinedButton(
                        onPressed: () {},
                        style: OutlinedButton.styleFrom(
                          minimumSize: Size(100, 36), // Ukuran tombol
                          side: BorderSide(
                            color: Colors.red,
                            width: 1,
                          ), // Garis outline merah
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                              16,
                            ), // Sudut lebih halus
                          ),
                        ),
                        child: Text(
                          'Kirim',
                          style: TextStyle(
                            fontSize: 14,
                            color:
                                Colors
                                    .red, // Warna teks merah agar sesuai dengan outline
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
