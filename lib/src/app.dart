import 'package:flutter/material.dart';
import 'package:skoomin/src/base/data.dart';
import 'package:skoomin/src/base/themes.dart';
import 'package:skoomin/src/ui/pages/home_page.dart';
import 'package:skoomin/src/ui/pages/welcome_page.dart';

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Skoomin',
      theme: AppTheme.lightTheme,
      home: AppData().isLogin() ? const HomePage() : const WelcomePage(),
    );
  }
}
