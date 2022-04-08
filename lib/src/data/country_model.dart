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
}
