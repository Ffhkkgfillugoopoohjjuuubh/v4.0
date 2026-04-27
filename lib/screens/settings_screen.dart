import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/settings_provider.dart';
import '../providers/chat_provider.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(settingsProvider);
    final notifier = ref.read(settingsProvider.notifier);

    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: ListView(
        children: [
          ListTile(
            title: const Text('App Language'),
            trailing: DropdownButton<String>(
              value: settings.appLanguage,
              items: const [
                DropdownMenuItem(value: 'en', child: Text('English')),
                DropdownMenuItem(value: 'hi', child: Text('Hindi')),
                DropdownMenuItem(value: 'bn', child: Text('Bengali')),
              ],
              onChanged: (val) => notifier.updateAppLanguage(val!),
            ),
          ),
          const Divider(),
          const ListTile(title: Text('Voice Settings', style: TextStyle(fontWeight: FontWeight.bold))),
          ListTile(
            title: const Text('Voice Language'),
            trailing: DropdownButton<String>(
              value: settings.voiceLanguage,
              items: const [
                DropdownMenuItem(value: 'en', child: Text('English')),
                DropdownMenuItem(value: 'hi', child: Text('Hindi')),
                DropdownMenuItem(value: 'bn', child: Text('Bengali')),
              ],
              onChanged: (val) => notifier.updateVoiceLanguage(val!),
            ),
          ),
          const ListTile(title: Text('Volume')),
          Slider(
            value: settings.volume,
            onChanged: (val) => notifier.updateVolume(val),
          ),
          const Divider(),
          ListTile(
            title: const Text('Theme'),
            trailing: DropdownButton<ThemeMode>(
              value: settings.themeMode,
              items: const [
                DropdownMenuItem(value: ThemeMode.system, child: Text('System')),
                DropdownMenuItem(value: ThemeMode.light, child: Text('Light')),
                DropdownMenuItem(value: ThemeMode.dark, child: Text('Dark')),
              ],
              onChanged: (val) => notifier.updateThemeMode(val!),
            ),
          ),
          const Divider(),
          ListTile(
            title: const Text('Clear All Chats'),
            textColor: Colors.red,
            onTap: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Confirm Clear'),
                  content: const Text('Delete all chat history?'),
                  actions: [
                    TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
                    TextButton(onPressed: () {
                      ref.read(chatProvider.notifier).clearAll();
                      Navigator.pop(context);
                    }, child: const Text('Clear', style: TextStyle(color: Colors.red))),
                  ],
                ),
              );
            },
          ),
          const ListTile(
            title: Text('App Version'),
            subtitle: Text('Echo AI v2.0'),
          ),
        ],
      ),
    );
  }
}
