<<<<<<< HEAD
import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_time_picker_spinner/flutter_time_picker_spinner.dart';
import 'clipper.dart';

class BookingScreen extends StatefulWidget {
  @override
  State<BookingScreen> createState() => _BookingScreenState();
}

class _BookingScreenState extends State<BookingScreen> {
  String selectedJenis = "baru";
  // Default value
  String selectedMedia = "luring";
  // Default value
  List<String> optionsKunjungan = ["baru", "lanjut"];

  List<String> optionsMedia = ["luring", "daring"];

  DateTime selectedDate = DateTime.now();

  DateTime selectedTime = DateTime.now();

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
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                    SizedBox(width: 10),
                    Text(
                      "Buat Jadwal Konseling",
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
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    margin: EdgeInsets.only(bottom: 20),
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
                    child: Row(
                      children: [
                        CircleAvatar(
                          backgroundColor: Colors.blue,
                          minRadius: 40,
                        ),
                        SizedBox(width: 20),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Joshua Suherman'),
                            Text('11101010101101'),
                            Text('S1 Informatika'),
                            Text('Kampus Bandung'),
                            Text('Mahasiswa'),
                            Text('Laki-laki'),
                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 20),
                  Text('Jenis Kunjungan'),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: optionsKunjungan.map((option) {
                      return Expanded(
                        child: Container(
                          margin: EdgeInsets.symmetric(horizontal: 5),
                          width: double.infinity,
                          child: MaterialButton(
                            color: selectedJenis == option
                                ? Colors.red
                                : Colors.white,
                            padding: EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 12,
                            ),
                            shape: RoundedRectangleBorder(
                              side: BorderSide(
                                width: 1.2,
                                color: Colors.red,
                              ),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            onPressed: () {
                              setState(() {
                                selectedJenis = option;
                              });
                            },
                            child: Text(
                              option.toUpperCase(),
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: selectedJenis == option
                                    ? Colors.white
                                    : Colors.red,
                              ),
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                  SizedBox(height: 10),
                  Text('Media'),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: optionsMedia.map((option) {
                      return Expanded(
                        child: Container(
                          width: double.infinity,
                          margin: EdgeInsets.symmetric(horizontal: 5),
                          child: MaterialButton(
                            color: selectedMedia == option
                                ? Colors.red
                                : Colors.white,
                            padding: EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 12,
                            ),
                            shape: RoundedRectangleBorder(
                              side: BorderSide(
                                width: 1.2,
                                color: Colors.red,
                              ),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            onPressed: () {
                              setState(() {
                                selectedMedia = option;
                              });
                            },
                            child: Text(
                              option.toUpperCase(),
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: selectedMedia == option
                                    ? Colors.white
                                    : Colors.red,
                              ),
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                  SizedBox(height: 20),
                  SizedBox(height: 10),
                  Text('Pilih Tanggal dan Waktu'),
                  SizedBox(height: 8),
                  Container(
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
                    child: CalendarDatePicker2(
                      config: CalendarDatePicker2Config(
                        calendarType: CalendarDatePicker2Type.single,
                        selectedDayHighlightColor: Colors.blue,
                      ),
                      value: [selectedDate],
                      onValueChanged: (dates) {
                        setState(() {
                          selectedDate = dates.first;
                        });
                      },
                    ),
                  ),
                  SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment
                        .spaceBetween, // Memberi jarak antar item
                    children: [
                      Expanded(
                        child: Container(
                          padding: EdgeInsets.all(4), // Padding lebih kecil
                          margin: EdgeInsets.only(
                            right: 4,
                          ), // Jarak antar elemen
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey),
                            borderRadius: BorderRadius.circular(
                              6,
                            ), // Radius lebih kecil
                          ),
                          child: TimePickerSpinner(
                            is24HourMode: true,
                            normalTextStyle: TextStyle(
                              fontSize: 18, // Ukuran font lebih kecil
                              color: Colors.grey,
                            ),
                            highlightedTextStyle: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                            spacing: 18, // Spasi lebih kecil
                            itemHeight: 18, // Tinggi item lebih kecil
                            isForce2Digits: true,
                            onTimeChange: (time) {
                              setState(() {
                                selectedTime = time;
                              });
                            },
                          ),
                        ),
                      ),
                      Expanded(
                        child: Container(
                          padding: EdgeInsets.all(4),
                          margin: EdgeInsets.only(
                            left: 4,
                          ), // Jarak antar elemen
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: TimePickerSpinner(
                            is24HourMode: true,
                            normalTextStyle: TextStyle(
                              fontSize: 18, // Ukuran font lebih kecil
                              color: Colors.grey,
                            ),
                            highlightedTextStyle: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                            spacing: 18, // Spasi lebih kecil
                            itemHeight: 18, // Tinggi item lebih kecil
                            isForce2Digits: true,
                            onTimeChange: (time) {
                              setState(() {
                                selectedTime = time;
                              });
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  DropdownButtonFormField(
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderSide: BorderSide(width: 1.0, color: Colors.red),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(width: 1.0, color: Colors.red),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(width: 1.0, color: Colors.red),
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    items: [
                      DropdownMenuItem(
                        child: Text("Shinta Putrinanda, M.Psi., Psikolog"),
                      ),
                    ],
                    onChanged: (value) {},
                  ),
                  SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      onPressed: () {},
                      child: Text(
                        "Buat Jadwal",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
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

class CustomButton extends StatelessWidget {
  final String label;
  CustomButton({required this.label});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.red),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Center(child: Text(label, style: TextStyle(color: Colors.red))),
      ),
    );
  }
}
=======
import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_time_picker_spinner/flutter_time_picker_spinner.dart';
import 'clipper.dart';

class BookingScreen extends StatefulWidget {
  @override
  State<BookingScreen> createState() => _BookingScreenState();
}

class _BookingScreenState extends State<BookingScreen> {
  String selectedJenis = "baru";
  // Default value
  String selectedMedia = "luring";
  // Default value
  List<String> optionsKunjungan = ["baru", "lanjut"];

  List<String> optionsMedia = ["luring", "daring"];

  DateTime selectedDate = DateTime.now();

  DateTime selectedTime = DateTime.now();

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
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                    SizedBox(width: 10),
                    Text(
                      "Buat Jadwal Konseling",
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
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    margin: EdgeInsets.only(bottom: 20),
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
                    child: Row(
                      children: [
                        CircleAvatar(
                          backgroundColor: Colors.blue,
                          minRadius: 40,
                        ),
                        SizedBox(width: 20),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Joshua Suherman'),
                            Text('11101010101101'),
                            Text('S1 Informatika'),
                            Text('Kampus Bandung'),
                            Text('Mahasiswa'),
                            Text('Laki-laki'),
                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 20),
                  Text('Jenis Kunjungan'),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: optionsKunjungan.map((option) {
                      return Expanded(
                        child: Container(
                          margin: EdgeInsets.symmetric(horizontal: 5),
                          width: double.infinity,
                          child: MaterialButton(
                            color: selectedJenis == option
                                ? Colors.red
                                : Colors.white,
                            padding: EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 12,
                            ),
                            shape: RoundedRectangleBorder(
                              side: BorderSide(
                                width: 1.2,
                                color: Colors.red,
                              ),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            onPressed: () {
                              setState(() {
                                selectedJenis = option;
                              });
                            },
                            child: Text(
                              option.toUpperCase(),
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: selectedJenis == option
                                    ? Colors.white
                                    : Colors.red,
                              ),
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                  SizedBox(height: 10),
                  Text('Media'),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: optionsMedia.map((option) {
                      return Expanded(
                        child: Container(
                          width: double.infinity,
                          margin: EdgeInsets.symmetric(horizontal: 5),
                          child: MaterialButton(
                            color: selectedMedia == option
                                ? Colors.red
                                : Colors.white,
                            padding: EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 12,
                            ),
                            shape: RoundedRectangleBorder(
                              side: BorderSide(
                                width: 1.2,
                                color: Colors.red,
                              ),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            onPressed: () {
                              setState(() {
                                selectedMedia = option;
                              });
                            },
                            child: Text(
                              option.toUpperCase(),
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: selectedMedia == option
                                    ? Colors.white
                                    : Colors.red,
                              ),
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                  SizedBox(height: 20),
                  SizedBox(height: 10),
                  Text('Pilih Tanggal dan Waktu'),
                  SizedBox(height: 8),
                  Container(
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
                    child: CalendarDatePicker2(
                      config: CalendarDatePicker2Config(
                        calendarType: CalendarDatePicker2Type.single,
                        selectedDayHighlightColor: Colors.blue,
                      ),
                      value: [selectedDate],
                      onValueChanged: (dates) {
                        setState(() {
                          selectedDate = dates.first;
                        });
                      },
                    ),
                  ),
                  SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment
                        .spaceBetween, // Memberi jarak antar item
                    children: [
                      Expanded(
                        child: Container(
                          padding: EdgeInsets.all(4), // Padding lebih kecil
                          margin: EdgeInsets.only(
                            right: 4,
                          ), // Jarak antar elemen
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey),
                            borderRadius: BorderRadius.circular(
                              6,
                            ), // Radius lebih kecil
                          ),
                          child: TimePickerSpinner(
                            is24HourMode: true,
                            normalTextStyle: TextStyle(
                              fontSize: 18, // Ukuran font lebih kecil
                              color: Colors.grey,
                            ),
                            highlightedTextStyle: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                            spacing: 18, // Spasi lebih kecil
                            itemHeight: 18, // Tinggi item lebih kecil
                            isForce2Digits: true,
                            onTimeChange: (time) {
                              setState(() {
                                selectedTime = time;
                              });
                            },
                          ),
                        ),
                      ),
                      Expanded(
                        child: Container(
                          padding: EdgeInsets.all(4),
                          margin: EdgeInsets.only(
                            left: 4,
                          ), // Jarak antar elemen
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: TimePickerSpinner(
                            is24HourMode: true,
                            normalTextStyle: TextStyle(
                              fontSize: 18, // Ukuran font lebih kecil
                              color: Colors.grey,
                            ),
                            highlightedTextStyle: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                            spacing: 18, // Spasi lebih kecil
                            itemHeight: 18, // Tinggi item lebih kecil
                            isForce2Digits: true,
                            onTimeChange: (time) {
                              setState(() {
                                selectedTime = time;
                              });
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  DropdownButtonFormField(
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderSide: BorderSide(width: 1.0, color: Colors.red),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(width: 1.0, color: Colors.red),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(width: 1.0, color: Colors.red),
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    items: [
                      DropdownMenuItem(
                        child: Text("Shinta Putrinanda, M.Psi., Psikolog"),
                      ),
                    ],
                    onChanged: (value) {},
                  ),
                  SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      onPressed: () {},
                      child: Text(
                        "Buat Jadwal",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
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

class CustomButton extends StatelessWidget {
  final String label;
  CustomButton({required this.label});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.red),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Center(child: Text(label, style: TextStyle(color: Colors.red))),
      ),
    );
  }
}
>>>>>>> 88e04336830f6da6ca594b9a246b3b73d1e8dd6e
