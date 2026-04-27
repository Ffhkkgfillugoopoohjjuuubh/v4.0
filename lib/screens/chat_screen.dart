import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import '../models/chat_message.dart';
import '../providers/chat_provider.dart';
//import '../providers/ad_provider.dart';
import '../services/api_service.dart';
import '../services/ocr_service.dart';
import '../services/revenue_optimizer.dart';
import '../services/tts_service.dart';
import '../widgets/message_bubble.dart';
import '../widgets/chat_input_widget.dart';
//import '../widgets/banner_ad_widget.dart';
import '../widgets/thinking_animation.dart';

class ChatScreen extends ConsumerStatefulWidget {
  final String sessionId;

  const ChatScreen({super.key, required this.sessionId});

  @override
  ConsumerState<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends ConsumerState<ChatScreen> {
  final ApiService _apiService = ApiService();
  final OcrService _ocrService = OcrService();
  final RevenueOptimizer _revenueOptimizer = RevenueOptimizer();
  final TtsService _ttsService = TtsService();
  bool _isThinking = false;
  String? _currentAiMessageId;

  @override
  void initState() {
    super.initState();
    _ttsService.initialize();
  }

  Future<void> _handleSend(String text, File? image) async {
    final chatNotifier = ref.read(chatProvider.notifier);
    String messageContent = text;

    setState(() => _isThinking = true);

    if (image != null) {
      final extractedText = await _ocrService.extractTextFromFile(image);
      messageContent = "The user has shared an image containing: $extractedText. Answer this: $text";
    }

    final userMessage = ChatMessage(
      id: const Uuid().v4(),
      role: 'user',
      content: messageContent,
      timestamp: DateTime.now(),
    );

    await chatNotifier.addMessage(widget.sessionId, userMessage);

    final sessions = ref.read(chatProvider);
    final session = sessions.firstWhere((s) => s.id == widget.sessionId);
    
    String aiResponse = await _apiService.sendMessage(session.messages);
    
    int wordCount = aiResponse.split(' ').length;
    if (wordCount < 80) {
      aiResponse = await _apiService.expandResponse(aiResponse);
      wordCount = aiResponse.split(' ').length;
    }

    _revenueOptimizer.startSession(wordCount);
    
    final aiMessageId = const Uuid().v4();
    final aiMessage = ChatMessage(
      id: aiMessageId,
      role: 'assistant',
      content: aiResponse,
      timestamp: DateTime.now(),
    );

    await chatNotifier.addMessage(widget.sessionId, aiMessage);
    
    setState(() {
      _isThinking = false;
      _currentAiMessageId = aiMessageId;
    });
    
    _revenueOptimizer.streamWords(aiResponse);
  }

  @override
  Widget build(BuildContext context) {
    final sessions = ref.watch(chatProvider);
    final session = sessions.firstWhere((s) => s.id == widget.sessionId);

    return Scaffold(
      appBar: AppBar(
        title: Text(session.name),
        actions: [
          IconButton(icon: const Icon(Icons.edit), onPressed: () {}),
          IconButton(
            icon: Icon(session.isStarred ? Icons.star : Icons.star_border),
            onPressed: () => ref.read(chatProvider.notifier).toggleStar(widget.sessionId),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: session.messages.length,
              itemBuilder: (context, index) {
                final msg = session.messages[index];
                return MessageBubble(
                  message: msg,
                  wordStream: msg.id == _currentAiMessageId ? _revenueOptimizer.wordStream : null,
                  onSpeak: () => _ttsService.speak(msg.content),
                  isSpeaking: _ttsService.isSpeaking,
                );
              },
            ),
          ),
          if (_isThinking) const ThinkingAnimation(),
          ChatInputWidget(
            onSend: _handleSend,
            onFocus: _revenueOptimizer.pauseTimer,
          ),
        ],
      ),
    );
  }
}
