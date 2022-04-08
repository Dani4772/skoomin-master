import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:skoomin/src/data/_model.dart';

part 'report_model.g.dart';

Timestamp timestampFromJson(dynamic value) {
  return value;
}

dynamic timestampToJson(dynamic value) => value;

@JsonSerializable()
class ReportModel extends Model {
  bool? chatActivated;
  bool? followup;
  final List<String>? imageURL;
  final String? name; // Title
  String? reportChatId;
  final String? reportText; // Description
  final String? reportType;
  final String? schoolId;
  final String? studentId;
  @JsonKey(toJson: timestampToJson, fromJson: timestampFromJson)
  final Timestamp? timestamp;

  ReportModel({
    this.name,
    this.reportText,
    this.imageURL,
    this.timestamp,
    this.reportType,
    this.schoolId,
    this.studentId,
    this.chatActivated,
    this.followup,
    this.reportChatId,
  });

  factory ReportModel.fromJson(Map<String, dynamic> json) =>
      _$ReportModelFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$ReportModelToJson(this);
}
