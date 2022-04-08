import 'package:flutter/material.dart';
import 'package:skoomin/src/base/data.dart';
import 'package:skoomin/src/base/nav.dart';
import 'package:skoomin/src/services/student_registration_services.dart';
import 'package:skoomin/src/ui/modals/dialog.dart';
import 'package:skoomin/src/ui/pages/change_notification_password_page.dart';
import 'package:skoomin/src/ui/pages/change_principal_password_page.dart';
import 'package:skoomin/src/ui/pages/change_school_code_page.dart';
import 'package:skoomin/src/ui/pages/change_student_password_page.dart';
import 'package:skoomin/src/ui/pages/welcome_page.dart';
import 'package:skoomin/src/ui/widgets/auth_button.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final user = AppData().getUser();

  @override
  Widget build(BuildContext context) {
    return Material(
      child: SafeArea(
        child: ListView(
          children: [
            const Center(
              child: Text(
                "Settings",
                style: TextStyle(fontSize: 25),
              ),
              heightFactor: 2.5,
            ),
            _getListTile(
              title: "Change Login Password",
              leading: Icons.vpn_key,
              onTap: () {
                (!user.isStudent!)
                    ? AppNavigation.to(
                        context, const ChangePrincipalPasswordPage())
                    : AppNavigation.to(
                        context, const ChangeStudentPasswordPage());
              },
            ),
            (user.isStudent!)
                ? _getListTile(
                    title: "Delete your account",
                    leading: Icons.delete,
                    onTap: () {
                      debugPrint('Delete Dialog - ${user.isStudent}');
                      getDialogModal(
                        context: context,
                        child: AlertDialog(
                          title: const Text("Warning"),
                          content: const Text(
                            'Are you sure you wants to delete your account?',
                          ),
                          actions: [
                            TextButtonWidget(
                              onPressed: () async {
                                AppNavigation.pop(context);
                                getLoadingDialog(
                                  context: context,
                                  loadingMessage: 'Deleting',
                                );
                                await StudentRegistrationServices()
                                    .deleteFirestore(user.personId);
                                user.isStudent = user.isSignedIn = false;
                                AppData().clearHive();
                                AppNavigation.navigateRemoveUntil(
                                    context, const WelcomePage());
                              },
                              child: const Text(
                                'Yes',
                                style: TextStyle(color: Colors.red),
                              ),
                            ),
                            TextButtonWidget(
                              onPressed: () => AppNavigation.pop(context),
                              child: const Text(
                                'No',
                              ),
                            )
                          ],
                        ),
                      );
                    },
                  )
                : Container(),
            (!user.isStudent!)
                ? _getListTile(
                    title: "Change Notification Password",
                    leading: Icons.vpn_key,
                    onTap: () => AppNavigation.to(
                        context, const ChangeNotificationPasswordPage()),
                  )
                : Container(),
            (!user.isStudent!)
                ? _getListTile(
                    title: "Change School Code",
                    leading: Icons.vpn_key,
                    onTap: () =>
                        AppNavigation.to(context, const ChangeSchoolCodePage()),
                  )
                : Container(),
          ],
        ),
      ),
    );
  }

  Widget _getListTile({
    required String title,
    required IconData leading,
    required Function() onTap,
  }) =>
      ListTile(
        title: Text(title),
        leading: Icon(leading),
        onTap: onTap,
      );
}
