import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:portfolio/models/models/common.dart';

part 'project.model.freezed.dart';
part 'project.model.g.dart';

@freezed
class Project with _$Project {
  const factory Project({
    @Default('') String id,
    @Default('') String title,
    @Default('') String subtitle,
    @Default('') String body,
    @Default('') String summary,
  }) = _Project;

  factory Project.fromJson(Json json) => _$ProjectFromJson(json);
}

@freezed
class Feature with _$Feature {
  const factory Feature({
    required String title,
    required String description,
  }) = _Feature;

  factory Feature.fromJson(Json json) => _$FeatureFromJson(json);
}

@freezed
class Skill with _$Skill {
  const factory Skill({
    required String name,
  }) = _Skill;

  factory Skill.fromJson(Json json) => _$SkillFromJson(json);
}
