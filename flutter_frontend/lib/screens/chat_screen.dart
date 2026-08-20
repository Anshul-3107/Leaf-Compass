import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../models/chat_message.dart';
import '../services/api_service.dart';
import '../main.dart';

/// Full-page AI Chat — mirrors Chatpage.jsx
/// Includes scrollable message list, user/bot avatars, loading indicator,
/// send button, and clear chat button.
class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final List<ChatMessage> _messages = [
    ChatMessage(
      sender: 'bot',
      text:
          'Hello! I am AgroBot, your AI farming assistant. 🌾\nAsk me about crop diseases, fertilizer tips, or weather advice!',
    ),
  ];

  final TextEditingController _ctrl = TextEditingController();
  final ScrollController _scrollCtrl = ScrollController();
  bool _loading = false;

  void _scrollToBottom() {
    Future.delayed(const Duration(milliseconds: 120), () {
      if (_scrollCtrl.hasClients) {
        _scrollCtrl.animateTo(
          _scrollCtrl.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  Future<void> _handleSend() async {
    final text = _ctrl.text.trim();
    if (text.isEmpty) return;

    setState(() {
      _messages.add(ChatMessage(sender: 'user', text: text));
      _loading = true;
    });
    _ctrl.clear();
    _scrollToBottom();

    try {
      final res = await ApiService.chatWithBot(text);
      final reply = res.data['response'] as String? ??
          '⚠️ No response received.';
      setState(() => _messages.add(ChatMessage(sender: 'bot', text: reply)));
    } catch (_) {
      setState(() => _messages.add(ChatMessage(
            sender: 'bot',
            text: '⚠️ Network error. Please try again.',
          )));
    } finally {
      setState(() => _loading = false);
      _scrollToBottom();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Header bar — mirrors the chat header in Chatpage.jsx
      appBar: AppBar(
        backgroundColor: kAgriGreen,
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.2),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.smart_toy, color: Colors.white, size: 20),
            ),
            const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('AgroBot AI',
                    style: GoogleFonts.inter(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                        fontSize: 16)),
                Text('Powered by DeepSeek',
                    style: GoogleFonts.inter(
                        color: Colors.green[100], fontSize: 11)),
              ],
            ),
          ],
        ),
        actions: [
          // Clear chat button (mirrors trash icon in Chatpage.jsx)
          IconButton(
            icon: const Icon(Icons.delete_outline, color: Colors.white),
            tooltip: 'Clear Chat',
            onPressed: () {
              setState(() {
                _messages.clear();
                _messages.add(ChatMessage(
                  sender: 'bot',
                  text:
                      'Chat cleared! How can I help you with farming today? 🌾',
                ));
              });
            },
          ),
        ],
      ),

      body: Column(
        children: [
          // Messages area
          Expanded(
            child: Container(
              color: const Color(0xFFF5F7F5),
              child: ListView.builder(
                controller: _scrollCtrl,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                itemCount: _messages.length + (_loading ? 1 : 0),
                itemBuilder: (ctx, i) {
                  // Loading indicator
                  if (_loading && i == _messages.length) {
                    return _BotTypingBubble().animate().fadeIn();
                  }
                  final msg = _messages[i];
                  return _MessageBubble(message: msg, index: i);
                },
              ),
            ),
          ),

          // Input area — mirrors the form in Chatpage.jsx
          Container(
            padding: const EdgeInsets.fromLTRB(12, 10, 12, 16),
            decoration: const BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                    color: Colors.black12, blurRadius: 8, offset: Offset(0, -2))
              ],
            ),
            child: SafeArea(
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _ctrl,
                      decoration: InputDecoration(
                        hintText:
                            'Ask about crops, diseases, or weather...',
                        hintStyle: GoogleFonts.inter(
                            fontSize: 13, color: Colors.grey[500]),
                        filled: true,
                        fillColor: const Color(0xFFF5F7F5),
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 12),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(24),
                          borderSide: BorderSide.none,
                        ),
                      ),
                      minLines: 1,
                      maxLines: 4,
                      textInputAction: TextInputAction.send,
                      onSubmitted: (_) => _handleSend(),
                    ),
                  ),
                  const SizedBox(width: 8),
                  GestureDetector(
                    onTap: (_loading || _ctrl.text.trim().isEmpty)
                        ? null
                        : _handleSend,
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      width: 46,
                      height: 46,
                      decoration: BoxDecoration(
                        color: _loading ? Colors.grey[400] : kAgriGreen,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                              color: kAgriGreen.withValues(alpha: 0.35),
                              blurRadius: 8,
                              offset: const Offset(0, 3))
                        ],
                      ),
                      child: const Icon(Icons.send,
                          color: Colors.white, size: 20),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Message Bubble ────────────────────────────────────────────────────────
class _MessageBubble extends StatelessWidget {
  final ChatMessage message;
  final int index;
  const _MessageBubble({required this.message, required this.index});

  @override
  Widget build(BuildContext context) {
    final isUser = message.isUser;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment:
            isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          // Bot avatar
          if (!isUser)
            Container(
              width: 32,
              height: 32,
              margin: const EdgeInsets.only(right: 8),
              decoration: const BoxDecoration(
                color: kAgriGreenLight,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.smart_toy, size: 18, color: kAgriGreen),
            ),

          // Message bubble
          Flexible(
            child: Container(
              constraints: BoxConstraints(
                  maxWidth: MediaQuery.of(context).size.width * 0.75),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: isUser ? kAgriGreen : Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(18),
                  topRight: const Radius.circular(18),
                  bottomLeft: Radius.circular(isUser ? 18 : 4),
                  bottomRight: Radius.circular(isUser ? 4 : 18),
                ),
                boxShadow: [
                  BoxShadow(
                      color: Colors.black.withValues(alpha: 0.06),
                      blurRadius: 6,
                      offset: const Offset(0, 2))
                ],
              ),
              child: Text(
                message.text,
                style: GoogleFonts.inter(
                  fontSize: 14,
                  color: isUser ? Colors.white : Colors.grey[800],
                  height: 1.45,
                ),
              ),
            ),
          ),

          // User avatar
          if (isUser)
            Container(
              width: 32,
              height: 32,
              margin: const EdgeInsets.only(left: 8),
              decoration: const BoxDecoration(
                color: Color(0xFFE0E0E0),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.person, size: 18, color: Colors.grey),
            ),
        ],
      ),
    ).animate(delay: Duration(milliseconds: 30 * (index % 10))).fadeIn().slideY(
        begin: 0.05, end: 0, duration: 200.ms);
  }
}

// ── Typing Indicator ──────────────────────────────────────────────────────
class _BotTypingBubble extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Container(
            width: 32,
            height: 32,
            margin: const EdgeInsets.only(right: 8),
            decoration: const BoxDecoration(
                color: kAgriGreenLight, shape: BoxShape.circle),
            child: const Icon(Icons.smart_toy, size: 18, color: kAgriGreen),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(18),
              boxShadow: [
                BoxShadow(
                    color: Colors.black.withValues(alpha: 0.06),
                    blurRadius: 6,
                    offset: const Offset(0, 2))
              ],
            ),
            child: Row(
              children: [
                const SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(
                        strokeWidth: 2, color: kAgriGreen)),
                const SizedBox(width: 8),
                Text('Thinking...',
                    style:
                        GoogleFonts.inter(color: Colors.grey[500], fontSize: 13)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
