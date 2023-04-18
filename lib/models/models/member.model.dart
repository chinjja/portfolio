import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:portfolio/models/models/common.dart';

part 'member.model.freezed.dart';
part 'member.model.g.dart';

@freezed
class Member with _$Member {
  const factory Member({
    @Default('') String uid,
    String? displayName,
    String? photoUrl,
    String? fcmToken,
  }) = _Member;

  factory Member.fromJson(Json json) => _$MemberFromJson(json);
}
