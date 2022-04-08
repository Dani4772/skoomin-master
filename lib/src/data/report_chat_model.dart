import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:skoomin/src/data/_model.dart';

part 'report_chat_model.g.dart';

Timestamp timestampFromJson(dynamic value) {
  return value;
}

dynamic timestampToJson(dynamic value) => value;

@JsonSerializable()
class ReportChatModel extends Model {
  final String principleID;
  final String studentID;
  @JsonKey(fromJson: timestampFromJson, toJson: timestampToJson)
  final Timestamp dateTime;

  ReportChatModel({
    required this.dateTime,
    required this.studentID,
    required this.principleID,
  });

  factory ReportChatModel.fromJson(Map<String, dynamic> json) =>
      _$ReportChatModelFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$ReportChatModelToJson(this);
}
