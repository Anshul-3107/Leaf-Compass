/// Represents a single chat message in the AgroBot chat.
/// Mirrors the message objects used in Chatpage.jsx and Chatbot.jsx.
class ChatMessage {
  final String sender; // 'user' or 'bot'
  final String text;
  final DateTime timestamp;

  ChatMessage({
    required this.sender,
    required this.text,
    DateTime? timestamp,
  }) : timestamp = timestamp ?? DateTime.now();

  bool get isUser => sender == 'user';
  bool get isBot => sender == 'bot';
}
