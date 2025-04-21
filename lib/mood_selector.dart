import 'package:flutter/material.dart';

class MoodSelector extends StatefulWidget {
  const MoodSelector({Key? key}) : super(key: key);

  @override
  _MoodSelectorState createState() => _MoodSelectorState();
}

class _MoodSelectorState extends State<MoodSelector> {
  String? selectedMood;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildMoodOption('assets/Emoji_not_selected_very_dissatisfied.png',
            'very_dissatisfied'),
        _buildMoodOption(
            'assets/Emoji_not_selected_dissatisfied.png', 'dissatisfied'),
        _buildMoodOption('assets/Emoji_not_selected_neautral.png', 'neutral'),
        _buildMoodOption(
            'assets/Emoji_not_selected_satisfied.png', 'satisfied'),
        _buildMoodOption(
            'assets/Emoji_not_selected_very_satisfied.png', 'very_satisfied'),
      ],
    );
  }

  // Builds a mood option widget with selection logic
  Widget _buildMoodOption(String assetPath, String mood) {
    final isSelected = selectedMood == mood;
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedMood = mood;
        });
      },
      child: Container(
        margin: const EdgeInsets.all(8.0),
        decoration: BoxDecoration(
          border: isSelected ? Border.all(color: Colors.blue, width: 2) : null,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Image.asset(
          assetPath,
          width: 50,
          height: 50,
          color: isSelected ? Colors.blue : null, // Highlight selected mood
        ),
      ),
    );
  }
}
