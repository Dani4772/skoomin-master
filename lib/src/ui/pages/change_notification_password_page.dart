import 'package:flutter/material.dart';
import 'package:skoomin/src/base/data.dart';
import 'package:skoomin/src/base/nav.dart';
import 'package:skoomin/src/base/themes.dart';
import 'package:skoomin/src/data/principal_model.dart';
import 'package:skoomin/src/services/connectivity_services.dart';
import 'package:skoomin/src/services/principal_services.dart';
import 'package:skoomin/src/ui/modals/dialog.dart' as prefix0;
import 'package:skoomin/src/ui/modals/snackbar.dart';
import 'package:skoomin/src/ui/widgets/app_text_field.dart';
import 'package:skoomin/src/ui/widgets/auth_button.dart';
import 'package:skoomin/src/utils/utils.dart';

class ChangeNotificationPasswordPage extends StatefulWidget {
  const ChangeNotificationPasswordPage({Key? key}) : super(key: key);

  @override
  _ChangeNotificationPasswordPageState createState() =>
      _ChangeNotificationPasswordPageState();
}

class _ChangeNotificationPasswordPageState
    extends State<ChangeNotificationPasswordPage> {
  final formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  late String oldNotificationPassword;
  final TextEditingController oldPasswordController = TextEditingController();
  final TextEditingController newPasswordController = TextEditingController();
  late PrincipalModel principalModel;
  bool _hasData = false;
  final user = AppData().getUser();

  Future<void> _getOldPassword() async {
    principalModel = await PrincipalServices().fetchOneFirestore(user.personId);
    oldNotificationPassword = principalModel.notificationPassword!;
    setState(() => _hasData = true);
  }

  @override
  void initState() {
    _getOldPassword();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Material(
        child: Scaffold(
          key: _scaffoldKey,
          body: !_hasData
              ? const Center(
                  child: CircularProgressIndicator(
                    color: AppTheme.primaryColor,
                  ),
                )
              : Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Form(
                    key: formKey,
                    child: Column(
                      children: <Widget>[
                        const Center(
                          child: Text(
                            "Change Notification Password",
                            style: TextStyle(fontSize: 25),
                          ),
                          heightFactor: 2.5,
                        ),
                        AppPasswordField(
                          textEditingController: oldPasswordController,
                          label: 'Old Password',
                          prefixIcon: Icons.lock,
                          validator: (value) => oldPasswordValidator(
                            value,
                            oldNotificationPassword,
                          ),
                        ),
                        AppPasswordField(
                          textEditingController: newPasswordController,
                          label: 'New Password',
                          prefixIcon: Icons.lock,
                          validator: (value) => newPasswordValidator(
                            value,
                            oldNotificationPassword,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 40.0),
                          child: AuthButton(
                            height: 45,
                            text: 'Change Notification Password',
                            onTap: () async {
                              if (!await ConnectivityServices()
                                  .getNetworkStatus()) {
                                prefix0.showConnectionErrorDialog(context);
                                return;
                              }
                              if (formKey.currentState!.validate()) {
                                FocusScope.of(context).unfocus();
                                principalModel.notificationPassword =
                                    newPasswordController.text;
                                await PrincipalServices()
                                    .updateFirestore(principalModel);
                                displaySnackBar(context,
                                    "Notification Password Changed Successfully!");
                                Future.delayed(const Duration(seconds: 2),
                                    () => AppNavigation.pop(context));
                              }
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
        ),
      ),
    );
  }
}
