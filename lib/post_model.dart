import 'package:intl/intl.dart';

class Post {
  final String id;
  final String userId;
  final String username;
  final String text;
  final String timestamp;
  final bool isEdited;
  final String? editTime;
  final int likeCount;      // Tambahkan ini
  final List<String> likedBy; // Tambahkan ini

  Post({
    required this.id,
    required this.userId,
    required this.username,
    required this.text,
    required this.timestamp,
    this.isEdited = false,
    this.editTime,
    this.likeCount = 0,     // Default value 0
    this.likedBy = const [], // Default empty list
  });

  factory Post.fromMap(Map<String, dynamic> map, String id) {
    return Post(
      id: id,
      userId: map['userId'] ?? '',
      username: (map['username'] as String?) ?? 'Anonymous', 
      text: map['text'] ?? '',
      timestamp: map['timestamp'] ?? '',
      isEdited: map['isEdited'] ?? false,
      editTime: map['editTime'],
      likeCount: (map['likeCount'] as int?) ?? 0,
      likedBy: List<String>.from(map['likedBy'] ?? []),
    );
  }

  String get formattedTime {
    final baseText = _calculateTimeDifference(timestamp);
    if (!isEdited || editTime == null) return baseText;
    
    final editText = _calculateEditedTimeDifference();
    return '$baseText • Diedit $editText';
  }

  String _calculateTimeDifference(String timeString) {
    try {
      final postDate = _parseDateTime(timeString);
      final now = DateTime.now();
      final difference = now.difference(postDate);

      if (difference.inSeconds < 60) return 'Baru saja';
      if (difference.inMinutes < 60) return '${difference.inMinutes} menit lalu';
      if (difference.inHours < 24) return '${difference.inHours} jam lalu';
      if (difference.inDays < 7) return '${difference.inDays} hari lalu';
      
      return DateFormat('dd/MM/yyyy').format(postDate);
    } catch (e) {
      return timeString.split(' ').first; // Return date part only as fallback
    }
  }

  String _calculateEditedTimeDifference() {
    try {
      final editedDate = _parseDateTime(editTime!);
      final now = DateTime.now();
      final difference = now.difference(editedDate);

      if (difference.inSeconds < 60) return 'baru saja';
      if (difference.inMinutes < 60) return '${difference.inMinutes} menit lalu';
      if (difference.inHours < 24) return '${difference.inHours} jam lalu';
      
      return 'pada ${DateFormat('dd/MM/yyyy HH:mm').format(editedDate)}';
    } catch (e) {
      return '';
    }
  }

  DateTime _parseDateTime(String timeString) {
    final parts = timeString.split(' ');
    final dateParts = parts[0].split('-');
    final timeParts = parts[1].split(':');

    return DateTime(
      int.parse(dateParts[2]), // Year
      int.parse(dateParts[1]), // Month
      int.parse(dateParts[0]), // Day
      int.parse(timeParts[0]), // Hour
      int.parse(timeParts[1]), // Minute
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'username': username,
      'text': text,
      'timestamp': timestamp,
      'isEdited': isEdited,
      'editTime': editTime,
    };
  }
}