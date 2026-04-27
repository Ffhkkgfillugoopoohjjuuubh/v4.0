import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/chat_provider.dart';
import 'chat_screen.dart';
import 'news_screen.dart';
import '../widgets/session_drawer.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  int _currentIndex = 0;
  String? _activeSessionId;

  void _onNewChat() {
    final session = ref.read(chatProvider.notifier).createSession();
    setState(() {
      _activeSessionId = session.id;
      _currentIndex = 0;
    });
  }

  void _onSessionTap(String id) {
    setState(() {
      _activeSessionId = id;
      _currentIndex = 0;
    });
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: SessionDrawer(
        onSessionTap: _onSessionTap,
        onNewChat: _onNewChat,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.chat), label: 'Chat'),
          BottomNavigationBarItem(icon: Icon(Icons.newspaper), label: 'News'),
        ],
      ),
      body: _currentIndex == 0 
        ? (_activeSessionId == null ? _buildHomeContent() : ChatScreen(sessionId: _activeSessionId!))
        : const NewsScreen(),
      floatingActionButton: _currentIndex == 0 ? FloatingActionButton(
        onPressed: _onNewChat,
        child: const Icon(Icons.add),
      ) : null,
    );
  }

  Widget _buildHomeContent() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text("Hello! I'm Echo AI", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          const Text("Your AI Tutor", style: TextStyle(color: Colors.grey)),
          const SizedBox(height: 20),
          Wrap(
            spacing: 8,
            children: [
              _chip("Explain photosynthesis"),
              _chip("Help with math"),
              _chip("Quiz me on history"),
              _chip("Explain a concept"),
            ],
          )
        ],
      ),
    );
  }

  Widget _chip(String label) {
    return ActionChip(
      label: Text(label),
      onPressed: () {
        final session = ref.read(chatProvider.notifier).createSession();
        setState(() => _activeSessionId = session.id);
      },
    );
  }
}
