import 'package:flutter/material.dart';

class EmosikuScreen extends StatefulWidget {
  const EmosikuScreen({Key? key}) : super(key: key);

  @override
  _EmosikuScreenState createState() => _EmosikuScreenState();
}

class _EmosikuScreenState extends State<EmosikuScreen> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  Set<String> selectedFactors = {};
  String? selectedMood;
  bool isScreenVisible = false; // Controls fade-in animation

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    )..forward();

    Future.delayed(const Duration(milliseconds: 100), () {
      setState(() {
        isScreenVisible = true;
      });
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
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
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 24),
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
              color: Colors.grey.withOpacity(0.3),
              spreadRadius: 2,
              blurRadius: 5,
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    'Rabu, 26 Februari 2025',
                    style: TextStyle(fontSize: 16),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Bagaimana kabarmu hari ini?',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            SizedBox(
              width: 100,
              height: 100,
              child: Image.asset(
                'assets/iconorang1.png',
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) {
                  return const Icon(Icons.error, color: Colors.red, size: 50);
                },
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
          const Text('Bagaimana perasaanmu hari ini?', style: TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildMoodOption('assets/Emoji_not_selected_very_dissatisfied.png', 'assets/Emoji_selected_very_dissatisfied.png', 'very_dissatisfied'),
              _buildMoodOption('assets/Emoji_not_selected_dissatisfied.png', 'assets/Emoji_selected_dissatisfied.png', 'dissatisfied'),
              _buildMoodOption('assets/Emoji_not_selected_neutral.png', 'assets/Emoji_selected_neutral.png', 'neutral'),
              _buildMoodOption('assets/Emoji_not_selected_satisfied.png', 'assets/Emoji_selected_satisfied.png', 'satisfied'),
              _buildMoodOption('assets/Emoji_not_selected_very_satisfied.png', 'assets/Emoji_selected_very_satisfied.png', 'very_satisfied'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMoodOption(String iconPath, String selectedIconPath, String mood) {
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedMood = mood;
        });
      },
      child: AnimatedOpacity(
        duration: const Duration(milliseconds: 200),
        opacity: selectedMood == mood ? 1.0 : 0.5,
        child: Image.asset(
          selectedMood == mood ? selectedIconPath : iconPath,
          width: 50,
          height: 50,
        ),
      ),
    );
  }

  // Factor Selection
  Widget _buildFactorSelection() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Apa yang memengaruhi emosimu?', style: TextStyle(fontWeight: FontWeight.bold)),
          AnimatedContainer(
            duration: const Duration(milliseconds: 500),
            curve: Curves.easeInOut,
            child: Wrap(
              spacing: 8.0,
              runSpacing: 4.0,
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
          ),
        ],
      ),
    );
  }

  Widget _buildFactorChip(String factor) {
    return ChoiceChip(
      label: Text(factor),
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
    );
  }

  // Text Input
  Widget _buildTextInput() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Tulis catatan di sini:', style: TextStyle(fontWeight: FontWeight.bold)),
          TextField(
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

  // Save Button
  Widget _buildSaveButton() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Center(
        child: OutlinedButton(
          onPressed: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Catatan harianmu berhasil tersimpan!'),
                duration: Duration(seconds: 2),
              ),
            );
          },
          child: const Text('Simpan', style: TextStyle(fontWeight: FontWeight.bold)),
          style: OutlinedButton.styleFrom(
            side: const BorderSide(color: Colors.red),
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
          ),
        ),
      ),
    );
  }
}
