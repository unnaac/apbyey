import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'post_model.dart';

class EditPostScreen extends StatefulWidget {
  final Post post;

  const EditPostScreen({Key? key, required this.post}) : super(key: key);

  @override
  _EditPostScreenState createState() => _EditPostScreenState();
}

class _EditPostScreenState extends State<EditPostScreen> {
  late TextEditingController _textController;
  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    _textController = TextEditingController(text: widget.post.text);
  }

  Future<void> _submitUpdate() async {
    if (_textController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Post tidak boleh kosong')),
      );
      return;
    }

    setState(() => _isSubmitting = true);

    try {
      await FirebaseDatabase.instance
          .ref('posts/${widget.post.id}')
          .update({
            'text': _textController.text,
            'isEdited': true,
            'editTime': _getFormattedDate(),
          });

      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Post berhasil diperbarui')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal mengupdate: $e')),
      );
    } finally {
      setState(() => _isSubmitting = false);
    }
  }

  String _getFormattedDate() {
    final now = DateTime.now();
    return '${now.day.toString().padLeft(2,'0')}-${now.month.toString().padLeft(2,'0')}-${now.year} '
           '${now.hour.toString().padLeft(2,'0')}:${now.minute.toString().padLeft(2,'0')}';
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Post'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Ganti Expanded dengan Container dengan height tertentu
            Container(
              constraints: BoxConstraints(
                minHeight: 100, // Tinggi minimal
                maxHeight: MediaQuery.of(context).size.height * 0.4, // Tinggi maksimal 40% layar
              ),
              child: TextField(
                controller: _textController,
                maxLines: null, // Bisa multiline
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Edit postingan Anda',
                  hintText: 'Tulis sesuatu...',
                  alignLabelWithHint: true,
                  contentPadding: EdgeInsets.all(12),
                ),
              ),
            ),
            SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: _isSubmitting ? null : _submitUpdate,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                icon: _isSubmitting 
                    ? SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        ),
                      )
                    : Icon(Icons.send),
                label: Text(_isSubmitting ? 'Mengirim...' : 'Kirim'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}