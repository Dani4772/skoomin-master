import 'package:hive/hive.dart';

part 'meta_model.g.dart';

@HiveType(typeId: 0)
class Meta extends HiveObject {
  @HiveField(0)
  bool? isStudent;
  @HiveField(1)
  bool isSignedIn;
  @HiveField(2)
  String schoolId;
  @HiveField(3)
  String personId;

  Meta({
    this.isStudent,
    required this.schoolId,
    required this.personId,
    required this.isSignedIn,
  });
}
