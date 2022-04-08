import 'package:hive_flutter/hive_flutter.dart';
import 'package:skoomin/src/data/meta_model.dart';
import 'package:skoomin/src/data/mixins/meta_mixin.dart';

class AppData with MetaMixin {
  static Future<void> initialize() async {
    await Hive.initFlutter();
    Hive.registerAdapter(MetaAdapter());
    await MetaMixin.init();
  }

  Future<void> clearData() async {
    await clearHive();
  }
}
