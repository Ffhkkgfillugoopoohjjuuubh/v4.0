import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import '../models/chat_session.dart';
import '../models/project_model.dart';

class StorageService {
  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  Future<List<ChatSession>> loadAllSessions() async {
    final path = await _localPath;
    final dir = Directory(path);
    final List<ChatSession> sessions = [];
    
    final files = dir.listSync().where((f) => f.path.contains('session_') && f.path.endsWith('.json'));
    for (var file in files) {
      if (file is File) {
        final content = await file.readAsString();
        sessions.add(ChatSession.fromJson(jsonDecode(content)));
      }
    }
    return sessions;
  }

  Future<void> saveSession(ChatSession session) async {
    final path = await _localPath;
    final file = File('$path/session_${session.id}.json');
    await file.writeAsString(jsonEncode(session.toJson()));
  }

  Future<void> deleteSession(String sessionId) async {
    final path = await _localPath;
    final file = File('$path/session_$sessionId.json');
    if (await file.exists()) {
      await file.delete();
    }
  }

  Future<void> clearAllSessions() async {
    final path = await _localPath;
    final dir = Directory(path);
    final files = dir.listSync().where((f) => f.path.contains('session_') && f.path.endsWith('.json'));
    for (var file in files) {
      if (file is File) {
        await file.delete();
      }
    }
  }

  Future<List<ProjectModel>> loadProjects() async {
    final path = await _localPath;
    final file = File('$path/projects.json');
    if (!await file.exists()) return [];
    
    final content = await file.readAsString();
    final List list = jsonDecode(content);
    return list.map((p) => ProjectModel.fromJson(p)).toList();
  }

  Future<void> saveProject(ProjectModel project) async {
    final projects = await loadProjects();
    final index = projects.indexWhere((p) => p.id == project.id);
    if (index != -1) {
      projects[index] = project;
    } else {
      projects.add(project);
    }
    final path = await _localPath;
    final file = File('$path/projects.json');
    await file.writeAsString(jsonEncode(projects.map((p) => p.toJson()).toList()));
  }

  Future<void> deleteProject(String projectId) async {
    final projects = await loadProjects();
    projects.removeWhere((p) => p.id == projectId);
    final path = await _localPath;
    final file = File('$path/projects.json');
    await file.writeAsString(jsonEncode(projects.map((p) => p.toJson()).toList()));
  }
}
