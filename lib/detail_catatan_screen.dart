import 'package:flutter/material.dart';

class DetailCatatanScreen extends StatelessWidget {
  final Map<String, dynamic> record;

  const DetailCatatanScreen({Key? key, required this.record}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail Catatan'),
        backgroundColor: Colors.red,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Mood Kamu:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                if (record['mood'] != null)
                  Image.asset(
                    'assets/Emoji_selected_${record['mood']}.png',
                    width: 50,
                    height: 50,
                  ),
                const SizedBox(width: 10),
                Text(
                  record['mood']?.replaceAll('_', ' ') ?? '',
                  style: const TextStyle(fontSize: 16),
                ),
              ],
            ),
            const SizedBox(height: 20),
            const Text(
              'Catatan:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16.0),
              ),
              elevation: 5,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  record['catatan'] ?? '',
                  style: const TextStyle(fontSize: 16),
                ),
              ),
            ),
            const SizedBox(height: 20),
            if (record['factors'] != null &&
                (record['factors'] as List).isNotEmpty) ...[
              const Text(
                'Faktor yang Mempengaruhi:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              Wrap(
                spacing: 8.0,
                runSpacing: 4.0,
                children: (record['factors'] as List)
                    .map((e) => e.toString())
                    .map((factor) => Chip(
                          label: Text(factor),
                          backgroundColor: Colors.red[100],
                        ))
                    .toList(),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
