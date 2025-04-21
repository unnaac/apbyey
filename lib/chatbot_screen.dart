import 'package:flutter/material.dart';

class ChatbotScreen extends StatefulWidget {
  const ChatbotScreen({Key? key}) : super(key: key);

  @override
  _ChatbotScreenState createState() => _ChatbotScreenState();
}

class _ChatbotScreenState extends State<ChatbotScreen>
    with TickerProviderStateMixin {
  final List<Map<String, dynamic>> _messages = [
    {
      'sender': 'user',
      'text': 'Kepada siapa saya harus melaporkan pelanggaran di tempat kerja?',
      'timestamp': 'Kemarin'
    },
    {
      'sender': 'bot',
      'text':
          'Untuk pelanggaran di tempat kerja anda dapat melaporkannya kepada Kementrian Ketenagakerjaan.',
      'timestamp': 'Kemarin'
    },
    {
      'sender': 'user',
      'text': 'Baik terimakasih atas informasinya',
      'timestamp': 'Kemarin'
    },
    {
      'sender': 'bot',
      'text':
          'Sama-sama, semoga informasi tersebut dapat membantu anda dan semoga hari anda menyenangkan',
      'timestamp': 'Kemarin'
    },
    {
      'sender': 'user',
      'text': 'Kepada siapa saya dapat melaporkan terkait pelanggaran HAM?',
      'timestamp': 'Hari Ini'
    },
    {
      'sender': 'bot',
      'text':
          'Jika terjadi pelanggaran HAM, anda dapat melaporkannya pada Polisi, Basarnas, Komnas HAM dan masih banyak lagi.',
      'timestamp': 'Hari Ini'
    },
  ];

  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  void _scrollToBottom() {
    Future.delayed(const Duration(milliseconds: 100), () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  void _sendMessage(String text) {
    if (text.trim().isEmpty) return;

    setState(() {
      _messages.add({'sender': 'user', 'text': text, 'timestamp': 'Hari Ini'});
      _messages.add(
          {'sender': 'bot', 'text': '', 'timestamp': ''}); // Typing indicator
    });

    _controller.clear();
    _scrollToBottom();

    // Simulate bot response
    Future.delayed(const Duration(seconds: 1), () {
      setState(() {
        _messages.removeLast(); // Remove typing indicator
        _messages.add({
          'sender': 'bot',
          'text': 'Terima kasih atas pertanyaannya. Kami akan segera membantu.',
          'timestamp': 'Hari Ini',
        });
      });
      _scrollToBottom();
    });
  }

  Widget _buildTypingIndicator() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Text(
          'Bot is typing',
          style: TextStyle(fontFamily: 'Poppins', color: Colors.grey),
        ),
        const SizedBox(width: 4),
        ...List.generate(3, (index) {
          return AnimatedOpacity(
            opacity: 1.0,
            duration: Duration(milliseconds: 500 + (index * 200)),
            curve: Curves.easeInOut,
            child: const Text(
              '.',
              style: TextStyle(fontSize: 18, color: Colors.grey),
            ),
          );
        }),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'MinTel Chatbot',
          style: TextStyle(
            fontFamily: 'Poppins',
          ),
        ),
        backgroundColor: Colors.red,
        centerTitle: true,
        elevation: 0,
      ),
      body: Column(
        children: [
          Expanded(
            child: Container(
              color: Colors.white,
              child: ListView.builder(
                controller: _scrollController,
                padding: const EdgeInsets.all(16.0),
                itemCount: _messages.length,
                itemBuilder: (context, index) {
                  final message = _messages[index];
                  final isUser = message['sender'] == 'user';
                  final showTimestamp = index == 0 ||
                      _messages[index - 1]['timestamp'] != message['timestamp'];

                  return AnimatedOpacity(
                    opacity: 1.0,
                    duration:
                        const Duration(milliseconds: 300), // Fade-in effect
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        if (showTimestamp)
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                            child: Text(
                              message['timestamp'],
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                fontSize: 14,
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Poppins',
                              ),
                            ),
                          ),
                        Align(
                          alignment: isUser
                              ? Alignment.centerRight
                              : Alignment.centerLeft,
                          child: Container(
                            margin: const EdgeInsets.symmetric(vertical: 8.0),
                            padding: const EdgeInsets.all(12.0),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.only(
                                topLeft: const Radius.circular(16.0),
                                topRight: const Radius.circular(16.0),
                                bottomLeft: isUser
                                    ? const Radius.circular(16.0)
                                    : Radius.zero,
                                bottomRight: isUser
                                    ? Radius.zero
                                    : const Radius.circular(16.0),
                              ),
                              border: isUser
                                  ? Border.all(
                                      color: const Color(0xFFED1E28),
                                      width: 1.0,
                                    )
                                  : Border.all(
                                      color: const Color(0xFFBDBDBD),
                                      width: 1.0),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withAlpha(26),
                                  offset: const Offset(0, 2),
                                  blurRadius: 4,
                                ),
                              ],
                            ),
                            child: message['text'].isEmpty
                                ? _buildTypingIndicator()
                                : Text(
                                    message['text'],
                                    style: TextStyle(
                                      color: isUser
                                          ? Colors.black
                                          : Colors.black87,
                                      fontFamily: 'Poppins',
                                    ),
                                  ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ),
          Container(
            color: Colors.grey[100],
            padding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.image, color: Colors.red),
                  onPressed: () {
                    // Handle image upload
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.mic, color: Colors.red),
                  onPressed: () {
                    // Handle microphone input
                  },
                ),
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: InputDecoration(
                      hintText: 'Ketik pesan...',
                      hintStyle: const TextStyle(
                        fontFamily: 'Poppins',
                      ),
                      filled: true,
                      fillColor: Colors.white,
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16.0, vertical: 12.0),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20.0),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8.0),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.red, // Set the background color
                    borderRadius:
                        BorderRadius.circular(20.0), // Rounded corners
                  ),
                  child: IconButton(
                    icon: const Icon(Icons.send,
                        color: Colors.white), // White icon
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
}
