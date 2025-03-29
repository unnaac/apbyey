import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:file_picker/file_picker.dart';
import 'package:table_calendar/table_calendar.dart';

class LaporanPage extends StatefulWidget {
  @override
  _LaporanPageState createState() => _LaporanPageState();
}

class _LaporanPageState extends State<LaporanPage> {
  String? selectedAnonim;
  String? selectedStatus;
  DateTime selectedDate = DateTime.now();
  TextEditingController deskripsiController = TextEditingController();
  TextEditingController lokasiController = TextEditingController();
  GoogleMapController? mapController;
  String? uploadedFile;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFFED1E28),
        title: Text("Buat Laporan", style: TextStyle(color: Colors.white)),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildToggleButtons("Buat Sebagai Anonim", ["Iya", "Tidak"], (val) {
                setState(() => selectedAnonim = val);
              }, selectedAnonim),
              SizedBox(height: 10),
              _buildToggleButtons("Laporkan Sebagai", ["Korban", "Saksi"], (val) {
                setState(() => selectedStatus = val);
              }, selectedStatus),
              SizedBox(height: 20),
              Text("Pilih Tanggal dan Waktu", style: TextStyle(fontWeight: FontWeight.bold)),
              SizedBox(height: 10),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [BoxShadow(color: Colors.grey, blurRadius: 5)],
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  children: [
                    TableCalendar(
                      firstDay: DateTime.utc(2000, 1, 1),
                      lastDay: DateTime.utc(2100, 12, 31),
                      focusedDay: selectedDate,
                      selectedDayPredicate: (day) => isSameDay(selectedDate, day),
                      onDaySelected: (selectedDay, focusedDay) {
                        setState(() => selectedDate = selectedDay);
                      },
                      calendarStyle: CalendarStyle(
                        todayDecoration: BoxDecoration(
                          color: Colors.red,
                          shape: BoxShape.circle,
                        ),
                        selectedDecoration: BoxDecoration(
                          color: Colors.red,
                          shape: BoxShape.circle,
                        ),
                      ),
                      headerStyle: HeaderStyle(
                        formatButtonVisible: false,
                        titleCentered: true,
                        leftChevronIcon: Icon(Icons.chevron_left, color: Colors.red),
                        rightChevronIcon: Icon(Icons.chevron_right, color: Colors.red),
                      ),
                    ),
                    TextButton(
                      onPressed: () {},
                      child: Text("Pilih Tanggal", style: TextStyle(color: Colors.white)),
                      style: TextButton.styleFrom(backgroundColor: Colors.red),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20),
              _buildTextField("Deskripsi", deskripsiController, maxLines: 3, borderColor: Colors.red),
              _buildTextField("Lokasi", lokasiController, borderColor: Colors.red),
              SizedBox(height: 10),
              Container(
                height: 200,
                decoration: BoxDecoration(border: Border.all(color: Colors.red)),
                child: GoogleMap(
                  initialCameraPosition: CameraPosition(target: LatLng(-6.914744, 107.609810), zoom: 15),
                  onMapCreated: (GoogleMapController controller) {
                    mapController = controller;
                  },
                ),
              ),
              SizedBox(height: 20),
              _buildFileUpload(),
              SizedBox(height: 20),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFFED1E28),
                  minimumSize: Size(double.infinity, 50),
                ),
                onPressed: () {},
                child: Text("Kirim", style: TextStyle(color: Colors.white)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildToggleButtons(String title, List<String> options, Function(String) onSelected, String? selectedValue) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: TextStyle(fontWeight: FontWeight.bold)),
        SizedBox(height: 5),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: options.map((option) {
            bool isSelected = option == selectedValue;
            return Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 5),
                child: OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    backgroundColor: isSelected ? Color(0xFFED1E28) : Colors.white,
                    foregroundColor: isSelected ? Colors.white : Color(0xFFED1E28),
                    side: BorderSide(color: Color(0xFFED1E28)),
                  ),
                  onPressed: () => onSelected(option),
                  child: Text(option),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildTextField(String label, TextEditingController controller, {int maxLines = 1, Color borderColor = Colors.grey}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyle(fontWeight: FontWeight.bold)),
        SizedBox(height: 5),
        TextField(
          controller: controller,
          maxLines: maxLines,
          decoration: InputDecoration(
            border: OutlineInputBorder(borderSide: BorderSide(color: borderColor)),
            enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: borderColor)),
            focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: borderColor)),
          ),
        ),
      ],
    );
  }

  Widget _buildFileUpload() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ElevatedButton(
          onPressed: () async {
            FilePickerResult? result = await FilePicker.platform.pickFiles();
            if (result != null) {
              setState(() => uploadedFile = result.files.single.name);
            }
          },
          child: Text("Upload Bukti"),
          style: ElevatedButton.styleFrom(
            backgroundColor: Color(0xFFED1E28),
            foregroundColor: Colors.white,
          ),
        ),
        SizedBox(height: 10),
        GestureDetector(
          onTap: () async {
            FilePickerResult? result = await FilePicker.platform.pickFiles();
            if (result != null) {
              setState(() => uploadedFile = result.files.single.name);
            }
          },
          child: Container(
            height: 100,
            decoration: BoxDecoration(
              border: Border.all(color: Color(0xFFED1E28)),
              borderRadius: BorderRadius.circular(10),
              color: Colors.red.shade100,
            ),
            child: Center(
              child: Text(
                uploadedFile ?? "Kirim Bukti Kekerasan (Optional)",
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.black),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
