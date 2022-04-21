import 'package:json_annotation/json_annotation.dart';
import 'package:skoomin/src/data/_model.dart';

part 'country_model.g.dart';

@JsonSerializable()
class CountryModel extends Model {
  @JsonKey(name: 'country')
  final String name;

  CountryModel({required this.name});

  factory CountryModel.fromJson(Map<String, dynamic> json) =>
      _$CountryModelFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$CountryModelToJson(this);

  @override
  bool operator ==(Object other) {
    if (other is CountryModel) {
      return other.id == id;
    }
    return false;
  }

  @override
  String toString() => name;

  @override
  int get hashCode => id.hashCode;
}
