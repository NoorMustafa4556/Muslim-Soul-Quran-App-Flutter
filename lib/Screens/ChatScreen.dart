import 'package:flutter/material.dart';
import 'package:flutter_quran_yt/Constants/Constants.dart';
import '../Services/AIService.dart';

import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class ChatScreen extends StatefulWidget {
  static const String id = 'chat_screen'; // For named navigation

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _controller = TextEditingController();
  late GeminiService _gemini;

  // Chat History
  final List<Map<String, String>> _messages =
      []; // {role: user/model, text: ...}
  bool isLoading = false;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _gemini = GeminiService("AIzaSyD0d0iLwu9R3hA_5F83ydTiM8W7dov464E");
  }

  void sendPrompt() async {
    final text = _controller.text.trim();
    if (text.isEmpty) return;

    // 1. Add User Message
    setState(() {
      _messages.add({"role": "user", "text": text});
      isLoading = true;
    });
    _controller.clear();
    _scrollToBottom();

    // 2. Get AI Response
    final result = await _gemini.generate(text);

    // 3. Add AI Message
    setState(() {
      _messages.add({"role": "model", "text": result});
      isLoading = false;
    });
    _scrollToBottom();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Constants.kPrimary,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          "Islamic AI Assistant", // Renamed
          style: TextStyle(
              color: Colors.white, fontWeight: FontWeight.bold, fontSize: 22),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // ---------- CHAT HISTORY ----------
          Expanded(
            child: _messages.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(FontAwesomeIcons.robot,
                            size: 60, color: Colors.white24),
                        SizedBox(height: 20),
                        Text(
                          "Ask me about Islam...",
                          style: TextStyle(color: Colors.white54, fontSize: 18),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    controller: _scrollController,
                    padding: EdgeInsets.all(16),
                    itemCount: _messages.length + (isLoading ? 1 : 0),
                    itemBuilder: (context, index) {
                      if (index == _messages.length) {
                        // Loading Indicator Bubble
                        return Align(
                          alignment: Alignment.centerLeft,
                          child: Container(
                            margin: EdgeInsets.symmetric(vertical: 5),
                            padding: EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                  strokeWidth: 2, color: Constants.kGold),
                            ),
                          ),
                        );
                      }

                      final msg = _messages[index];
                      final isUser = msg['role'] == 'user';

                      return Align(
                        alignment: isUser
                            ? Alignment.centerRight
                            : Alignment.centerLeft,
                        child: Container(
                          margin: EdgeInsets.symmetric(vertical: 5),
                          padding: EdgeInsets.all(14),
                          constraints: BoxConstraints(
                              maxWidth:
                                  MediaQuery.of(context).size.width * 0.75),
                          decoration: BoxDecoration(
                            color: isUser
                                ? Constants.kGold
                                : Colors.white.withOpacity(0.1),
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(15),
                              topRight: Radius.circular(15),
                              bottomLeft:
                                  isUser ? Radius.circular(15) : Radius.zero,
                              bottomRight:
                                  isUser ? Radius.zero : Radius.circular(15),
                            ),
                            border: isUser
                                ? null
                                : Border.all(color: Colors.white24),
                          ),
                          child: Text(
                            msg['text']!,
                            style: TextStyle(
                              color: isUser ? Constants.kPrimary : Colors.white,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
          ),

          // ---------- INPUT FIELD ----------
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 20),
            decoration: BoxDecoration(
              color: Constants.kPrimary,
              borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
              boxShadow: [
                BoxShadow(
                    color: Colors.black26,
                    blurRadius: 10,
                    offset: Offset(0, -2))
              ],
            ),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(30),
                      border: Border.all(color: Colors.white12),
                    ),
                    child: TextField(
                      controller: _controller,
                      style: TextStyle(color: Colors.white),
                      cursorColor: Constants.kGold,
                      decoration: InputDecoration(
                        hintText: "Type your question...",
                        hintStyle: TextStyle(color: Colors.white54),
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                ),

                SizedBox(width: 12),

                // SEND ARROW BUTTON
                GestureDetector(
                  onTap: sendPrompt,
                  child: Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                        color: Constants.kGold,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                              color: Constants.kGold.withOpacity(0.4),
                              blurRadius: 10,
                              offset: Offset(0, 4))
                        ]),
                    child: Icon(
                      Icons.send_rounded,
                      color: Constants.kPrimary,
                      size: 26,
                    ),
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
