import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:skoomin/src/base/data.dart';
import 'package:skoomin/src/base/nav.dart';
import 'package:skoomin/src/base/themes.dart';
import 'package:skoomin/src/services/principal_services.dart';
import 'package:skoomin/src/services/school_services.dart';
import 'package:skoomin/src/services/student_registration_services.dart';
import 'package:skoomin/src/ui/modals/dialog.dart' as prefix0;
import 'package:flutter/material.dart';
import 'package:skoomin/src/ui/pages/report_page.dart';
import 'package:skoomin/src/ui/pages/settings_page.dart';
import 'package:skoomin/src/ui/pages/welcome_page.dart';
import 'package:skoomin/src/ui/views/notifications_view.dart';
import 'package:skoomin/src/ui/views/reports_view.dart';
import 'package:skoomin/src/ui/views/resolved_reports_view.dart';
import 'dart:core';
import 'package:skoomin/src/ui/widgets/auth_button.dart';
import 'package:url_launcher/url_launcher.dart';

enum PageEnum {
  signOut,
  aboutUs,
  settings,
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  int badgeCounter = 1;
  double tabIconSize = 20;
  final FirebaseMessaging _fcm = FirebaseMessaging.instance;
  bool? schoolIsActive;
  bool? studentActiveStatus;
  late String notificationPassword;
  final notificationFormKey = GlobalKey<FormState>();
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  late TabController _controller;
  late Widget _fab;
  final user = AppData().getUser();

  @override
  void initState() {
    debugPrint('User ID --- ${user.personId}');
    if (user.isStudent!) {
      StudentRegistrationServices()
          .fetchOneStreamFirestore(user.personId)
          .listen((value) {
        studentActiveStatus = value.isActive;
        debugPrint('Stream build Successfully');
      });
    } else {
      PrincipalServices()
          .fetchOneStreamFirestore(user.personId)
          .listen((value) {
        notificationPassword = value.notificationPassword ?? '';
      });
    }

    SchoolServices().fetchOneStreamFirestore(user.schoolId).listen((e) {
      int contractLength = e.contracts.length;
      schoolIsActive = e.isActive;
      DateTime contractEndingDate =
          e.contracts[contractLength - 1].endDate.toDate();
      DateTime today = DateTime.now().toUtc();
      if (contractEndingDate.difference(today).inDays <= 0) {
        e.isActive = false;
        schoolIsActive = false;
      } else {
        e.isActive = true;
        schoolIsActive = true;
      }
      SchoolServices().updateFirestore(e);
    });
    if (!user.isStudent!) {
      /// Principal
      _fcm.getToken().then((token) async {
        final principal =
            await PrincipalServices().fetchOneFirestore(user.personId);
        principal.devToken = token;
        await PrincipalServices().updateFirestore(principal);
      });
    } else {
      /// Student
      _fcm.getToken().then((token) async {
        final student = await StudentRegistrationServices()
            .fetchOneFirestore(user.personId);
        student.devToken = token;
        await StudentRegistrationServices().updateFirestore(student);
      });
    }

    _fcm.requestPermission(
      alert: true,
      announcement: true,
      badge: true,
      sound: true,
    );

    FirebaseMessaging.onMessage.listen((event) {
      debugPrint('Notification Payload onMessage - ${event.data.toString()}');
      _getNotificationDialog(event);
    });

    FirebaseMessaging.onMessageOpenedApp.listen((event) {
      debugPrint('Notification Payload Opened - ${event.data.toString()}');
      _getNotificationDialog(event);
    });

    _controller = TabController(
      length: 3,
      vsync: this,
      initialIndex: 0,
    );

    _controller.addListener(() {
      if (mounted) {
        setState(() {});
      }
    });

    super.initState();
  }

  void _getNotificationDialog(RemoteMessage event) {
    prefix0.getDialogModal(
      context: context,
      child: AlertDialog(
        content: ListTile(
          title: Text(event.data['sendername'] ?? ''),
          subtitle: Text(event.data['message'] ?? ''),
        ),
        actions: <Widget>[
          TextButtonWidget(
            title: 'Ok',
            onPressed: () => AppNavigation.pop(context),
          )
        ],
      ),
    );
  }

  _onSelect(PageEnum value) {
    switch (value) {
      case PageEnum.signOut:
        user.isStudent = user.isSignedIn = false;
        AppData().clearHive();
        AppNavigation.navigateRemoveUntil(context, const WelcomePage());
        break;
      case PageEnum.aboutUs:
        launchUrl();
        break;
      case PageEnum.settings:
        AppNavigation.to(context, const SettingsPage());
        break;
    }
  }

  Widget _getTab({required String label, required IconData icon}) => Tab(
        child: Text(
          label,
          style: const TextStyle(
            fontFamily: 'Roboto',
            fontWeight: FontWeight.w500,
          ),
        ),
        icon: Icon(
          icon,
          color: Colors.white,
        ),
      );

  PopupMenuItem<PageEnum> _getPopUpMenuItem<PageEnum>({
    required IconData icon,
    required String title,
    required PageEnum pageEnum,
  }) =>
      PopupMenuItem<PageEnum>(
        value: pageEnum,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            Icon(icon),
            Text(title),
          ],
        ),
      );

  @override
  Widget build(context) {
    _handle();

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
        appBar: AppBar(
          backgroundColor: AppTheme.primaryColor,
          title: const Text(
            "Skoomin Reporting System",
            style: TextStyle(fontSize: 18, color: Colors.white),
          ),
          automaticallyImplyLeading: false,
          actions: [
            notificationButton(),
            PopupMenuButton<PageEnum>(
              offset: const Offset(0, 40),
              onSelected: _onSelect,
              icon: const Icon(Icons.more_vert, color: Colors.white),
              itemBuilder: (context) => [
                _getPopUpMenuItem(
                  icon: Icons.exit_to_app,
                  title: 'Sign out',
                  pageEnum: PageEnum.signOut,
                ),
                _getPopUpMenuItem(
                  icon: Icons.settings,
                  title: 'Settings',
                  pageEnum: PageEnum.settings,
                ),
                _getPopUpMenuItem(
                  icon: Icons.info,
                  title: 'About us',
                  pageEnum: PageEnum.aboutUs,
                ),
              ],
            ),
          ],
          bottom: TabBar(
            indicatorColor: AppTheme.primaryColor,
            labelStyle: const TextStyle(
              fontFamily: 'Roboto',
              fontWeight: FontWeight.w500,
            ),
            controller: _controller,
            tabs: [
              _getTab(label: 'Reports', icon: Icons.assignment),
              _getTab(label: 'Resolved', icon: Icons.assignment_turned_in),
              _getTab(label: 'Notifications', icon: Icons.notifications),
            ],
          ),
        ),
        body: TabBarView(
          controller: _controller,
          children: [
            ReportsView(schoolIsActive: schoolIsActive),
            ResolvedReportsView(
              schoolIsActive: schoolIsActive,
            ),
            const NotificationsView(),
          ],
        ),
        floatingActionButton: _fab,
      ),
    );
  }

  _handle() {
    _fab = _controller.index == 0 && user.isStudent!
        ? FloatingActionButton(
            child: const Icon(Icons.add),
            backgroundColor: Theme.of(context).primaryColor,
            foregroundColor: Colors.white,
            onPressed: () {
              if (schoolIsActive == null ||
                  schoolIsActive! && studentActiveStatus!) {
                AppNavigation.to(context, const ReportPage());
              } else {
                (schoolIsActive == null)
                    ? Container()
                    : (!schoolIsActive!
                        ? prefix0.getDialogModal(
                            context: context,
                            child: AlertDialog(
                              title: Row(children: const [
                                Padding(
                                  padding: EdgeInsets.only(right: 20.0),
                                  child: Icon(
                                    Icons.block,
                                    color: Colors.red,
                                  ),
                                ),
                                Expanded(
                                  child: Text(
                                    'Reporting Is Temporarily Disabled!',
                                    softWrap: true,
                                    style: TextStyle(
                                        fontSize: 15, color: Colors.red),
                                  ),
                                ),
                              ]),
                              content: const Text(
                                "Please contact your institution administrator for further details.",
                                softWrap: true,
                                textAlign: TextAlign.justify,
                              ),
                              actions: [
                                TextButtonWidget(
                                  title: "Ok",
                                  onPressed: () => AppNavigation.pop(context),
                                ),
                              ],
                            ),
                          )
                        : prefix0.showBlockedDialog(context));
              }
            },
          )
        : Container();
  }

  Widget notificationButton() => (!user.isStudent!)
      ? IconButton(
          icon: const Icon(
            Icons.add_alert,
            color: Colors.white,
          ),
          onPressed: () => (schoolIsActive == null)
              ? Container()
              : (schoolIsActive!
                  ? prefix0.showCustomNotificationDialog(
                      context,
                      notificationFormKey,
                      titleController,
                      descriptionController,
                      passwordController,
                      notificationPassword)
                  : prefix0.showContractEndedDialog(context)))
      : const SizedBox(
          width: 0,
          height: 0,
        );
}

var url = "https://www.reportbullying.com";

launchUrl() async {
  if (await canLaunch(url)) {
    await launch(url);
  } else {
    throw 'Could not launch $url';
  }
}
