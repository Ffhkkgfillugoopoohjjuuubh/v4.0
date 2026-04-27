import 'dart:async';

class RevenueOptimizer {
  Timer? _wordTimer;
  int _displayInterval = 100;
  final _wordController = StreamController<String>.broadcast();
  final _adRefreshController = StreamController<bool>.broadcast();
  
  List<String> _currentWords = [];
  int _currentIndex = 0;
  bool _isPaused = false;
  DateTime? _sessionStartTime;

  Stream<String> get wordStream => _wordController.stream;
  Stream<bool> get adRefreshSignal => _adRefreshController.stream;

  void startSession(int wordCount) {
    _displayInterval = (30000 ~/ (wordCount > 0 ? wordCount : 1)).clamp(30, 180);
    _sessionStartTime = DateTime.now();
  }

  Stream<String> streamWords(String fullText) {
    _wordTimer?.cancel();
    _currentWords = fullText.split(' ');
    _currentIndex = 0;
    _isPaused = false;

    _wordTimer = Timer.periodic(Duration(milliseconds: _displayInterval), (timer) {
      if (_isPaused) return;

      if (_currentIndex < _currentWords.length) {
        _wordController.add(_currentWords[_currentIndex]);
        _currentIndex++;
      } else {
        timer.cancel();
        _checkAdRefresh();
      }
    });

    return wordStream;
  }

  void pauseTimer() {
    _isPaused = true;
  }

  void resumeTimer() {
    _isPaused = false;
  }

  void _checkAdRefresh() {
    if (_sessionStartTime != null) {
      final elapsed = DateTime.now().difference(_sessionStartTime!).inSeconds;
      if (elapsed >= 30) {
        _adRefreshController.add(true);
      }
    }
  }

  void dispose() {
    _wordTimer?.cancel();
    // Do not close broadcast controllers if they are needed again, 
    // but for singleton service it's fine.
  }
}
