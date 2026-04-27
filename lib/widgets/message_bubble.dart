import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import '../models/chat_message.dart';

class MessageBubble extends StatefulWidget {
  final ChatMessage message;
  final Stream<String>? wordStream;
  final VoidCallback? onSpeak;
  final bool isSpeaking;
  final bool isPreparing;

  const MessageBubble({
    super.key,
    required this.message,
    this.wordStream,
    this.onSpeak,
    this.isSpeaking = false,
    this.isPreparing = false,
  });

  @override
  State<MessageBubble> createState() => _MessageBubbleState();
}

class _MessageBubbleState extends State<MessageBubble> {
  String _displayedContent = '';

  @override
  void initState() {
    super.initState();
    if (widget.wordStream != null) {
      widget.wordStream!.listen((word) {
        if (mounted) {
          setState(() {
            _displayedContent += ' $word';
          });
        }
      });
    } else {
      _displayedContent = widget.message.content;
    }
  }

  @override
  Widget build(BuildContext context) {
    final isUser = widget.message.role == 'user';
    final theme = Theme.of(context);

    return Align(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Column(
        crossAxisAlignment: isUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          Container(
            margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: isUser ? const Color(0xFF8B5CF6) : theme.cardColor,
              borderRadius: BorderRadius.only(
                topLeft: const Radius.circular(18),
                topRight: const Radius.circular(18),
                bottomLeft: Radius.circular(isUser ? 18 : 4),
                bottomRight: Radius.circular(isUser ? 4 : 18),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _displayedContent.trim(),
                  style: TextStyle(
                    color: isUser ? Colors.white : theme.textTheme.bodyLarge?.color,
                  ),
                ),
                if (!isUser) ...[
                  const SizedBox(height: 8),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.copy, size: 18),
                        onPressed: () {
                          Clipboard.setData(ClipboardData(text: widget.message.content));
                        },
                      ),
                      IconButton(
                        icon: widget.isPreparing 
                          ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2))
                          : Icon(widget.isSpeaking ? Icons.stop : Icons.volume_up, size: 18),
                        onPressed: widget.onSpeak,
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Text(
              DateFormat('HH:mm').format(widget.message.timestamp),
              style: const TextStyle(fontSize: 10, color: Colors.grey),
            ),
          ),
        ],
      ),
    );
  }
}
