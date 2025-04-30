import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:intl/intl.dart'; // Import intl package
import 'emosikudb.dart';

class EmosikuScreen extends StatefulWidget {
  const EmosikuScreen({Key? key}) : super(key: key);

  @override
  _EmosikuScreenState createState() => _EmosikuScreenState();
}

class _EmosikuScreenState extends State<EmosikuScreen>
    with SingleTickerProviderStateMixin {
  Set<String> selectedFactors = {};
  String? selectedMood;
  String? username;
  bool isScreenVisible = false;
  final TextEditingController _catatanController = TextEditingController();
  late AnimationController _animationController;
  late Animation<double> _shakeAnimation;

  // State untuk menyimpan data emosi hari ini
  Map<String, dynamic>? _emosiHariIni;
  bool _isLoading = true; // Tambahkan state loading

  @override // Ini yang benar
  void initState() {
    super.initState();
    isScreenVisible = true;
    _fetchInitialData(); // Gabungkan fetch username dan data emosi
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _shakeAnimation = Tween<double>(begin: 0, end: 10)
        .chain(CurveTween(curve: Curves.elasticIn))
        .animate(_animationController);
  }

  Future<void> _fetchInitialData() async {
    await _fetchUsername();
    await _loadEmosiHariIni();
    setState(() {
      _isLoading = false; // Selesai memuat
      if (_emosiHariIni != null) {
        selectedMood = _emosiHariIni!['mood'];
        _catatanController.text = _emosiHariIni!['catatan'] ?? '';
        selectedFactors =
            (_emosiHariIni!['faktor'] as String?)?.split(', ').toSet() ?? {};
      }
    });
  }

  Future<void> _fetchUsername() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final snapshot =
          await FirebaseDatabase.instance.ref('users/${user.uid}').get();
      if (snapshot.exists) {
        setState(() {
          username = snapshot.child('username').value?.toString();
        });
      }
    }
  }

  Future<void> _loadEmosiHariIni() async {
    final db = EmosiDB();
    final hariIni = DateTime.now();
    final formattedHariIni = DateFormat('dd-MM-yyyy').format(hariIni);

    try {
      final semuaDataEmosi = await db.getEmosiData();
      _emosiHariIni = semuaDataEmosi.firstWhere(
        (data) => (data['timestamp'] as String).startsWith(formattedHariIni),
        orElse: () =>
            <String, dynamic>{}, // Kembalikan Map kosong jika tidak ada data
      );
      print('Data emosi hari ini: $_emosiHariIni');
    } catch (e) {
      print('Gagal memuat data emosi hari ini: $e');
      _emosiHariIni = null; // Tetap null saat terjadi error
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    _catatanController.dispose();
    super.dispose();
  }

  String formatTanggal(DateTime date) {
    final List<String> hari = [
      'Senin',
      'Selasa',
      'Rabu',
      'Kamis',
      'Jumat',
      'Sabtu',
      'Minggu'
    ];
    final List<String> bulan = [
      'Januari',
      'Februari',
      'Maret',
      'April',
      'Mei',
      'Juni',
      'Juli',
      'Agustus',
      'September',
      'Oktober',
      'November',
      'Desember'
    ];
    String namaHari = hari[date.weekday - 1];
    String namaBulan = bulan[date.month - 1];
    return '$namaHari, ${date.day} $namaBulan ${date.year}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        top: false,
        child: AnimatedOpacity(
          duration: const Duration(milliseconds: 500),
          opacity: isScreenVisible ? 1.0 : 0.0,
          child: _isLoading
              ? const Center(
                  child:
                      CircularProgressIndicator()) // Tampilkan loading indicator
              : SingleChildScrollView(
                  child: Column(
                    children: [
                      _buildHeader(),
                      _buildDateAndImageContainer(),
                      _buildMoodSelection(),
                      _buildFactorSelection(),
                      _buildTextInput(),
                      _buildSaveButton(),
                    ],
                  ),
                ),
        ),
      ),
    );
  }

  // Header Section
  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: const BoxDecoration(
        color: Colors.red,
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(30)),
      ),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => Navigator.pop(context),
          ),
          const Expanded(
            child: Text(
              'Emosiku',
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 24),
            ),
          ),
        ],
      ),
    );
  }

  // Date & Image Container
  Widget _buildDateAndImageContainer() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        width: double.infinity,
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withAlpha(77),
              spreadRadius: 2,
              blurRadius: 5,
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    formatTanggal(DateTime.now()),
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Bagaimana kabarmu hari ini?',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  if (username != null) ...[
                    const SizedBox(height: 4),
                    Text(
                      'Halo, $username!',
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            Container(
              margin: const EdgeInsets.only(left: 16),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.asset(
                  'assets/iconorang1.png',
                  width: 100,
                  height: 100,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Mood Selection
  Widget _buildMoodSelection() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Bagaimana perasaanmu hari ini?',
              style: TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildMoodOption(
                  'assets/Emoji_not_selected_very_dissatisfied.png',
                  'assets/Emoji_selected_very_dissatisfied.png',
                  'very_dissatisfied'),
              _buildMoodOption('assets/Emoji_not_selected_dissatisfied.png',
                  'assets/Emoji_selected_dissatisfied.png', 'dissatisfied'),
              _buildMoodOption('assets/Emoji_not_selected_neutral.png',
                  'assets/Emoji_selected_neutral.png', 'neutral'),
              _buildMoodOption('assets/Emoji_not_selected_satisfied.png',
                  'assets/Emoji_selected_satisfied.png', 'satisfied'),
              _buildMoodOption('assets/Emoji_not_selected_very_satisfied.png',
                  'assets/Emoji_selected_very_satisfied.png', 'very_satisfied'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMoodOption(
      String iconPath, String selectedIconPath, String mood) {
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedMood = mood;
        });
      },
      child: AnimatedScale(
        scale: selectedMood == mood ? 1.2 : 1.0,
        duration: const Duration(milliseconds: 200),
        child: AnimatedOpacity(
          duration: const Duration(milliseconds: 200),
          opacity: selectedMood == mood ? 1.0 : 0.5,
          child: Image.asset(
            selectedMood == mood ? selectedIconPath : iconPath,
            width: 50,
            height: 50,
          ),
        ),
      ),
    );
  }

  // Factor Selection
  Widget _buildFactorSelection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Apa yang memengaruhi emosimu?',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 6.0,
            runSpacing: 6.0,
            children: [
              _buildFactorChip('Keluarga'),
              _buildFactorChip('Kuliah'),
              _buildFactorChip('Teman'),
              _buildFactorChip('Ekonomi'),
              _buildFactorChip('Hubungan'),
              _buildFactorChip('Kesehatan'),
              _buildFactorChip('Pekerjaan'),
              _buildFactorChip('Masa depan'),
              _buildFactorChip('Makanan'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFactorChip(String factor) {
    return ChoiceChip(
      label: Text(
        factor,
        style: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
      ),
      selected: selectedFactors.contains(factor),
      onSelected: (selected) {
        setState(() {
          if (selected) {
            selectedFactors.add(factor);
          } else {
            selectedFactors.remove(factor);
          }
        });
      },
      selectedColor: Colors.red,
      backgroundColor: Colors.white,
      labelStyle: TextStyle(
        color: selectedFactors.contains(factor) ? Colors.white : Colors.black,
      ),
      side: const BorderSide(color: Color(0xFFED1E28), width: 1),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
    );
  }

  // Text Input
  Widget _buildTextInput() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Tulis catatan di sini:',
              style: TextStyle(fontWeight: FontWeight.bold)),
          TextField(
            controller: _catatanController,
            maxLines: 4,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              hintText: 'Tulis di sini...',
            ),
          ),
        ],
      ),
    );
  }

  void _saveMoodAndNote() async {
    if (selectedMood == null || _catatanController.text.isEmpty) {
      _animationController.forward(from: 0);
      return;
    }

    try {
      final db = EmosiDB();
      await db.saveEmosi(
        mood: selectedMood!,
        catatan: _catatanController.text.trim(),
        faktor: selectedFactors.join(', '),
        tanggal: DateTime.now(),
      );
      Navigator.of(context).pop();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal menyimpan: $e')),
      );
    }
  }

  // Save Button
  Widget _buildSaveButton() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
      child: Center(
        child: AnimatedBuilder(
          animation: _shakeAnimation,
          builder: (context, child) {
            return Transform.translate(
              offset: Offset(_shakeAnimation.value, 0),
              child: child,
            );
          },
          child: OutlinedButton(
            onPressed: _saveMoodAndNote,
            child: const Text(
              'Simpan',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
            style: OutlinedButton.styleFrom(
              side: const BorderSide(color: Colors.red),
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
