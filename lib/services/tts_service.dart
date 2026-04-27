import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'api_service.dart';

class TtsService extends ChangeNotifier {
  final FlutterTts _flutterTts = FlutterTts();
  final ApiService _apiService = ApiService();
  bool _isSpeaking = false;
  
  bool get isSpeaking => _isSpeaking;

  final _speakingController = StreamController<bool>.broadcast();
  Stream<bool> get speakingStream => _speakingController.stream;

  Future<void> initialize() async {
    await _flutterTts.setVolume(1.0);
    await _flutterTts.setPitch(1.15);
    await _flutterTts.setSpeechRate(0.42);
    // Note: 'en' is a safer default than 'en-US' for some platforms
    await _flutterTts.setLanguage('en-US');

    _flutterTts.setStartHandler(() {
      _isSpeaking = true;
      _speakingController.add(true);
      notifyListeners();
    });

    _flutterTts.setCompletionHandler(() {
      _isSpeaking = false;
      _speakingController.add(false);
      notifyListeners();
    });

    _flutterTts.setErrorHandler((msg) {
      _isSpeaking = false;
      _speakingController.add(false);
      notifyListeners();
    });
  }

  Future<void> speak(String text, {String language = 'en'}) async {
    String textToSpeak = text;
    
    if (language == 'hi' || language == 'bn') {
      textToSpeak = await _apiService.translateText(text, language == 'hi' ? 'Hindi' : 'Bengali');
      await _flutterTts.setPitch(1.2);
      await _flutterTts.setSpeechRate(0.42);
      await _flutterTts.setLanguage(language == 'hi' ? 'hi-IN' : 'bn-IN');
    } else {
      await _flutterTts.setPitch(1.15);
      await _flutterTts.setSpeechRate(0.42);
      await _flutterTts.setLanguage('en-US');
    }

    List<String> sentences = textToSpeak.split(RegExp(r'(?<=[.!?])\s+'));
    List<String> filteredSentences = [];
    for (var s in sentences) {
      if (filteredSentences.isEmpty || s != filteredSentences.last) {
        filteredSentences.add(s);
      }
    }

    for (var sentence in filteredSentences) {
      if (sentence.trim().isEmpty) continue;
      await _flutterTts.speak(sentence);
    }
  }

  Future<void> stop() async {
    await _flutterTts.stop();
    _isSpeaking = false;
    _speakingController.add(false);
    notifyListeners();
  }
}
