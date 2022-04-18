
import 'package:json_annotation/json_annotation.dart';

import '_model.dart';

part 'followup_model.g.dart';

@JsonSerializable()
class FollowupModel extends Model {
  final String? comment;
  final List<String>? imageUrl;

  FollowupModel({this.comment, this.imageUrl});

  factory FollowupModel.fromJson(Map<String, dynamic> json) =>
      _$FollowupModelFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$FollowupModelToJson(this);
}
