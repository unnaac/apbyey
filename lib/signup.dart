import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'login.dart';
import 'auth.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final TextEditingController nikController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();
  final Auth _auth = Auth();
  String errorMessage = '';

  void _signUp() async {
    if (passwordController.text != confirmPasswordController.text) {
      setState(() {
        errorMessage = 'Kata sandi tidak cocok';
      });
      return;
    }

    try {
      User? user = await _auth.createUserWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
        nik: nikController.text,
        phone: phoneController.text,
        username: usernameController.text,
      );

      if (user != null) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const LoginPage()),
        );
      }
    } on FirebaseAuthException catch (e) {
      setState(() {
        errorMessage = e.message ?? 'Terjadi kesalahan';
      });
    }
  }

  @override
  void dispose() {
    nikController.dispose();
    phoneController.dispose();
    emailController.dispose();
    usernameController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

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
              _buildTextField(
                  label: 'NIK (Nomor Induk Kependudukan)',
                  controller: nikController),
              _buildPhoneField(controller: phoneController),
              _buildTextField(label: 'Email', controller: emailController),
              _buildTextField(
                  label: 'Username', controller: usernameController),
              _buildTextField(
                  label: 'Kata Sandi',
                  controller: passwordController,
                  obscureText: true),
              _buildTextField(
                  label: 'Konfirmasi Kata Sandi',
                  controller: confirmPasswordController,
                  obscureText: true),
              if (errorMessage.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: Text(
                    errorMessage,
                    style: const TextStyle(color: Colors.red, fontSize: 14),
                  ),
                ),
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
                  onPressed: _signUp,
                  child: const Text('Daftar',
                      style: TextStyle(fontSize: 18, color: Colors.white)),
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
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const LoginPage()),
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

  Widget _buildTextField(
      {required String label,
      required TextEditingController controller,
      bool obscureText = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: const TextStyle(
                fontWeight: FontWeight.bold, color: Color(0xFF777785))),
        const SizedBox(height: 5),
        TextField(
          controller: controller,
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

  Widget _buildPhoneField({required TextEditingController controller}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Nomor Telepon',
            style: TextStyle(
                fontWeight: FontWeight.bold, color: Color(0xFF777785))),
        const SizedBox(height: 5),
        TextField(
          controller: controller,
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
}
