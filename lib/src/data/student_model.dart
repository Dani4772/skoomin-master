import 'package:json_annotation/json_annotation.dart';
import 'package:skoomin/src/data/_model.dart';

part 'student_model.g.dart';

@JsonSerializable()
class StudentModel extends Model {
  String? devToken;
  bool? isActive;
  final String? name;
  String? password;
  final String? rollNo;
  final String? schoolId;

  StudentModel({
    this.devToken,
    this.name,
    this.password,
    this.rollNo,
    this.schoolId,
    this.isActive,
  });

  factory StudentModel.fromJson(Map<String, dynamic> json) =>
      _$StudentModelFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$StudentModelToJson(this);
}
