import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:skoomin/src/data/_model.dart';

part 'chat_model.g.dart';

Timestamp timestampFromJson(dynamic value) {
  return value;
}

dynamic timestampToJson(dynamic value) => value;

@JsonSerializable()
class ChatModel extends Model {
  final String text;
  @JsonKey(toJson: timestampToJson, fromJson: timestampFromJson)
  final Timestamp? timeStamp;
  bool isReadByStudent;
  bool isReadByPrincipal;
  final String sentBy;

  ChatModel({
    required this.text,
    required this.sentBy,
    required this.timeStamp,
    required this.isReadByPrincipal,
    required this.isReadByStudent,
  });

  factory ChatModel.fromJson(Map<String, dynamic> json) =>
      _$ChatModelFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$ChatModelToJson(this);
}
