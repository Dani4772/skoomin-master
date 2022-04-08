import 'package:flutter/material.dart';
import 'package:skoomin/src/base/data.dart';
import 'package:skoomin/src/base/nav.dart';
import 'package:skoomin/src/base/themes.dart';
import 'package:skoomin/src/data/school_model.dart';
import 'package:skoomin/src/services/connectivity_services.dart';
import 'package:skoomin/src/services/school_services.dart';
import 'package:skoomin/src/ui/modals/dialog.dart' as prefix0;
import 'package:skoomin/src/ui/modals/snackbar.dart';
import 'package:skoomin/src/ui/widgets/app_text_field.dart';
import 'package:skoomin/src/ui/widgets/auth_button.dart';

class ChangeSchoolCodePage extends StatefulWidget {
  const ChangeSchoolCodePage({Key? key}) : super(key: key);

  @override
  _ChangeSchoolCodePageState createState() => _ChangeSchoolCodePageState();
}

class _ChangeSchoolCodePageState extends State<ChangeSchoolCodePage> {
  final formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  late String oldSecretCode;
  final oldCodeController = TextEditingController();
  final newCodeController = TextEditingController();
  late SchoolModel schoolModel;
  bool _hasData = false;
  final user = AppData().getUser();

  Future<void> _getOldSecretCode() async {
    schoolModel = await SchoolServices().fetchOneFirestore(user.schoolId);
    oldSecretCode = schoolModel.secretCode;
    setState(() {
      _hasData = true;
    });
  }

  @override
  void initState() {
    _getOldSecretCode();
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
                            "Change School Code",
                            style: TextStyle(fontSize: 25),
                          ),
                          heightFactor: 2.5,
                        ),
                        AppPasswordField(
                          prefixIcon: Icons.lock,
                          textEditingController: oldCodeController,
                          label: 'Old Code',
                          validator: (value) => value!.isEmpty
                              ? 'Please enter old code'
                              : oldSecretCode != value
                                  ? 'Incorrect old code'
                                  : null,
                        ),
                        AppPasswordField(
                          prefixIcon: Icons.lock,
                          textEditingController: newCodeController,
                          label: 'New Code',
                          validator: (value) => value!.isEmpty
                              ? 'Please enter new code'
                              : oldSecretCode == value
                                  ? 'New code must be different from old code'
                                  : null,
                        ),
                        Padding(
                          padding:
                              const EdgeInsets.symmetric(horizontal: 100.0),
                          child: AuthButton(
                            text: 'Change Code',
                            onTap: () async {
                              if (!await ConnectivityServices()
                                  .getNetworkStatus()) {
                                prefix0.showConnectionErrorDialog(context);
                                return;
                              }
                              if (formKey.currentState!.validate()) {
                                FocusScope.of(context).unfocus();
                                schoolModel.secretCode = newCodeController.text;
                                await SchoolServices()
                                    .updateFirestore(schoolModel);
                                displaySnackBar(context,
                                    "School Code Changed Successfully!");
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
