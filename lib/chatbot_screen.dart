import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ChatbotScreen extends StatefulWidget {
  const ChatbotScreen({Key? key}) : super(key: key);

  @override
  _ChatbotScreenState createState() => _ChatbotScreenState();
}

class _ChatbotScreenState extends State<ChatbotScreen> {
  final List<Map<String, dynamic>> _messages = [];
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  bool _isTyping = false;
  // Gunakan Groq API Key Anda di sini
  static const String _apiKey =
      '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'; // Ganti dengan API key Groq Anda
  static const String _apiUrl =
      'https://api.groq.com/openai/v1/chat/completions';

  @override
  void initState() {
    super.initState();
    _addBotMessage(
        'Halo! Saya MinTel Chatbot. Saya di sini untuk membantu Anda dengan pertanyaan terkait PPKS, perlindungan perundungan, dan kekerasan seksual.');
  }

  void _addBotMessage(String text) {
    setState(() {
      _messages.add(
          {'sender': 'bot', 'text': text, 'timestamp': _getCurrentTimestamp()});
    });
    _scrollToBottom();
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
    }
  }

  String _getCurrentTimestamp() {
    final now = DateTime.now();
    return '${now.hour}:${now.minute.toString().padLeft(2, '0')}';
  }

  Future<void> _sendMessage(String text) async {
    if (text.trim().isEmpty) return;

    setState(() {
      _messages.add({
        'sender': 'user',
        'text': text,
        'timestamp': _getCurrentTimestamp()
      });
      _isTyping = true;
    });

    _controller.clear();
    _scrollToBottom();

    try {
      final response = await http.post(
        Uri.parse(_apiUrl),
        headers: {
          'Authorization':
              'Bearer $_apiKey', // Gunakan otorisasi Bearer dengan API key Groq
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'model': 'llama-3.1-8b-instant', // Gunakan model llama-3.1-8b-instant
          'messages': [
            {
              'role': 'system',
              'content':
                  'Anda adalah asisten chatbot untuk aplikasi MinTel. Anda hanya menjawab pertanyaan terkait PPKS (Pencegahan dan Penanganan Kekerasan Seksual), perlindungan perundungan, dan kekerasan seksual. Jika pertanyaan di luar topik ini, berikan jawaban yang sesuai.',
            },
            ..._messages.map((msg) => {
                  'role': msg['sender'] == 'user' ? 'user' : 'assistant',
                  'content': msg['text'],
                }),
          ],
          'temperature': 0.7, // Sesuaikan parameter sesuai kebutuhan Anda
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final choices = data['choices'];
        if (choices != null &&
            choices.isNotEmpty &&
            choices[0]['message']?['content'] != null) {
          final reply = choices[0]['message']['content'];
          _addBotMessage(reply);
        } else {
          _addBotMessage('Maaf, saya tidak dapat memproses permintaan Anda.');
        }
      } else {
        _addBotMessage(
            'Maaf, terjadi kesalahan. Kode: ${response.statusCode}, Pesan: ${response.body}'); //Tambahkan pesan error
      }
    } catch (e) {
      _addBotMessage('Koneksi error: ${e.toString()}');
    } finally {
      setState(() => _isTyping = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('MinTel Chatbot',
            style: TextStyle(fontFamily: 'Poppins')),
        backgroundColor: Colors.red,
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.all(16.0),
              itemCount: _messages.length + (_isTyping ? 1 : 0),
              itemBuilder: (context, index) {
                if (index == _messages.length) {
                  return _buildTypingIndicator();
                }
                return _buildMessageBubble(_messages[index]);
              },
            ),
          ),
          Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            color: Colors.grey[100],
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: InputDecoration(
                      hintText: 'Ketik pesan...',
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20.0),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16.0, vertical: 12.0),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                CircleAvatar(
                  backgroundColor: Colors.red,
                  child: IconButton(
                    icon: const Icon(Icons.send, color: Colors.white),
                    onPressed: () => _sendMessage(_controller.text),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMessageBubble(Map<String, dynamic> message) {
    final isUser = message['sender'] == 'user';
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        padding: const EdgeInsets.all(12.0),
        decoration: BoxDecoration(
          color: isUser ? Colors.red[200] : Colors.white,
          borderRadius: BorderRadius.circular(16.0),
          border: Border.all(color: const Color(0xFFBDBDBD), width: 1.0),
          boxShadow: [
            BoxShadow(
                color: Colors.black.withAlpha(26),
                offset: const Offset(0, 2),
                blurRadius: 4)
          ],
        ),
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.7,
        ),
        child: Column(
          crossAxisAlignment:
              isUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          children: [
            Text(
              message['text'],
              style: TextStyle(
                color: isUser ? Colors.black : Colors.black,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              message['timestamp'],
              style: TextStyle(
                color: isUser ? Colors.grey[800] : Colors.grey[600],
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTypingIndicator() {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      padding: const EdgeInsets.all(12.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.0),
        border: Border.all(color: const Color(0xFFBDBDBD), width: 1.0),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withAlpha(26),
              offset: const Offset(0, 2),
              blurRadius: 4)
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: List.generate(
            3,
            (index) => Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 2),
                  child: Container(
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                        color: Colors.grey[400], shape: BoxShape.circle),
                  ),
                )),
      ),
    );
  }
}
