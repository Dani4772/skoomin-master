import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:json_annotation/json_annotation.dart';

part 'contract_model.g.dart';

Timestamp timestampFromJson(dynamic value) {
  return value;
}

dynamic timestampToJson(dynamic value) => value;

@JsonSerializable()
class ContractModel {
  @JsonKey(toJson: timestampToJson, fromJson: timestampFromJson)
  final Timestamp startDate;
  @JsonKey(toJson: timestampToJson, fromJson: timestampFromJson)
  final Timestamp endDate;
  final int amount;

  ContractModel({
    required this.startDate,
    required this.endDate,
    required this.amount,
  });

  factory ContractModel.fromJson(Map<String, dynamic> json) =>
      _$ContractModelFromJson(json);

  Map<String, dynamic> toJson() => _$ContractModelToJson(this);
}
