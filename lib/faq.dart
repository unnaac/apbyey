import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_time_picker_spinner/flutter_time_picker_spinner.dart';
import 'buatjadwal.dart';
import 'clipper.dart';

class FaqScreen extends StatefulWidget {
  @override
  State<FaqScreen> createState() => _FaqScreenState();
}

class _FaqScreenState extends State<FaqScreen> {
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
                      "FAQ",
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
              padding: EdgeInsets.symmetric(vertical: 5),
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
              child: Theme(
                data: Theme.of(
                  context,
                ).copyWith(dividerColor: Colors.transparent),
                child: ExpansionTile(
                  dense: true,
                  title: Text(
                    'Apakah saya dapat melaporkan kekerasan seksual diluar kampus?',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  children: [
                    Container(
                      alignment: Alignment.centerLeft, // Rata kiri
                      padding: EdgeInsets.all(8.0),
                      margin: EdgeInsets.symmetric(horizontal: 10),
                      child: Text('Ya, Kamu bisa melaporkannya.'),
                    ),
                  ],
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              width: double.infinity,
              padding: EdgeInsets.symmetric(vertical: 5),
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
              child: Theme(
                data: Theme.of(
                  context,
                ).copyWith(dividerColor: Colors.transparent),
                child: ExpansionTile(
                  dense: true,
                  title: Text(
                    'Bagaimana membuat jadwal konseling dengan BK?',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  children: [
                    Container(
                      alignment: Alignment.centerLeft, // Rata kiri
                      padding: EdgeInsets.all(8.0),
                      margin: EdgeInsets.symmetric(horizontal: 10),
                      child: Text(
                        'Kamu bisa membuat jadwal konseling dengan mengisi semua data yang diperlukan.',
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        backgroundColor: Colors.red,
        child: Icon(Icons.support_agent, color: Colors.white),
      ),
    );
  }
}
