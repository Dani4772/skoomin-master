import 'package:json_annotation/json_annotation.dart';
import 'package:skoomin/src/data/_model.dart';

part 'principal_model.g.dart';

@JsonSerializable()
class PrincipalModel extends Model {
  String? devToken;
  final String? email;
  final String? name;
  String? notificationPassword;
  String? password;
  final String? phone;
  final String? schoolId;
  final String? userName;

  final bool? isActive;
  final bool? isHead;

  PrincipalModel({
    this.devToken,
    this.isActive,
    this.isHead,
    this.name,
    this.notificationPassword,
    this.phone,
    this.email,
    this.userName,
    this.password,
    this.schoolId,
  });

  factory PrincipalModel.fromJson(Map<String, dynamic> json) =>
      _$PrincipalModelFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$PrincipalModelToJson(this);
}
