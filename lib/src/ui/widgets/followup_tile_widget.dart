import 'package:flutter/material.dart';
import 'package:skoomin/src/base/nav.dart';
import 'package:skoomin/src/data/followup_model.dart';
import 'package:skoomin/src/data/report_model.dart';
import 'package:skoomin/src/services/connectivity_services.dart';
import 'package:skoomin/src/services/followup_services.dart';
import 'package:skoomin/src/services/image_upload_services.dart';
import 'package:skoomin/src/services/reports_services.dart';
import 'package:skoomin/src/ui/modals/dialog.dart';
import 'package:skoomin/src/ui/modals/snackbar.dart';
import 'package:skoomin/src/ui/widgets/app_text_field.dart';
import 'package:skoomin/src/ui/widgets/auth_button.dart';
import 'package:skoomin/src/ui/widgets/image_selector_widget.dart';

class FollowUpTileWidget extends StatefulWidget {
  final ReportModel report;
  final GlobalKey<ScaffoldState> scaffoldKey;

  const FollowUpTileWidget({
    Key? key,
    required this.report,
    required this.scaffoldKey,
  }) : super(key: key);

  @override
  _FollowUpTileWidgetState createState() => _FollowUpTileWidgetState();
}

class _FollowUpTileWidgetState extends State<FollowUpTileWidget> {
  var imageSelector = ImageSelector();
  final TextEditingController commentsController = TextEditingController();
  bool submitActive = true;
  final _commentsForm = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      title: const Text("Follow-Up"),
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.fromLTRB(10, 20, 10, 0),
          child: Form(
            key: _commentsForm,
            child: SimpleAppTextField(
              textEditingController: commentsController,
              validator: (value) =>
                  value!.isEmpty ? 'Please write comments.' : null,
              label: 'Comments',
            ),
          ),
        ),
        const SizedBox(
          height: 20,
        ),
        imageSelector,
        const SizedBox(
          height: 20,
        ),
        FloatingActionButton.extended(
            icon: const Icon(Icons.done),
            label: const Text('Submit'),
            backgroundColor: const Color(0xFF77A500),
            onPressed: submitActive
                ? () async {
                    if (await ConnectivityServices().getNetworkStatus()) {
                      if (_commentsForm.currentState!.validate()) {
                        getDialogModal(
                          context: context,
                          child: AlertDialog(
                              title: const Text(
                                "Are you sure you want to submit?",
                              ),
                              content: const Text(
                                "Report will be moved to the 'Solved Reports' category.",
                                textAlign: TextAlign.justify,
                              ),
                              actions: [
                                TextButtonWidget(
                                  onPressed: () async {
                                    Navigator.of(context).pop();
                                    getLoadingDialog(
                                      context: context,
                                      loadingMessage: "Submitting...",
                                    );
                                    setState(() {
                                      submitActive = false;
                                    });
                                    await ImageUploadServices().uploadImages(
                                      imageSelector.images.values.toList(),
                                    );

                                    widget.report.followup = true;
                                    ReportServices()
                                        .updateFirestore(widget.report)
                                        .catchError((e) => debugPrint(e));

                                    FollowupModel followupModel = FollowupModel(
                                      comment: commentsController.text,
                                      imageUrl:
                                          imageSelector.images.values.toList(),
                                    );

                                    FollowupServices(
                                      reportID: widget.report.id!,
                                    ).insertFirestore(followupModel).then(
                                      (f) async {
                                        AppNavigation.pop(context);
                                        displaySnackBar(context, "Submitted");
                                        Future.delayed(
                                          const Duration(seconds: 2),
                                          () => AppNavigation.pop(context),
                                        );
                                      },
                                    );
                                  },
                                  child: const Text("Yes"),
                                ),
                                TextButtonWidget(
                                  onPressed: () => AppNavigation.pop(context),
                                  title: "No",
                                ),
                              ]),
                        );
                      }
                    } else {
                      showConnectionErrorDialog(context);
                    }
                  }
                : null),
        const SizedBox(height: 20),
      ],
    );
  }
}
