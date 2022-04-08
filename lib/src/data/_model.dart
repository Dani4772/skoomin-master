import 'package:json_annotation/json_annotation.dart';

abstract class Model {
  @JsonKey(ignore: true)
  String? id;

  Model({this.id});

  Map<String, dynamic> toJson();

  Model.fromJson(Map<String, dynamic> json);
}
