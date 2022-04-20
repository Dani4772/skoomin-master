import 'package:json_annotation/json_annotation.dart';
import 'package:skoomin/src/data/_model.dart';

part 'states_model.g.dart';

@JsonSerializable()
class StatesModel extends Model {
  final String name;
  final String countryId;

  StatesModel({
    required this.name,
    required this.countryId,
  });

  factory StatesModel.fromJson(Map<String, dynamic> json) =>
      _$StatesModelFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$StatesModelToJson(this);

  @override
  bool operator ==(Object other) {
    if (other is StatesModel) {
      return other.id == id;
    }
    return false;
  }

  @override
  String toString() => name;

  @override
  int get hashCode => id.hashCode;
}
