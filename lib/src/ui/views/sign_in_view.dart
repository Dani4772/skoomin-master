import 'package:flutter/material.dart';
import 'package:skoomin/src/base/data.dart';
import 'package:skoomin/src/base/nav.dart';
import 'package:skoomin/src/data/meta_model.dart';
import 'package:skoomin/src/services/connectivity_services.dart';
import 'package:skoomin/src/services/principal_services.dart';
import 'package:skoomin/src/services/student_registration_services.dart';
import 'package:skoomin/src/ui/pages/home_page.dart';
import 'package:skoomin/src/ui/widgets/app_text_field.dart';
import 'package:skoomin/src/ui/widgets/auth_button.dart';
import 'package:skoomin/src/ui/modals/dialog.dart' as prefix0;
import 'package:skoomin/src/ui/modals/snackbar.dart';

class SignInView extends StatefulWidget {
  const SignInView({
    Key? key,
    required this.scaffoldKey,
  }) : super(key: key);

  final GlobalKey<ScaffoldState> scaffoldKey;

  @override
  createState() => _SignInViewState();
}

class _SignInViewState extends State<SignInView> {
  final _loginFormKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final userNameFocusNode = FocusNode();
  final passwordFocusNode = FocusNode();
  final appData = AppData();
  late Meta user;

  @override
  void initState() {
    super.initState();
    user = Meta(
      isStudent: false,
      schoolId: '',
      personId: '',
      isSignedIn: false,
    );
  }

  @override
  Widget build(context) {
    return Form(
      key: _loginFormKey,
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(8.0),
        child: Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
          AppTextField(
            textEditingController: _usernameController,
            label: 'Username',
            prefixIcon: Icons.account_circle,
            validator: (value) => value!.isEmpty
                ? 'Enter Username'
                : value.length < 3
                    ? 'Enter valid username'
                    : null,
            // focusNode: userNameFocusNode,
          ),
          AppPasswordField(
            validator: (value) => value!.isEmpty
                ? 'Enter password'
                : value.length < 6
                    ? 'Password must be 6 characters long'
                    : null,
            textEditingController: _passwordController,
            label: 'Password',
            prefixIcon: Icons.lock,
            // focusNode: passwordFocusNode,
          ),
          Align(
            alignment: Alignment.centerRight,
            child: Padding(
              padding: const EdgeInsets.only(
                top: 50,
                left: 200,
                right: 8,
              ),
              child: AuthButton(
                width: 0,
                height: 38,
                onTap: _signInAction,
                text: 'Done',
              ),
            ),
          ), //
        ]),
      ),
    );
  }

  void _signInAction() async {
    FocusScope.of(context).unfocus();
    if (!await ConnectivityServices().getNetworkStatus()) {
      prefix0.showConnectionErrorDialog(context);
      return;
    }
    if (!_loginFormKey.currentState!.validate()) {
      return;
    }
    user.isStudent = !_usernameController.text.contains("@principal");

    displaySnackBar(context, "Signing in...");
    // prefix0.getLoadingDialog(
    //   context: context,
    //   loadingMessage: 'Signing In',
    // );
    try {
      if (user.isStudent!) {
        var _student = await StudentRegistrationServices().signIn(
          userName: _usernameController.text.trim(),
          password: _passwordController.text,
        );
        hideSnackBar(context);
        // AppNavigation.pop(context);
        user.personId = _student.id ?? '';
        user.schoolId = _student.schoolId!;
        user.isSignedIn = true;
        appData.insertHive(user);
        if (_student.isActive!) {
          AppNavigation.toReplace(context, const HomePage());
        } else {
          hideSnackBar(context);
          prefix0.showBlockedDialog(context);
        }
      } else {
        var _principal = await PrincipalServices().signIn(
          userName: _usernameController.text.trim(),
          password: _passwordController.text,
        );
        hideSnackBar(context);
        // AppNavigation.pop(context);
        user.personId = _principal.id ?? '';
        user.isSignedIn = true;
        user.schoolId = _principal.schoolId ?? '';
        appData.insertHive(user);
        if (_principal.isActive!) {
          AppNavigation.toReplace(context, const HomePage());
        } else {
          hideSnackBar(context);
          prefix0.showBlockedDialog(context);
        }
      }
    } catch (e) {
      prefix0.getDialogModal(
        context: context,
        child: AlertDialog(
          actions: [
            TextButtonWidget(
              title: "Try Again",
              onPressed: () => AppNavigation.pop(context),
            ),
          ],
          content: Row(
            children: const [
              Icon(
                Icons.warning,
                color: Colors.red,
                size: 30.0,
              ),
              SizedBox(width: 10),
              Expanded(
                child: Text(
                  "Invalid Username/Password. ",
                  style: TextStyle(fontSize: 14, fontFamily: 'GoogleSans'),
                ),
              ),
            ],
          ),
        ),
      );
    }
  }
}
