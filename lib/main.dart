import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:skoomin/src/app.dart';
import 'package:skoomin/src/base/data.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await AppData.initialize();
  runApp(const MyApp());
}
