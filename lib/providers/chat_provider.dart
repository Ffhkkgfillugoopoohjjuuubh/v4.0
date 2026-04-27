import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import '../models/chat_message.dart';
import '../models/chat_session.dart';
import '../services/storage_service.dart';

final storageServiceProvider = Provider((ref) => StorageService());

final chatProvider = StateNotifierProvider<ChatNotifier, List<ChatSession>>((ref) {
  return ChatNotifier(ref.watch(storageServiceProvider));
});

class ChatNotifier extends StateNotifier<List<ChatSession>> {
  final StorageService _storageService;
  final Uuid _uuid = const Uuid();

  ChatNotifier(this._storageService) : super([]) {
    _loadSessions();
  }

  Future<void> _loadSessions() async {
    state = await _storageService.loadAllSessions();
  }

  ChatSession createSession({String? projectId}) {
    final session = ChatSession(
      id: _uuid.v4(),
      name: 'New Chat',
      messages: [],
      projectId: projectId,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
    state = [session, ...state];
    _storageService.saveSession(session);
    return session;
  }

  Future<void> addMessage(String sessionId, ChatMessage message) async {
    final index = state.indexWhere((s) => s.id == sessionId);
    if (index != -1) {
      var session = state[index];
      var messages = [...session.messages, message];
      
      String newName = session.name;
      if (session.messages.isEmpty && message.role == 'user') {
        newName = message.content.length > 30 ? message.content.substring(0, 30) : message.content;
      }

      session = session.copyWith(
        name: newName,
        messages: messages,
        updatedAt: DateTime.now(),
      );

      state = [
        for (var s in state)
          if (s.id == sessionId) session else s
      ];
      await _storageService.saveSession(session);
    }
  }

  Future<void> renameSession(String sessionId, String newName) async {
    final index = state.indexWhere((s) => s.id == sessionId);
    if (index != -1) {
      final session = state[index].copyWith(name: newName, updatedAt: DateTime.now());
      state = [
        for (var s in state)
          if (s.id == sessionId) session else s
      ];
      await _storageService.saveSession(session);
    }
  }

  Future<void> toggleStar(String sessionId) async {
    final index = state.indexWhere((s) => s.id == sessionId);
    if (index != -1) {
      final session = state[index].copyWith(isStarred: !state[index].isStarred, updatedAt: DateTime.now());
      state = [
        for (var s in state)
          if (s.id == sessionId) session else s
      ];
      await _storageService.saveSession(session);
    }
  }

  Future<void> deleteSession(String sessionId) async {
    state = state.where((s) => s.id != sessionId).toList();
    await _storageService.deleteSession(sessionId);
  }

  Future<void> clearAll() async {
    state = [];
    await _storageService.clearAllSessions();
  }
}
