import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:portfolio/models/models.dart';
import 'package:portfolio/providers/providers.dart';

final dashboardServiceProvider = Provider((ref) => DashboardService(ref));

class DashboardService {
  final Ref ref;

  DashboardService(this.ref);

  Stream<Dashboard> get stream {
    final firestore = ref.read(firebaseFirestoreProvider);
    return firestore
        .collection('portfolio')
        .doc('dashboard')
        .snapshots()
        .map((e) => Dashboard.fromJson(e.data()!));
  }

  Future<Dashboard> update(Dashboard dashboard) async {
    final firestore = ref.read(firebaseFirestoreProvider);
    await firestore
        .collection('portfolio')
        .doc('dashboard')
        .set(dashboard.toJson());
    return dashboard;
  }
}
