import 'package:json_annotation/json_annotation.dart';
import 'package:skoomin/src/data/_model.dart';

part 'city_model.g.dart';

@JsonSerializable()
class CityModel extends Model {
  final String name;
  final String stateId;

  CityModel({required this.name, required this.stateId});

  factory CityModel.fromJson(Map<String, dynamic> json) =>
      _$CityModelFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$CityModelToJson(this);

  @override
  bool operator ==(Object other) {
    if (other is CityModel) {
      return other.id == id;
    }
    return false;
  }

  @override
  String toString() => name;

  @override
  int get hashCode => id.hashCode;
}
