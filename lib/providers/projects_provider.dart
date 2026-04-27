import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import '../models/project_model.dart';
import 'chat_provider.dart';

final projectsProvider = StateNotifierProvider<ProjectsNotifier, List<ProjectModel>>((ref) {
  return ProjectsNotifier(ref.watch(storageServiceProvider));
});

class ProjectsNotifier extends StateNotifier<List<ProjectModel>> {
  final _storageService;
  final Uuid _uuid = const Uuid();

  ProjectsNotifier(this._storageService) : super([]) {
    _loadProjects();
  }

  Future<void> _loadProjects() async {
    state = await _storageService.loadProjects();
  }

  Future<void> createProject(String name) async {
    final project = ProjectModel(
      id: _uuid.v4(),
      name: name,
      createdAt: DateTime.now(),
    );
    state = [...state, project];
    await _storageService.saveProject(project);
  }

  Future<void> renameProject(String id, String name) async {
    final index = state.indexWhere((p) => p.id == id);
    if (index != -1) {
      final project = ProjectModel(id: id, name: name, createdAt: state[index].createdAt);
      state = [
        for (var p in state)
          if (p.id == id) project else p
      ];
      await _storageService.saveProject(project);
    }
  }

  Future<void> deleteProject(String id) async {
    state = state.where((p) => p.id != id).toList();
    await _storageService.deleteProject(id);
  }
}
