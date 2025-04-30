import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:flutter_time_picker_spinner/flutter_time_picker_spinner.dart';
import 'package:intl/intl.dart';
import 'buatjadwal.dart';
import 'buatteluzen.dart';
import 'clipper.dart';
import 'post_model.dart';

class KomenScreen extends StatefulWidget {
  final Post post;

  const KomenScreen({Key? key, required this.post}) : super(key: key);

  @override
  State<KomenScreen> createState() => _KomenScreenState();
}

class _KomenScreenState extends State<KomenScreen> {
  final TextEditingController _commentController = TextEditingController();
  late DatabaseReference _commentsRef;
  final _currentUser = FirebaseAuth.instance.currentUser;
  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    _commentsRef = FirebaseDatabase.instance
        .ref()
        .child('posts/${widget.post.id}/comments');
  }

  String _timeAgo(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inSeconds < 60) {
      return 'Baru saja';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes} menit yang lalu';
    } else if (difference.inHours < 24) {
      return '${difference.inHours} jam yang lalu';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} hari yang lalu';
    } else {
      return DateFormat('dd-MM-yyyy').format(timestamp);
    }
  }

  String _timeAgoEdited(DateTime? editedAt) {
    if (editedAt == null) return '';
    
    final now = DateTime.now();
    final difference = now.difference(editedAt);

    if (difference.inSeconds < 60) {
      return ' (Diedit beberapa detik yang lalu)';
    } else if (difference.inMinutes < 60) {
      return ' (Diedit ${difference.inMinutes} menit yang lalu)';
    } else if (difference.inHours < 24) {
      return ' (Diedit ${difference.inHours} jam yang lalu)';
    } else if (difference.inDays < 7) {
      return ' (Diedit ${difference.inDays} hari yang lalu)';
    } else {
      return ' (Diedit ${DateFormat('dd/MM/yyyy').format(editedAt)})';
    }
  }

  void _submitComment() async {
    final cleanedText = _commentController.text.trim();
    
    // Gunakan null-aware operator dan null coalescing
    if ((cleanedText?.isEmpty ?? true)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Komentar tidak boleh kosong')),
      );
      return;
    }

    setState(() => _isSubmitting = true);

    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) return;

      final userSnapshot = await FirebaseDatabase.instance
          .ref()
          .child("users/${user.uid}")
          .once();

      final username = userSnapshot.snapshot.child('username').value as String?;

      final now = DateTime.now();
      final formattedDate = DateFormat('dd-MM-yyyy HH:mm').format(now);

      await _commentsRef.push().set({
        'userId': user.uid,
        'username': username ?? 'Pengguna',
        'text': cleanedText!,
        'timestamp': formattedDate,
      });
      
      _commentController.clear();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${e.toString()}')),
      );
    } finally {
      setState(() => _isSubmitting = false);
    }
  }

  void _deleteComment(String commentId) async {
    try {
      await _commentsRef.child(commentId).remove();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal menghapus: $e')),
      );
    }
  }

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(statusBarColor: Colors.red),
    );

    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          ClipPath(
            clipper: MyClipper(),
            child: Container(
              color: Colors.red,
              height: 120,
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.white),
                    onPressed: () => Navigator.pop(context),
                  ),
                  const SizedBox(width: 10),
                  const Text(
                    "Komentar",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
          
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  _buildPostCard(),
                  _buildCommentsList(),
                ],
              ),
            ),
          ),
          
          _buildCommentInput(),
        ],
      ),
    );
  }

  Widget _buildPostCard() {
    final username = widget.post.username.isEmpty 
        ? 'Anonymous' 
        : widget.post.username;
        
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListTile(
            contentPadding: EdgeInsets.zero,
            leading: CircleAvatar(
              child: Text(username[0].toUpperCase()),
            ),
            title: Text(
              username,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Text(widget.post.formattedTime),
          ),
          const SizedBox(height: 8),
          Text(widget.post.text),
        ],
      ),
    );
  }

  Widget _buildCommentsList() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: StreamBuilder(
        stream: _commentsRef.onValue,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final data = snapshot.data!.snapshot.value;
          if (data == null) {
            return const Center(child: Text('Belum ada komentar'));
          }

          final commentsMap = data as Map<dynamic, dynamic>;
          final comments = commentsMap.entries.map((entry) {
            try {
              return Comment.fromMap(
                Map<dynamic, dynamic>.from(entry.value), 
                entry.key.toString(),
              );
            } catch (e) {
              return Comment.invalid();
            }
          }).where((comment) => comment.isValid).toList()
            ..sort((a, b) => b.timestamp.compareTo(a.timestamp));

          return ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: comments.length,
            itemBuilder: (context, index) => _buildCommentItem(comments[index]),
          );
        },
      ),
    );
  }

  Widget _buildCommentItem(Comment comment) {
    final isCurrentUser = comment.userId == _currentUser?.uid;
    final username = comment.username.isNotEmpty 
      ? comment.username 
      : 'Pengguna';
  
    final initial = username.isNotEmpty 
      ? username[0].toUpperCase()
      : 'P';

    return Container(
    margin: const EdgeInsets.only(bottom: 8),
    padding: const EdgeInsets.all(12),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(8),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            CircleAvatar(child: Text(initial), radius: 16),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                username,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
            ),
            Text(
              _timeAgo(comment.timestamp),
              style: const TextStyle(fontSize: 10),
            ),
            if (isCurrentUser)
              IconButton(
                icon: const Icon(Icons.more_vert, size: 16),
                onPressed: () => _showCommentMenu(context, comment.id, comment.text),
              ),
          ],
        ),
        const SizedBox(height: 4),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(comment.text),
            if (comment.editedAt != null)
              Text(
                _timeAgoEdited(comment.editedAt),
                style: TextStyle(
                  fontSize: 10,
                  color: Colors.grey[600],
                  fontStyle: FontStyle.italic,
                ),
              ),
          ],
        ),
      ],
    ),
  );
  }

  Widget _buildCommentInput() {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Colors.grey[200]!)),
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _commentController,
              decoration: InputDecoration(
                hintText: 'Tulis komentar...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                suffixIcon: _isSubmitting
                    ? const Padding(
                        padding: EdgeInsets.all(12),
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.red,
                        ),
                      )
                    : null,
              ),
              maxLines: null,
              enabled: !_isSubmitting,
            ),
          ),
          IconButton(
            icon: _isSubmitting
                ? const CircularProgressIndicator(
                    color: Colors.red, 
                    strokeWidth: 2,
                  )
                : const Icon(Icons.send, color: Colors.red),
            onPressed: _isSubmitting ? null : _submitComment,
          ),
        ],
      ),
    );
  }

  void _updateComment(String commentId, String newText) async {
    try {
      final now = DateTime.now();
      final formattedDate = DateFormat('dd-MM-yyyy HH:mm').format(now); 
      await _commentsRef.child(commentId).update({
        'text': newText,
        'editedAt': formattedDate,
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal mengupdate komentar: $e')),
      );
    }
  }

  void _showEditCommentDialog(String commentId, String currentText) {
    final textController = TextEditingController(text: currentText);
    
    showDialog(
      context: context,
      builder: (context) => Dialog(
        insetPadding: const EdgeInsets.all(20),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        child: Container(
          constraints: const BoxConstraints(maxWidth: 500),
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Edit Komentar',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 15),
              TextField(
                controller: textController,
                maxLines: 3,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  hintText: 'Tulis komentar...',
                ),
              ),
              const SizedBox(height: 15),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Batal'),
                  ),
                  const SizedBox(width: 10),
                  ElevatedButton(
                    onPressed: () {
                      if (textController.text.trim().isNotEmpty) {
                        _updateComment(commentId, textController.text.trim());
                        Navigator.pop(context);
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      foregroundColor: Colors.white,
                    ),
                    child: const Text('Simpan'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showCommentMenu(BuildContext context, String commentId, String currentText) {
    showDialog(
      context: context,
      builder: (context) {
        return Center(
          child: Container(
            margin: const EdgeInsets.all(20),
            child: Material(
              borderRadius: BorderRadius.circular(15),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Edit Button
                  _buildMenuButton(
                    icon: Icons.edit,
                    label: 'Edit Komentar',
                    color: Colors.blue,
                    onTap: () {
                      Navigator.pop(context);
                      _showEditCommentDialog(commentId, currentText);
                    },
                  ),
                  
                  // Delete Button
                  _buildMenuButton(
                    icon: Icons.delete,
                    label: 'Hapus Komentar',
                    color: Colors.red,
                    onTap: () {
                      Navigator.pop(context);
                      _deleteComment(commentId);
                    },
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

  Widget _buildMenuButton({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: 200,
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        decoration: BoxDecoration(
          border: Border(
            bottom: label != 'Batal' 
                ? BorderSide(color: Colors.grey.shade200)
                : BorderSide.none,
          ),
        ),
        child: Row(
          children: [
            Icon(icon, color: color),
            const SizedBox(width: 12),
            Text(
              label,
              style: TextStyle(
                color: color,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
class Comment {
  final String id;
  final String userId;
  final String username;
  final String text;
  final DateTime timestamp;
  final DateTime? editedAt;
  final bool isValid;
 

  Comment({
    required this.id,
    required this.userId,
    required this.username,
    required this.text,
    required this.timestamp,
    this.editedAt,
    this.isValid = true,
  });

  String _timeAgo(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inSeconds < 60) {
      return 'Baru saja';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes} menit yang lalu';
    } else if (difference.inHours < 24) {
      return '${difference.inHours} jam yang lalu';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} hari yang lalu';
    } else {
      return DateFormat('dd-MM-yyyy').format(timestamp);
    }
  }

  String _timeAgoEdited(DateTime? editedAt) {
    if (editedAt == null) return '';
    
    final now = DateTime.now();
    final difference = now.difference(editedAt);

    if (difference.inSeconds < 60) {
      return ' (Diedit beberapa detik yang lalu)';
    } else if (difference.inMinutes < 60) {
      return ' (Diedit ${difference.inMinutes} menit yang lalu)';
    } else if (difference.inHours < 24) {
      return ' (Diedit ${difference.inHours} jam yang lalu)';
    } else if (difference.inDays < 7) {
      return ' (Diedit ${difference.inDays} hari yang lalu)';
    } else {
      return ' (Diedit ${DateFormat('dd/MM/yyyy').format(editedAt)})';
    }
  }

  factory Comment.fromMap(Map<dynamic, dynamic> map, String id) {
    try {
      DateTime parsedDate;
      DateTime? parsedEditedDate;
      try {
        parsedDate = DateTime.parse(map['timestamp'] as String);
      } catch (_) {
        parsedDate = DateFormat('dd-MM-yyyy HH:mm').parse(map['timestamp'] as String);
      }
      if (map['editedAt'] != null) {
        try {
          parsedEditedDate = DateFormat('dd-MM-yyyy HH:mm').parse(map['editedAt'] as String);
        } catch (_) {
          // Fallback jika format tidak sesuai
          parsedEditedDate = DateTime.parse(map['editedAt'] as String);
        }
      }

      return Comment(
        id: id,
        userId: map['userId']?.toString() ?? 'unknown',
        username: map['username']?.toString() ?? 'User', 
        text: map['text']?.toString() ?? '',
        timestamp: parsedDate,
        editedAt: parsedEditedDate,
      );
    } catch (e) {
      return Comment.invalid();
    }
  }

  factory Comment.invalid() => Comment(
    id: 'invalid',
    userId: 'invalid',
    username: 'Invalid',
    text: 'Invalid comment',
    timestamp: DateTime.now(),
    isValid: false,
  );
}