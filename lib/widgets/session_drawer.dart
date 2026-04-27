import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/chat_provider.dart';
import '../providers/projects_provider.dart';

class SessionDrawer extends ConsumerWidget {
  final Function(String) onSessionTap;
  final VoidCallback onNewChat;

  const SessionDrawer({
    super.key,
    required this.onSessionTap,
    required this.onNewChat,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final sessions = ref.watch(chatProvider);
    final projects = ref.watch(projectsProvider);
    
    final starredSessions = sessions.where((s) => s.isStarred).toList();
    final recentSessions = sessions.where((s) => !s.isStarred).toList();

    return Drawer(
      width: 280,
      child: Column(
        children: [
          DrawerHeader(
            child: Column(
              children: [
                Container(
                  width: 60,
                  height: 60,
                  decoration: const BoxDecoration(
                    color: Color(0xFF8B5CF6),
                    shape: BoxShape.circle,
                  ),
                  child: const Center(child: Text('E', style: TextStyle(color: Colors.white, fontSize: 30, fontWeight: FontWeight.bold))),
                ),
                const SizedBox(height: 10),
                const Text('Echo AI', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
                const Text('Your AI Tutor', style: TextStyle(fontSize: 12, color: Colors.grey)),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: OutlinedButton.icon(
              onPressed: onNewChat,
              icon: const Icon(Icons.add),
              label: const Text('New Chat'),
              style: OutlinedButton.styleFrom(
                foregroundColor: const Color(0xFF8B5CF6),
                side: const BorderSide(color: Color(0xFF8B5CF6)),
                minimumSize: const Size(double.infinity, 45),
              ),
            ),
          ),
          Expanded(
            child: ListView(
              children: [
                if (starredSessions.isNotEmpty)
                  ExpansionTile(
                    leading: const Icon(Icons.star, color: Colors.amber),
                    title: const Text('Starred'),
                    children: starredSessions.map((s) => ListTile(
                      title: Text(s.name),
                      onTap: () => onSessionTap(s.id),
                    )).toList(),
                  ),
                if (projects.isNotEmpty)
                  ExpansionTile(
                    leading: const Icon(Icons.folder, color: Colors.blue),
                    title: const Text('Projects'),
                    children: projects.map((p) => ExpansionTile(
                      title: Text(p.name),
                      children: sessions.where((s) => s.projectId == p.id).map((s) => ListTile(
                        title: Text(s.name),
                        onTap: () => onSessionTap(s.id),
                      )).toList(),
                    )).toList(),
                  ),
                const ListTile(
                  leading: Icon(Icons.access_time),
                  title: Text('Recents'),
                ),
                ...recentSessions.map((s) => ListTile(
                  title: Text(s.name),
                  onTap: () => onSessionTap(s.id),
                  onLongPress: () {
                    // Options: rename, star, delete
                  },
                )),
              ],
            ),
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.settings),
            title: const Text('Settings'),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, '/settings');
            },
          ),
        ],
      ),
    );
  }
}
