import 'package:flutter/material.dart';

class EmosikuScreen extends StatefulWidget {
  const EmosikuScreen({Key? key}) : super(key: key);

  @override
  _EmosikuScreenState createState() => _EmosikuScreenState();
}

class _EmosikuScreenState extends State<EmosikuScreen>
    with SingleTickerProviderStateMixin {
  Set<String> selectedFactors = {};
  String? selectedMood;
  bool isScreenVisible = false;
  final TextEditingController _catatanController = TextEditingController();
  late AnimationController _animationController;
  late Animation<double> _shakeAnimation;

  @override
  void initState() {
    super.initState();
    isScreenVisible = true;

    // Initialize animation controller for shake effect
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _shakeAnimation = Tween<double>(begin: 0, end: 10)
        .chain(CurveTween(curve: Curves.elasticIn))
        .animate(_animationController);
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
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: AnimatedOpacity(
          duration: const Duration(milliseconds: 500),
          opacity: isScreenVisible ? 1.0 : 0.0,
          child: SingleChildScrollView(
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
              color: Colors.grey.withAlpha(77), // Updated from withOpacity(0.3)
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
              fontSize: 14, // Match font size to the second image
            ),
          ),
          const SizedBox(height: 8), // Minimal spacing between text and chips
          Wrap(
            spacing: 6.0, // Small horizontal gap between chips
            runSpacing: 6.0, // Small vertical gap between rows of chips
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
          fontSize: 12, // Match font size to the second image
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
            controller: _catatanController, // Kontrol input untuk catatan
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

  void _saveMoodAndNote() {
    if (selectedMood == null || _catatanController.text.isEmpty) {
      _animationController.forward(from: 0); // Trigger shake animation
      return;
    }

    final result = {
      'mood': selectedMood,
      'catatan': _catatanController.text,
      'factors': selectedFactors.toList(),
      'date': DateTime.now()
          .toIso8601String(), // Use ISO8601 format for consistency
    };

    Navigator.of(context).pop(result); // Pass the result back
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
