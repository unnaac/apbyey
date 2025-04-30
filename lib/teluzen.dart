import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_time_picker_spinner/flutter_time_picker_spinner.dart';
import 'buatjadwal.dart';
import 'buatteluzen.dart';
import 'clipper.dart';
import 'komentar.dart';
import 'post_model.dart';
import 'edit_post.dart';

class TeluzenScreen extends StatefulWidget {
  @override
  _TeluzenScreenState createState() => _TeluzenScreenState();
}

class _TeluzenScreenState extends State<TeluzenScreen> {
  late DatabaseReference _postsRef;
  List<Post> _posts = [];
  bool _isLoading = true;
  final _currentUser = FirebaseAuth.instance.currentUser;

  @override
  void initState() {
    super.initState();
    _postsRef = FirebaseDatabase.instance.ref().child('posts');
    _fetchPosts();
  }

  void _fetchPosts() {
    _postsRef.onValue.listen((event) {
      final data = event.snapshot.value as Map<dynamic, dynamic>?;
      
      if (data != null) {
        final posts = data.entries.map((entry) {
          return Post.fromMap(
            Map<String, dynamic>.from(entry.value),
            entry.key.toString(),
          );
        }).toList();

        setState(() {
          _posts = posts..sort((a, b) => b.timestamp.compareTo(a.timestamp));
          _isLoading = false;
        });
      } else {
        setState(() => _isLoading = false);
      }
    });
  }

  Future<void> _toggleLike(Post post) async {
    try {
      final userId = _currentUser?.uid;
      if (userId == null) return;

      final isLiked = post.likedBy.contains(userId);
      final newLikedBy = isLiked
          ? post.likedBy.where((id) => id != userId).toList()
          : [...post.likedBy, userId];

      await _postsRef.child(post.id).update({
        'likeCount': isLiked ? post.likeCount - 1 : post.likeCount + 1,
        'likedBy': newLikedBy,
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal mengupdate like: $e')),
      );
    }
  }

  void _deletePost(String postId) async {
    try {
      await _postsRef.child(postId).remove();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Post berhasil dihapus')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal menghapus: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          // Header dengan clipper
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
                    "Suara Telutizen",
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
          
          // Konten utama
          Expanded(
            child: _isLoading
                ? Center(child: CircularProgressIndicator())
                : _posts.isEmpty
                    ? Center(child: Text('Belum ada post'))
                    : ListView.builder(
                        padding: EdgeInsets.all(8),
                        itemCount: _posts.length,
                        itemBuilder: (context, index) {
                          final post = _posts[index];
                          return _buildPostCard(post);
                        },
                      ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => BuatTeluzenScreen()),
        ),
        backgroundColor: Colors.red,
        child: Icon(Icons.add),
      ),
    );
  }

  Widget _buildPostCard(Post post) {
    final isLiked = post.likedBy.contains(_currentUser?.uid);
    
    return Card(
      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      color: Colors.white,
      child: Padding(
        padding: EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  child: Text(post.username[0]),
                  backgroundColor: Colors.red[100],
                ),
                SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(post.username, style: TextStyle(fontWeight: FontWeight.bold)),
                    Text(post.formattedTime, style: TextStyle(color: Colors.grey, fontSize: 12)),
                  ],
                ),
                Spacer(),
                if (post.userId == _currentUser?.uid)
                  IconButton(
                    icon: Icon(Icons.menu),
                    onPressed: () => _showPostMenu(context, post),
                  ),
              ],
            ),
            SizedBox(height: 8),
            Text(post.text),
            SizedBox(height: 12),
            Divider(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildLikeButton(post, isLiked),
                _buildCommentButton(post),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLikeButton(Post post, bool isLiked) {
    return TextButton.icon(
      onPressed: () => _toggleLike(post),
      icon: Icon(
        isLiked ? Icons.favorite : Icons.favorite_border,
        color: isLiked ? Colors.red : Colors.grey,
      ),
      label: Text(
        isLiked && post.likeCount > 0 ? '${post.likeCount}' : 'Suka',
        style: TextStyle(color: isLiked ? Colors.red : Colors.grey),
      ),
      style: TextButton.styleFrom(
        foregroundColor: Colors.red,
      ),
    );
  }

  Widget _buildCommentButton(Post post) {
    return TextButton.icon(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => KomenScreen(post: post)),
        );
      },
      icon: Icon(Icons.comment, color: Colors.grey),
      label: Text('Komentar', style: TextStyle(color: Colors.grey)),
      style: TextButton.styleFrom(
        foregroundColor: Colors.red,
      ),
    );
  }

  void _showPostMenu(BuildContext context, Post post) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        contentPadding: EdgeInsets.zero,
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: Icon(Icons.edit),
              title: Text('Edit'),
              onTap: () {
                Navigator.pop(context);
                _showEditDialog(context, post);
              },
            ),
            Divider(height: 1),
            ListTile(
              leading: Icon(Icons.delete, color: Colors.red),
              title: Text('Hapus', style: TextStyle(color: Colors.red)),
              onTap: () {
                Navigator.pop(context);
                _deletePost(post.id);
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showEditDialog(BuildContext context, Post post) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: Container(
          padding: EdgeInsets.all(16),
          width: MediaQuery.of(context).size.width * 0.8,
          child: EditPostScreen(post: post),
        ),
      ),
    );
  }
}