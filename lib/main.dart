import 'package:flutter/material.dart';
import 'styles/theme.dart';
import 'catatan_harian_screen.dart';
import 'chatbot_screen.dart';
import 'emosiku_screen.dart';
import 'notifikasi_screen.dart';
import 'akun_screen.dart'; // Import the AkunScreen

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Telusafe',
      theme: AppTheme.lightTheme,
      initialRoute: '/',
      routes: {
        '/': (context) => const HomeScreen(),
        '/catatanHarian': (context) => const CatatanHarianScreen(),
        '/chatbot': (context) => const ChatbotScreen(),
        '/emosiku': (context) => const EmosikuScreen(),
        '/notifikasi': (context) => const NotifikasiScreen(),
        '/akun': (context) => const AkunScreen(),
      },
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Telusafe Home'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/catatanHarian');
              },
              child: const Text('Catatan Harian'),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/chatbot');
              },
              child: const Text('Chatbot'),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/emosiku');
              },
              child: const Text('Emosiku'),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/notifikasi');
              },
              child: const Text('Notifikasi'),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/akun'); // Navigate to AkunScreen
              },
              child: const Text('Go to Akun'),
            ),
          ],
        ),
      ),
    );
  }
}
