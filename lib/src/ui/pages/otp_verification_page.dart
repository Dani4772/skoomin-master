
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:skoomin/src/base/data.dart';
import 'package:skoomin/src/base/nav.dart';
import 'package:skoomin/src/data/student_model.dart';
import 'package:skoomin/src/services/student_registration_services.dart';
import 'package:skoomin/src/ui/modals/dialog.dart';

import '../../data/meta_model.dart';
import 'home_page.dart';

class OtpVerificationPage extends StatefulWidget {
  final String phone;
  final StudentModel student;
  final String schoolId;

  const OtpVerificationPage({
    Key? key,
    required this.student,
    required this.phone,
    required this.schoolId,
  }) : super(key: key);

  @override
  _OtpVerificationPageState createState() => _OtpVerificationPageState();
}

class _OtpVerificationPageState extends State<OtpVerificationPage> {
  var _isSent = false;
  final _auth = FirebaseAuth.instance;
  late String _verificationId;
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final _node = FocusNode();

  final _controller = TextEditingController();
  final _codes = List.filled(6, '', growable: false);
  late Meta user;

  @override
  void initState() {
    user = Meta(
      isStudent: false,
      schoolId: '',
      personId: '',
      isSignedIn: false,
    );
    _firebaseAuthentication();
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  _firebaseAuthentication() async {
    _auth.verifyPhoneNumber(
      phoneNumber: widget.phone,
      timeout: const Duration(seconds: 60),
      verificationCompleted: (AuthCredential credential) async {
        getLoadingDialog(context: context, loadingMessage: 'Registering...');
        _signInUser(credential);
      },
      verificationFailed: (ex) async {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(ex.message ?? ''),
          ),
        );
        debugPrint('Exception ${ex.message}');
      },
      codeSent: (verificationId, [int? forceResendingToken]) {
        _verificationId = verificationId;
        _isSent = true;
      },
      codeAutoRetrievalTimeout: (String verificationId) {
        _verificationId = verificationId;
        debugPrint('TimeOut');
      },
    );
  }

  _signInUser(AuthCredential credential) async {
    debugPrint('Sign In');
    await _auth.signInWithCredential(credential).then((result) {
      if (result.user != null) {
        _saveData(result.user!.uid);
      } else {
        debugPrint('Error');
      }
    }).catchError((e) {
      AppNavigation.pop(context);
    });
  }

  _saveData(String userId) async {
    debugPrint('_saveData --> $userId');
    widget.student.id = userId;
    var studentId = await StudentRegistrationServices()
        .insertFirestoreWithId(widget.student);
    debugPrint('studentId -- $studentId');
    user.isStudent = true;
    user.isSignedIn = true;
    // Replaced StudentID with UserID
    user.personId = userId;
    user.schoolId = widget.schoolId;
    AppData().insertHive(user);
    AppNavigation.navigateRemoveUntil(context, const HomePage());
  }

  _confirmOtp() {
    if (_isSent) {
      if (_controller.text.isNotEmpty && _controller.text.length == 6) {
        getLoadingDialog(context: context, loadingMessage: 'Registering...');
        AuthCredential authCredential = PhoneAuthProvider.credential(
          verificationId: _verificationId,
          smsCode: _controller.text,
        );
        _signInUser(authCredential);
      } else {
        debugPrint('Hello');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      key: _scaffoldKey,
      appBar: AppBar(
        title: const Text('OTP Page'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 40.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(
              height: 50,
            ),
            Column(
              children: [
                const Text(
                  'Enter the 6-digit code sent to you at',
                  style: TextStyle(
                    fontFamily: 'Nunito Sans',
                    fontSize: 17,
                    height: 1.1176470588235294,
                  ),
                  textAlign: TextAlign.left,
                ),
                const SizedBox(
                  height: 10,
                ),
                RichText(
                  text: TextSpan(
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                    text: widget.phone,
                    children: [
                      TextSpan(
                        text: '  Change',
                        style: TextStyle(
                          fontWeight: FontWeight.normal,
                          color: Theme.of(context).primaryColor,
                        ),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            Navigator.of(context).pop(false);
                          },
                      )
                    ],
                  ),
                ),
              ],
            ),
            Container(
              width: 220,
              padding: const EdgeInsets.only(top: 40),
              child: Stack(
                children: [
                  Opacity(
                    opacity: 0,
                    child: TextFormField(
                      maxLength: 6,
                      maxLengthEnforcement: MaxLengthEnforcement.enforced,
                      keyboardType: TextInputType.number,
                      focusNode: _node,
                      controller: _controller,
                      onChanged: (val) {
                        final codes = val.split('');
                        for (var i = 0; i < _codes.length; ++i) {
                          if (i < codes.length) {
                            _codes[i] = codes[i];
                          } else {
                            _codes[i] = '';
                          }
                        }
                        setState(() {});
                        if (codes.length == 6) {
                          _confirmOtp();
                        }
                      },
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      if (_node.hasFocus) {
                        SystemChannels.textInput.invokeMethod('TextInput.show');
                      } else {
                        _node.requestFocus();
                      }
                    },
                    child: Container(
                      color: Colors.white,
                      child: Row(
                        children: [
                          _OtpField(_codes[0]),
                          _OtpField(_codes[1]),
                          _OtpField(_codes[2]),
                          _OtpField(_codes[3]),
                          _OtpField(_codes[4]),
                          _OtpField(_codes[5]),
                        ],
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              width: double.infinity,
              height: 40,
              child: TextButton(
                child: const Text(
                  'Confirm OTP',
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
                onPressed: _confirmOtp,
                style: TextButton.styleFrom(
                  backgroundColor: const Color(0xFF77A500),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _OtpField extends Container {
  _OtpField(String text)
      : super(
          width: 30,
          height: 45,
          decoration: BoxDecoration(
            color: Colors.grey.shade300,
            borderRadius: BorderRadius.circular(4),
          ),
          child: Center(
            child: Text(
              text,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF77A500),
              ),
            ),
          ),
        );
}
