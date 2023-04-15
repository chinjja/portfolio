import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:portfolio/models/models/common.dart';

part 'dashboard.model.freezed.dart';
part 'dashboard.model.g.dart';

@freezed
class Dashboard with _$Dashboard {
  const factory Dashboard({
    required String title,
    required String body,
  }) = _Dashboard;

  factory Dashboard.fromJson(Json json) => _$DashboardFromJson(json);
}
