import 'package:portfolio/models/models.dart';
import 'package:portfolio/services/services.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'dashboard.state.g.dart';

@riverpod
class Dashboards extends _$Dashboards {
  @override
  Stream<Dashboard> build() {
    return ref.read(dashboardServiceProvider).stream;
  }

  Future<void> updateDashboard(Dashboard dashboard) async {
    ref.read(dashboardServiceProvider).update(dashboard);
  }
}
