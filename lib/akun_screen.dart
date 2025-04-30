import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'login.dart';
import 'dart:async';

class AkunScreen extends StatefulWidget {
  const AkunScreen({Key? key}) : super(key: key);

  @override
  _AkunScreenState createState() => _AkunScreenState();
}

class _AkunScreenState extends State<AkunScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final DatabaseReference _dbRef = FirebaseDatabase.instance.ref();
  Map<String, dynamic>? userData;
  bool isLoading = true;
  String? errorMessage;
  List<StreamSubscription<DatabaseEvent>> _listeners = [];

  Future<void> _fetchUserData() async {
    try {
      final User? user = _auth.currentUser;

      if (user == null) {
        setState(() {
          isLoading = false;
          errorMessage = 'Pengguna tidak terautentikasi';
        });
        return;
      }

      // Add listener for user data
      final listener =
          _dbRef.child('users/${user.uid}').onValue.listen((event) {
        if (event.snapshot.exists) {
          setState(() {
            userData = Map<String, dynamic>.from(event.snapshot.value as Map);
            isLoading = false;
          });
        } else {
          setState(() {
            isLoading = false;
            errorMessage = 'Data pengguna tidak ditemukan';
          });
        }
      });

      _listeners.add(listener);
    } catch (e) {
      setState(() {
        isLoading = false;
        errorMessage = 'Gagal memuat data: ${e.toString()}';
      });
    }
  }

  Future<void> _signOut() async {
    try {
      // Cancel all active listeners
      for (var listener in _listeners) {
        await listener.cancel();
      }

      await _auth.signOut();

      // Clear any remaining state
      if (mounted) {
        setState(() {
          userData = null;
        });
      }

      // Navigate to login screen and remove all routes
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => const LoginPage()),
        (Route<dynamic> route) => false,
      );
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Logout gagal: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
      debugPrint('Error logout: $e');
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchUserData();
  }

  @override
  void dispose() {
    // Cancel all listeners when widget is disposed
    for (var listener in _listeners) {
      listener.cancel();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Informasi Akun'),
        backgroundColor: Colors.red[700],
        automaticallyImplyLeading: true,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : errorMessage != null
              ? Center(child: Text(errorMessage!))
              : Column(
                  children: [
                    // Profile Card
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Card(
                        elevation: 4,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            children: [
                              CircleAvatar(
                                radius: 50,
                                backgroundColor: Colors.grey.shade200,
                                child: Icon(
                                  Icons.person,
                                  size: 50,
                                  color: Colors.grey.shade600,
                                ),
                              ),
                              const SizedBox(height: 16),
                              _buildInfoItem(
                                  'Username', userData?['username'] ?? '-'),
                              _buildInfoItem(
                                  'Email', _auth.currentUser?.email ?? '-'),
                              _buildInfoItem('NIK', userData?['nik'] ?? '-'),
                              _buildInfoItem(
                                  'Nomor Telepon', userData?['phone'] ?? '-'),
                            ],
                          ),
                        ),
                      ),
                    ),

                    const Spacer(),

                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red[700],
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 16),
                          ),
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                title: const Text('Konfirmasi'),
                                content: const Text(
                                    'Apakah Anda yakin ingin keluar?'),
                                actions: [
                                  TextButton(
                                    onPressed: () => Navigator.pop(context),
                                    child: const Text('Batal'),
                                  ),
                                  TextButton(
                                    onPressed: () async {
                                      Navigator.pop(context);
                                      await _signOut();
                                    },
                                    child: const Text('Keluar'),
                                  ),
                                ],
                              ),
                            );
                          },
                          child: const Text(
                            'Keluar',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
    );
  }

  Widget _buildInfoItem(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey.shade600,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: Colors.grey.shade800,
            ),
          ),
          const Divider(height: 24, thickness: 1),
        ],
      ),
    );
  }
}
