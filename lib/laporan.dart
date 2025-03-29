import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';

class LaporanPage extends StatefulWidget {
  @override
  _LaporanPageState createState() => _LaporanPageState();
}

class _LaporanPageState extends State<LaporanPage> {
  String? selectedAnonim;
  String? selectedStatus;
  DateTime? selectedDate;
  TextEditingController deskripsiController = TextEditingController();
  TextEditingController lokasiController = TextEditingController();
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
              _buildDatePicker(),
              SizedBox(height: 20),
              _buildTextField("Deskripsi", deskripsiController, maxLines: 3, borderColor: Colors.red),
              _buildTextField("Lokasi", lokasiController, borderColor: Colors.red),
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

  Widget _buildDatePicker() {
    return Row(
      children: [
        Expanded(
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(5),
            ),
            child: Text(
              selectedDate != null ? "${selectedDate!.day} / ${selectedDate!.month} / ${selectedDate!.year}" : "Pilih Tanggal",
              style: TextStyle(fontSize: 16),
            ),
          ),
        ),
        SizedBox(width: 10),
        ElevatedButton(
  onPressed: () async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (pickedDate != null) {
      setState(() => selectedDate = pickedDate);
    }
  },
  child: Row(
    mainAxisSize: MainAxisSize.min,
    children: [
      Icon(Icons.calendar_today, color: Colors.white), 
      SizedBox(width: 5),
      Text("Pilih Tanggal"),
    ],
  ),
  style: ElevatedButton.styleFrom(backgroundColor: Color(0xFFED1E28)),
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
        Text("Bukti", style: TextStyle(fontWeight: FontWeight.bold)),
        SizedBox(height: 5),
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
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.upload, color: Colors.red, size: 30),
                  SizedBox(height: 5),
                  Text(
                    uploadedFile ?? "Kirim Bukti Kekerasan (Optional)",
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.black),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
