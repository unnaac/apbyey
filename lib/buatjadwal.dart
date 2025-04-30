import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:flutter/material.dart';
import 'clipper.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import 'buatjadwaldb.dart';

class BookingScreen extends StatefulWidget {
  final String? selectedPsikolog;
  final List<String>? availableDays;

  const BookingScreen({
    super.key,
    this.selectedPsikolog,
    this.availableDays,
  });

  @override
  State<BookingScreen> createState() => _BookingScreenState();
}

class _BookingScreenState extends State<BookingScreen> {
  String selectedJenis = "baru";
  String selectedMedia = "luring";
  List<String> optionsKunjungan = ["baru", "lanjut"];
  List<String> optionsMedia = ["luring", "daring"];
  DateTime selectedDate = DateTime.now();
  String? selectedTimeRange;
  bool isCheckingAvailability = false;
  String? availabilityError;

  final List<String> timeRanges = [
    "10.00 - 11.00",
    "11.00 - 12.00",
    "13.00 - 14.00",
    "14.00 - 15.00",
  ];

  Map<String, dynamic>? userData;

  @override
  void initState() {
    super.initState();
    fetchUserData();
  }

  Future<void> fetchUserData() async {
    final userId = FirebaseAuth.instance.currentUser!.uid;
    final ref = FirebaseDatabase.instance.ref().child('users').child(userId);

    final snapshot = await ref.get();

    if (snapshot.exists) {
      setState(() {
        userData = Map<String, dynamic>.from(snapshot.value as Map);
      });
    } else {
      print("User data not found.");
    }
  }

  Future<bool> checkAvailability() async {
    if (selectedTimeRange == null || widget.selectedPsikolog == null) {
      setState(() {
        availabilityError = 'Mohon lengkapi semua data';
      });
      return false;
    }

    setState(() => isCheckingAvailability = true);

    try {
      final formattedDate = DateFormat('dd-MM-yyyy').format(selectedDate);
      final dbRef = FirebaseDatabase.instance.ref('jadwal_konseling');

      // Query lebih spesifik dengan psikolog + tanggal + waktu
      final snapshot = await dbRef
          .orderByChild('psikolog')
          .equalTo(widget.selectedPsikolog)
          .get();

      if (snapshot.exists) {
        final bookings = Map<String, dynamic>.from(snapshot.value as Map);

        // Cek apakah sudah ada booking dengan tanggal dan waktu yang sama
        final existingBooking = bookings.values.firstWhere(
          (booking) =>
              booking['tanggal'] == formattedDate &&
              booking['waktu'] == selectedTimeRange,
          orElse: () => null,
        );

        if (existingBooking != null) {
          setState(() {
            availabilityError = 'Slot sudah dipesan oleh user lain';
          });
          return false;
        }
      }

      return true;
    } catch (e) {
      setState(() {
        availabilityError = 'Error: ${e.toString()}';
      });
      return false;
    } finally {
      setState(() => isCheckingAvailability = false);
    }
  }

  String _translateDayToIndonesian(String englishDay) {
    switch (englishDay.toLowerCase()) {
      case 'monday':
        return 'Senin';
      case 'tuesday':
        return 'Selasa';
      case 'wednesday':
        return 'Rabu';
      case 'thursday':
        return 'Kamis';
      case 'friday':
        return 'Jumat';
      case 'saturday':
        return 'Sabtu';
      case 'sunday':
        return 'Minggu';
      default:
        return englishDay;
    }
  }

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
                padding: const EdgeInsets.only(top: 40, left: 16),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back, color: Colors.white),
                      onPressed: () => Navigator.pop(context),
                    ),
                    const SizedBox(width: 10),
                    const Text(
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
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // User Profile Card
                  Container(
                    margin: const EdgeInsets.only(bottom: 20),
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 1,
                          blurRadius: 0.1,
                          offset: const Offset(0, 1),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        const CircleAvatar(
                          backgroundColor: Colors.blue,
                          minRadius: 40,
                        ),
                        const SizedBox(width: 20),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(userData?['username'] ?? '-'),
                            Text(userData?['nik'] ?? '-'),
                            const Text('Kampus Bandung'),
                          ],
                        ),
                      ],
                    ),
                  ),

                  // Psychologist Info
                  if (widget.selectedPsikolog != null &&
                      widget.availableDays != null)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Psikolog:',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Text(widget.selectedPsikolog!),
                          const SizedBox(height: 8),
                          Text(
                            'Hari kerja: ${widget.availableDays!.join(', ')}',
                            style: TextStyle(color: Colors.grey[600]),
                          ),
                        ],
                      ),
                    ),

                  // Jenis Kunjungan
                  const Text('Jenis Kunjungan'),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: optionsKunjungan.map((option) {
                      return Expanded(
                        child: Container(
                          margin: const EdgeInsets.symmetric(horizontal: 5),
                          width: double.infinity,
                          child: MaterialButton(
                            color: selectedJenis == option
                                ? Colors.red
                                : Colors.white,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 12),
                            shape: RoundedRectangleBorder(
                              side: const BorderSide(
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

                  // Media
                  const SizedBox(height: 10),
                  const Text('Media'),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: optionsMedia.map((option) {
                      return Expanded(
                        child: Container(
                          width: double.infinity,
                          margin: const EdgeInsets.symmetric(horizontal: 5),
                          child: MaterialButton(
                            color: selectedMedia == option
                                ? Colors.red
                                : Colors.white,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 12),
                            shape: RoundedRectangleBorder(
                              side: const BorderSide(
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

                  // Date Picker
                  const SizedBox(height: 20),
                  const Text('Pilih Tanggal'),
                  const SizedBox(height: 8),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 1,
                          blurRadius: 0.1,
                          offset: const Offset(0, 1),
                        ),
                      ],
                    ),
                    child: CalendarDatePicker2(
                      config: CalendarDatePicker2Config(
                        calendarType: CalendarDatePicker2Type.single,
                        selectedDayHighlightColor: Colors.blue,
                        selectableDayPredicate: (date) {
                          if (widget.availableDays == null) return true;
                          final dayName =
                              DateFormat('EEEE', 'id_ID').format(date);
                          final indonesianDayName =
                              _translateDayToIndonesian(dayName);
                          return widget.availableDays!
                              .contains(indonesianDayName);
                        },
                      ),
                      value: [selectedDate],
                      onValueChanged: (dates) {
                        setState(() {
                          selectedDate = dates.first!;
                        });
                      },
                    ),
                  ),

                  // Time Selection
                  const SizedBox(height: 20),
                  const Text('Pilih Waktu'),
                  const SizedBox(height: 10),
                  Wrap(
                    spacing: 16.0,
                    runSpacing: 16.0,
                    children: timeRanges.map((range) {
                      final isSelected = selectedTimeRange == range;
                      return SizedBox(
                        width: (MediaQuery.of(context).size.width - 48) / 2,
                        child: FilterChip(
                          showCheckmark: false,
                          label: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 2.0),
                            child: Center(
                              child: Text(
                                range,
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: isSelected ? Colors.white : Colors.red,
                                ),
                              ),
                            ),
                          ),
                          selected: isSelected,
                          onSelected: (bool selected) {
                            setState(() {
                              selectedTimeRange = selected ? range : null;
                            });
                          },
                          backgroundColor: Colors.white,
                          selectedColor: Colors.red,
                          checkmarkColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                            side: const BorderSide(color: Colors.red),
                          ),
                        ),
                      );
                    }).toList(),
                  ),

                  // Availability Status
                  if (availabilityError != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 16),
                      child: Text(
                        availabilityError!,
                        style: TextStyle(color: Colors.red),
                      ),
                    ),

                  if (isCheckingAvailability)
                    const Padding(
                      padding: EdgeInsets.only(top: 16),
                      child: LinearProgressIndicator(),
                    ),

                  // Submit Button
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      onPressed: () async {
                        final isAvailable = await checkAvailability();
                        if (!isAvailable) return;

                        try {
                          final jadwalDB = JadwalDB();
                          await jadwalDB.simpanJadwal(
                            jenisKunjungan: selectedJenis,
                            media: selectedMedia,
                            tanggal: selectedDate,
                            waktu: selectedTimeRange!,
                            psikolog: widget.selectedPsikolog!,
                          );

                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Jadwal berhasil dibuat!'),
                              backgroundColor: Colors.green,
                            ),
                          );
                          Navigator.pop(context);
                          Navigator.pop(context);
                        } catch (error) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Gagal membuat jadwal: $error'),
                              backgroundColor: Colors.redAccent,
                            ),
                          );
                        }
                      },
                      child: const Text(
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
