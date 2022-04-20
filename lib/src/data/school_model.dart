import 'package:json_annotation/json_annotation.dart';
import 'package:skoomin/src/data/_model.dart';
import 'package:skoomin/src/data/contract_model.dart';

part 'school_model.g.dart';

@JsonSerializable(explicitToJson: true)
class SchoolModel extends Model {
  final String name;
  final String phone;
  final String email;
  final String schoolCode;
  String? secretCode;
  final List<ContractModel> contracts;
  final String cityId;
  bool? isActive;

  SchoolModel({
    required this.name,
    required this.email,
    required this.cityId,
    required this.contracts,
    required this.phone,
    required this.schoolCode,
    this.secretCode,
    this.isActive,
  });

  factory SchoolModel.fromJson(Map<String, dynamic> json) {
    return _$SchoolModelFromJson(json);
  }

  @override
  Map<String, dynamic> toJson() => _$SchoolModelToJson(this);
}
