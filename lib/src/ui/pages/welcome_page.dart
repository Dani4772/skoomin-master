import 'dart:io';

import 'package:flutter/material.dart';
import 'package:skoomin/src/base/assets.dart';
import 'package:skoomin/src/base/nav.dart';
import 'package:skoomin/src/data/notifier.dart';
import 'package:skoomin/src/ui/views/school_selection_view.dart';
import 'package:skoomin/src/ui/views/sign_in_view.dart';
import 'package:skoomin/src/ui/widgets/auth_button.dart';
import 'package:skoomin/src/ui/widgets/cross_fade_navigator.dart';
import 'package:skoomin/src/ui/modals/dialog.dart' as prefix0;

class WelcomePage extends StatefulWidget {
  const WelcomePage({Key? key}) : super(key: key);

  @override
  createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final Notifier _notifier = Notifier();
  final radius40 = const Radius.circular(40);
  final radius0 = const Radius.circular(0);

  @override
  Widget build(context) {
    return WillPopScope(
      onWillPop: () async => prefix0.getDialog(
        context: context,
        title: 'Are you sure?',
        actions: [
          TextButtonWidget(
            title: 'Cancel',
            onPressed: () => AppNavigation.pop(context),
          ),
          TextButtonWidget(
            title: 'Ok',
            onPressed: () => exit(0),
          ),
        ],
      ),
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        key: _scaffoldKey,
        backgroundColor: Colors.white,
        body: SafeArea(
          top: true,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 15),
                child: Image.asset(
                  Assets.skoominLogo,
                  width: 100,
                  height: 100,
                ),
              ),
              const Center(
                child: Text(
                  "Empowering Students to Speak-up",
                  style: TextStyle(
                    fontFamily: "Trajan Pro",
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 30),
                child: CrossFadeNavigator(
                  fontSize: 15,
                  backgroundColor: const Color(0xff77a500),
                  foregroundColor: Colors.white,
                  firstTitle: "Sign in",
                  secondTitle: "Sign up",
                  fontFamily: 'Quicksand',
                  firstChild: SignInView(
                    scaffoldKey: _scaffoldKey,
                  ),
                  secondChild: SchoolSelectionView(notifier: _notifier),
                  index: 1,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
