import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:portfolio/models/models/project.model.dart';
import 'package:portfolio/providers/providers.dart';

final projectServiceProvider = Provider((ref) => ProjectService(ref));

class ProjectService {
  static const prefix = 'projects';
  final Ref ref;

  ProjectService(this.ref);

  Stream<List<Project>> get stream {
    final firestore = ref.read(firebaseFirestoreProvider);
    return firestore
        .collection(prefix)
        .snapshots()
        .map((e) => e.docs.map((e) => Project.fromJson(e.data())).toList());
  }

  Stream<Project?> get(String id) {
    final firestore = ref.read(firebaseFirestoreProvider);
    return firestore
        .collection(prefix)
        .doc(id)
        .snapshots()
        .map((e) => e.exists ? Project.fromJson(e.data()!) : null);
  }

  Future<Project> add(Project project) async {
    final id = ref.read(uuidProvider).v4();
    project = project.copyWith(id: id);
    final firestore = ref.read(firebaseFirestoreProvider);
    await firestore.collection(prefix).doc(id).set(project.toJson());
    return project;
  }

  Future<Project> update(Project project) async {
    final firestore = ref.read(firebaseFirestoreProvider);
    await firestore.collection(prefix).doc(project.id).update(project.toJson());
    return project;
  }

  Future<void> delete(Project project) async {
    final firestore = ref.read(firebaseFirestoreProvider);
    await firestore.collection(prefix).doc(project.id).delete();
  }
}
