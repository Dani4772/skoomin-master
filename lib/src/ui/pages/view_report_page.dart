import 'package:badges/badges.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:skoomin/src/base/data.dart';
import 'package:skoomin/src/base/nav.dart';
import 'package:skoomin/src/data/chat_model.dart';
import 'package:skoomin/src/data/report_chat_model.dart';
import 'package:skoomin/src/data/report_model.dart';
import 'package:flutter/material.dart';
import 'package:skoomin/src/services/chat_services.dart';
import 'package:skoomin/src/services/principal_services.dart';
import 'package:skoomin/src/services/report_chat_services.dart';
import 'package:skoomin/src/services/reports_services.dart';
import 'package:skoomin/src/services/student_registration_services.dart';
import 'package:skoomin/src/ui/modals/dialog.dart';
import 'package:skoomin/src/ui/pages/chat_page.dart';
import 'package:skoomin/src/ui/widgets/attached_images_widget.dart';
import 'package:skoomin/src/ui/widgets/auth_button.dart';
import 'package:skoomin/src/ui/widgets/followup_tile_widget.dart';
import 'package:skoomin/src/ui/widgets/followup_data_widget.dart';

class ViewReportPage extends StatefulWidget {
  final ReportModel report;
  final bool followup;
  final bool? schoolIsActive;
  int chatCounter;

  ViewReportPage({
    Key? key,
    required this.report,
    this.schoolIsActive,
    required this.chatCounter,
    required this.followup,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _ViewReportPageState();
}

class _ViewReportPageState extends State<ViewReportPage> {
  bool followupActive = false;
  late bool studentActiveStatus;
  final user = AppData().getUser();

  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    if (user.isStudent!) {
      StudentRegistrationServices()
          .fetchOneFirestore(user.personId)
          .then((value) {
        studentActiveStatus = value.isActive!;
      });
    }

    var read = (user.isStudent!) ? "isReadByStudent" : "isReadByPrincipal";
    ChatServices(reportChatId: widget.report.reportChatId!)
        .fetchSelected(false, read)
        .then((e) {
      widget.chatCounter = e.length;
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ReportServices().fetchOneFirestore(widget.report.id!).then((value) {
      return followupActive = value.followup!;
    });
    setState(() {
      var read = (user.isStudent!) ? "isReadByStudent" : "isReadByPrincipal";
      ChatServices(reportChatId: widget.report.reportChatId!)
          .fetchSelected(false, read)
          .then((e) {
        widget.chatCounter = e.length;
      });
    });

    return Scaffold(
      key: _scaffoldKey,
      floatingActionButton: (widget.followup)
          ? null
          : FloatingActionButton(
              onPressed: () async {
                setState(() {
                  widget.chatCounter = 0;
                });

                // TODO : Set it to true if issue
                if (widget.schoolIsActive ?? false) {
                  if (widget.report.chatActivated!) {
                    if (!user.isStudent!) {
                      widget.chatCounter = 0;

                      AppNavigation.to(
                        context,
                        ChatPage(widget.report.reportChatId ?? ''),
                      );
                    } else if (user.isStudent! && studentActiveStatus) {
                      widget.chatCounter = 0;
                      AppNavigation.to(
                        context,
                        ChatPage(widget.report.reportChatId ?? ''),
                      );
                    } else {
                      showBlockedDialog(context);
                    }
                  } else {
                    String? principalId;
                    await PrincipalServices()
                        .fetchOneFirestoreWhere(
                      widget.report.schoolId,
                      'schoolId',
                    )
                        .then((value) {
                      principalId = value.id;
                    });

                    ReportChatModel reportChatModel = ReportChatModel(
                      dateTime: Timestamp.now(),
                      studentID: widget.report.studentId!,
                      principleID: principalId!,
                    );

                    final reportRef = await ReportChatServices()
                        .insertFirestore(reportChatModel)
                        .catchError(
                          (e) => throw Exception('Error While Insertion'),
                        );

                    String reportChatId = reportRef.id!;
                    ChatModel chatModel = ChatModel(
                      text:
                          "We have received your report. We'll get back to you after reviewing it.",
                      sentBy: principalId!,
                      timeStamp: Timestamp.now(),
                      isReadByPrincipal: true,
                      isReadByStudent: false,
                    );
                    ChatServices(reportChatId: reportChatId)
                        .insertFirestore(chatModel);

                    widget.report.reportChatId = reportChatId;
                    widget.report.chatActivated = true;

                    ReportModel reportModel = ReportModel(
                      reportChatId: reportChatId,
                      chatActivated: true,
                      followup: widget.report.followup,
                      imageURL: widget.report.imageURL,
                      name: widget.report.name,
                      reportText: widget.report.reportText,
                      reportType: widget.report.reportType,
                      schoolId: widget.report.schoolId,
                      studentId: widget.report.schoolId,
                      timestamp: widget.report.timestamp,
                    )..id = widget.report.id;
                    ReportServices().updateFirestore(reportModel);

                    AppNavigation.to(context, ChatPage(reportChatId));
                  }
                } else {
                  (user.isStudent!)
                      ? _messageIsTemporaryBlockedDialog()
                      : _contractExpiredDialog();
                }
              },
              child: widget.chatCounter != 0
                  ? Badge(
                      position: BadgePosition.topStart(top: 0, start: 3),
                      animationDuration: const Duration(milliseconds: 300),
                      animationType: BadgeAnimationType.scale,
                      badgeContent: Text(
                        '${widget.chatCounter}',
                        style: const TextStyle(color: Colors.white),
                      ),
                      child: IconButton(
                        icon: const Icon(Icons.chat),
                        onPressed: () async {
                          setState(() {
                            widget.chatCounter = 0;
                          });
                          // TODO : Set it to true if issue
                          if (widget.schoolIsActive ?? false) {
                            if (widget.report.chatActivated!) {
                              if (!user.isStudent!) {
                                widget.chatCounter = 0;

                                AppNavigation.to(
                                  context,
                                  ChatPage(widget.report.reportChatId ?? ''),
                                );
                              } else if (user.isStudent! &&
                                  studentActiveStatus) {
                                widget.chatCounter = 0;

                                AppNavigation.to(
                                  context,
                                  ChatPage(widget.report.reportChatId ?? ''),
                                );
                              } else {
                                showBlockedDialog(context);
                              }
                            } else {
                              String? principalId;
                              await PrincipalServices()
                                  .fetchOneFirestoreWhere(
                                widget.report.schoolId,
                                'schoolId',
                              )
                                  .then((value) {
                                principalId = value.id;
                              });

                              ReportChatModel reportChatModel = ReportChatModel(
                                dateTime: Timestamp.now(),
                                studentID: widget.report.studentId ?? '',
                                principleID: principalId ?? '',
                              );

                              final reportRef = await ReportChatServices()
                                  .insertFirestore(reportChatModel)
                                  .catchError(
                                    (e) => throw Exception(
                                      'Error While Insertion',
                                    ),
                                  );

                              String reportChatId = reportRef.id!;
                              ChatModel chatModel = ChatModel(
                                text:
                                    'We have received your report. We\'ll get back to you after reviewing it.',
                                sentBy: principalId ?? '',
                                timeStamp: Timestamp.now(),
                                isReadByPrincipal: true,
                                isReadByStudent: false,
                              );

                              ChatServices(reportChatId: reportChatId)
                                  .insertFirestore(chatModel)
                                  .catchError((e) =>
                                      throw Exception('Error While Insertion'));

                              ReportModel reportModel = ReportModel(
                                reportChatId: reportChatId,
                                chatActivated: true,
                                followup: widget.report.followup,
                                imageURL: widget.report.imageURL,
                                name: widget.report.name,
                                reportText: widget.report.reportText,
                                reportType: widget.report.reportType,
                                schoolId: widget.report.schoolId,
                                studentId: widget.report.schoolId,
                                timestamp: widget.report.timestamp,
                              )..id = widget.report.id;
                              ReportServices().updateFirestore(reportModel);

                              AppNavigation.to(context, ChatPage(reportChatId));
                            }
                          } else {
                            (user.isStudent!)
                                ? _messageIsTemporaryBlockedDialog()
                                : _contractExpiredDialog();
                          }
                        },
                      ),
                    )
                  : const Icon(Icons.chat),
              backgroundColor: Theme.of(context).primaryColor,
            ),
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(children: <Widget>[
            Center(
              heightFactor: 2.5,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Text(
                  '${widget.report.name}',
                  style: const TextStyle(
                    fontFamily: 'GoogleSans',
                    fontSize: 24.0,
                    color: Colors.black,
                  ),
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.all(5),
              decoration: BoxDecoration(
                color: const Color(0xff77a500),
                borderRadius: BorderRadius.circular(10),
              ),
              padding: const EdgeInsets.all(15.0),
              child: Text(
                '${widget.report.reportText}',
                style: const TextStyle(
                  fontFamily: 'Roboto',
                  fontSize: 17.0,
                  color: Colors.white,
                ),
              ),
            ),
            const SizedBox(height: 40),
            AttachedImages(
              report: widget.report,
            ),
            widget.report.followup!
                ? (!user.isStudent!)
                    ? FollowUpDataWidget(
                        report: widget.report,
                      )
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const <Widget>[
                            Text("Your report has been resolved."),
                            Icon(
                              Icons.done,
                              color: Colors.green,
                            )
                          ])
                : (user.isStudent!
                    ? Container()
                    : FollowUpTileWidget(
                        report: widget.report,
                        scaffoldKey: _scaffoldKey,
                      )),
          ]),
        ),
      ),
    );
  }

  _messageIsTemporaryBlockedDialog() => getDialogModal(
        context: context,
        child: AlertDialog(
            title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: const [
                  Padding(
                    padding: EdgeInsets.only(right: 16.0),
                    child: Icon(
                      Icons.do_not_disturb_alt,
                    ),
                  ),
                  Expanded(
                    child: Text(
                      "Messaging Is Temporarily Disabled! ",
                      softWrap: true,
                      style: TextStyle(fontSize: 15),
                    ),
                  ),
                ]),
            content: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Expanded(
                    child: Text(
                      "Please contact your school administrator for further details.",
                      softWrap: true,
                      textAlign: TextAlign.justify,
                    ),
                  ),
                ]),
            actions: [
              TextButtonWidget(
                title: "Ok",
                onPressed: () => AppNavigation.pop(context),
              ),
            ]),
      );

  _contractExpiredDialog() => getDialogModal(
        context: context,
        child: AlertDialog(
          title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: const [
                Padding(
                  padding: EdgeInsets.only(right: 16.0),
                  child: Icon(
                    Icons.do_not_disturb_alt,
                  ),
                ),
                Expanded(
                  child: Text(
                    "Contract Expired! ",
                    softWrap: true,
                    style: TextStyle(fontSize: 19),
                  ),
                ),
              ]),
          content: const Text(
            "Please contact administrator for further details. \n \n Phone: 1-866-333-455 \n Emails: \n 1: office@reportbullying.com \n 2: info@reportbullying.com ",
            softWrap: true,
          ),
          actions: [
            TextButtonWidget(
              child: Text(
                "Ok",
                style: TextStyle(color: Colors.grey.shade700),
              ),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
        ),
      );
}
