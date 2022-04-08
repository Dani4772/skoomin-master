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

class ChangePrincipalPasswordPage extends StatefulWidget {
  const ChangePrincipalPasswordPage({Key? key}) : super(key: key);

  @override
  _ChangePrincipalPasswordPageState createState() =>
      _ChangePrincipalPasswordPageState();
}

class _ChangePrincipalPasswordPageState
    extends State<ChangePrincipalPasswordPage> {
  final formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  late String oldPassword;
  final TextEditingController oldPasswordController = TextEditingController();
  final TextEditingController newPasswordController = TextEditingController();
  bool _hasData = false;
  late PrincipalModel principalData;
  final user = AppData().getUser();

  Future<void> _getOldPassword() async {
    principalData = await PrincipalServices().fetchOneFirestore(user.personId);
    oldPassword = principalData.password!;
    setState(() {
      _hasData = true;
    });
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
                            "Change Login Password",
                            style: TextStyle(fontSize: 25),
                          ),
                          heightFactor: 2.5,
                        ),
                        AppPasswordField(
                          prefixIcon: Icons.lock,
                          textEditingController: oldPasswordController,
                          label: 'Old Password',
                          validator: (value) => oldPasswordValidator(
                            value,
                            oldPassword,
                          ),
                        ),
                        AppPasswordField(
                          prefixIcon: Icons.lock,
                          textEditingController: newPasswordController,
                          label: 'New Password',
                          validator: (value) => newPasswordValidator(
                            value,
                            oldPassword,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 90.0),
                          child: AuthButton(
                            height: 40,
                            text: 'Change Password',
                            onTap: () async {
                              if (!await ConnectivityServices()
                                  .getNetworkStatus()) {
                                prefix0.showConnectionErrorDialog(context);
                                return;
                              }
                              if (formKey.currentState!.validate()) {
                                principalData.password =
                                    newPasswordController.text;
                                await PrincipalServices()
                                    .updateFirestore(principalData);
                                displaySnackBar(
                                    context, "Password Changed Successfully!");
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
