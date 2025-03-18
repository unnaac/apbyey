import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'login.dart';

class SignUpPage extends StatelessWidget {
  const SignUpPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 30),
              const Text(
                'Daftar',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF777785),
                ),
              ),
              const SizedBox(height: 20),
              _buildTextField(label: 'NIK (Nomor Induk Kependudukan)'),
              _buildPhoneField(),
              _buildTextField(label: 'Email'),
              _buildTextField(label: 'Username'),
              _buildTextField(label: 'Kata Sandi', obscureText: true),
              _buildTextField(label: 'Konfirmasi Kata Sandi', obscureText: true),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFB6252A),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onPressed: () {},
                  child: const Text('Daftar', style: TextStyle(fontSize: 18, color: Colors.white)),
                ),
              ),
              const SizedBox(height: 10),
              Center(
                child: RichText(
                  text: TextSpan(
                    text: 'Sudah memiliki akun? ',
                    style: const TextStyle(
                      color: Color(0xFF777785),
                      fontSize: 14,
                    ),
                    children: [
                      TextSpan(
                        text: 'Masuk',
                        style: const TextStyle(
                          color: Color(0xFFB6252A),
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => const LoginPage()),
                            );
                          },
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Fungsi untuk membuat TextField
Widget _buildTextField({required String label, bool obscureText = false}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        label,
        style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF777785)),
      ),
      const SizedBox(height: 5),
      TextField(
        obscureText: obscureText,
        decoration: InputDecoration(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: Color(0xFFB6252A)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: Color(0xFFB6252A), width: 2),
          ),
          contentPadding: const EdgeInsets.symmetric(horizontal: 15),
        ),
      ),
      const SizedBox(height: 10),
    ],
  );
}

Widget _buildPhoneField() {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      const Text(
        'Nomor Telepon',
        style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF777785)),
      ),
      const SizedBox(height: 5),
      TextField(
        keyboardType: TextInputType.phone,
        decoration: InputDecoration(
          prefixIcon: Padding(
            padding: const EdgeInsets.only(left: 10, right: 5),
            child: Text('+62', style: TextStyle(color: Colors.black87)),
          ),
          prefixIconConstraints: const BoxConstraints(minWidth: 50),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: Color(0xFFB6252A)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: Color(0xFFB6252A), width: 2),
          ),
          contentPadding: const EdgeInsets.symmetric(horizontal: 15),
        ),
      ),
      const SizedBox(height: 10),
    ],
  );
}
