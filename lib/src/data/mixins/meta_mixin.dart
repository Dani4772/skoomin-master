import 'package:hive/hive.dart';
import 'package:skoomin/src/data/meta_model.dart';

mixin MetaMixin {
  static late Box<Meta> _box;

  static Future<void> init() async {
    _box = await Hive.openBox<Meta>('meta_box');
  }

  Future<void> insertHive(Meta model) async {
    await _box.add(model);
    await model.save();
  }

  List<Meta> getAllHive() => _box.values.toList();

  Meta getUser() => _box.values.toList().first;

  Future<void> update(Meta model) async {
    await model.save();
  }

  Future<void> clearHive() async {
    await _box.clear();
  }

  bool isLogin() => _box.values.toList().isNotEmpty;
}
