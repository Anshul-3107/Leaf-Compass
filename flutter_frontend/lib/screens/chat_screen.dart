import 'package:flutter/material.dart';

import '../models/chat_message.dart';
import '../services/api_service.dart';
import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';
import '../theme/app_typography.dart';
import '../widgets/chat_bubble.dart';

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
      // ── Header bar ──
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [AppColors.primaryDark, AppColors.primary],
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            ),
          ),
        ),
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.2),
                shape: BoxShape.circle,
              ),
              child:
                  const Icon(Icons.smart_toy, color: Colors.white, size: 20),
            ),
            const SizedBox(width: AppSpacing.md),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('AgroBot AI',
                    style: AppTypography.titleMedium
                        .copyWith(color: Colors.white)),
                Text('Powered by DeepSeek',
                    style: AppTypography.labelSmall.copyWith(
                        color: Colors.white.withValues(alpha: 0.7),
                        letterSpacing: 0)),
              ],
            ),
          ],
        ),
        actions: [
          // Clear chat button
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
          // ── Messages area ──
          Expanded(
            child: Container(
              color: AppColors.surface,
              child: ListView.builder(
                controller: _scrollCtrl,
                padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.screenH,
                    vertical: AppSpacing.lg),
                itemCount: _messages.length + (_loading ? 1 : 0),
                itemBuilder: (ctx, i) {
                  // Typing indicator
                  if (_loading && i == _messages.length) {
                    return const ChatTypingIndicator();
                  }
                  final msg = _messages[i];
                  return ChatBubble(
                    text: msg.text,
                    isUser: msg.isUser,
                    index: i,
                  );
                },
              ),
            ),
          ),

          // ── Input area ──
          Container(
            padding: const EdgeInsets.fromLTRB(
                AppSpacing.md, AppSpacing.md, AppSpacing.md, AppSpacing.lg),
            decoration: BoxDecoration(
              color: AppColors.surfaceContainer,
              border: Border(
                top: BorderSide(color: AppColors.surfaceDim),
              ),
            ),
            child: SafeArea(
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _ctrl,
                      decoration: InputDecoration(
                        hintText: 'Ask about crops, diseases, or weather...',
                        hintStyle: AppTypography.bodySmall
                            .copyWith(color: AppColors.onSurfaceMuted),
                        filled: true,
                        fillColor: AppColors.surfaceContainerHigh,
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: AppSpacing.lg,
                            vertical: AppSpacing.md),
                        border: OutlineInputBorder(
                          borderRadius:
                              BorderRadius.circular(AppSpacing.radiusFull),
                          borderSide: BorderSide.none,
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius:
                              BorderRadius.circular(AppSpacing.radiusFull),
                          borderSide: BorderSide.none,
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius:
                              BorderRadius.circular(AppSpacing.radiusFull),
                          borderSide: const BorderSide(
                              color: AppColors.primary, width: 1.5),
                        ),
                      ),
                      minLines: 1,
                      maxLines: 4,
                      textInputAction: TextInputAction.send,
                      onSubmitted: (_) => _handleSend(),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  Material(
                    color: _loading
                        ? AppColors.surfaceDim
                        : AppColors.primary,
                    shape: const CircleBorder(),
                    elevation: _loading ? 0 : 2,
                    shadowColor: AppColors.primary.withValues(alpha: 0.3),
                    child: InkWell(
                      customBorder: const CircleBorder(),
                      onTap: _loading ? null : _handleSend,
                      child: const Padding(
                        padding: EdgeInsets.all(12),
                        child:
                            Icon(Icons.send, color: Colors.white, size: 20),
                      ),
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
