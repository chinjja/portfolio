import 'package:portfolio/models/models.dart';
import 'package:portfolio/services/services.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'project.state.g.dart';

@riverpod
class GetProject extends _$GetProject {
  @override
  Stream<Project?> build(String id) {
    return ref.read(projectServiceProvider).get(id);
  }
}

@riverpod
class GetProjects extends _$GetProjects {
  @override
  Stream<List<Project>> build() {
    return ref.read(projectServiceProvider).stream;
  }
}

@riverpod
class SubmitProject extends _$SubmitProject {
  @override
  FutureOr<Project?> build(Project? initialValue) {
    return null;
  }

  Future<void> submit(Project project) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      if (initialValue == null) {
        return await ref.read(projectServiceProvider).add(project);
      } else {
        return await ref
            .read(projectServiceProvider)
            .update(project.copyWith(id: initialValue!.id));
      }
    });
  }
}

@riverpod
class DeleteProject extends _$DeleteProject {
  @override
  FutureOr<Project?> build(Project project) {
    return null;
  }

  Future<void> delete() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      ref.read(projectServiceProvider).delete(project);
      return project;
    });
  }
}
