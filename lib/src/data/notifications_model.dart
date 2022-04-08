import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:skoomin/src/data/_model.dart';

part 'notifications_model.g.dart';

Timestamp timestampFromJson(dynamic value) {
  return value;
}

dynamic timestampToJson(dynamic value) => value;

@JsonSerializable()
class NotificationsModel extends Model {
  final String? title;
  final String? body;
  @JsonKey(toJson: timestampToJson, fromJson: timestampFromJson)
  final Timestamp? timestamp;
  final String? schoolId;

  NotificationsModel({
    this.schoolId,
    this.timestamp,
    this.title,
    this.body,
  });

  factory NotificationsModel.fromJson(Map<String, dynamic> json) =>
      _$NotificationsModelFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$NotificationsModelToJson(this);
}
