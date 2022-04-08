import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:skoomin/src/base/data.dart';
import 'package:skoomin/src/base/nav.dart';
import 'package:skoomin/src/base/themes.dart';
import 'package:skoomin/src/services/connectivity_services.dart';
import 'package:skoomin/src/services/image_upload_services.dart';
import 'package:skoomin/src/services/reports_services.dart';
import 'package:skoomin/src/ui/modals/dialog.dart';
import 'package:skoomin/src/ui/modals/snackbar.dart';
import 'package:skoomin/src/ui/widgets/app_text_field.dart';
import 'package:skoomin/src/ui/widgets/auth_button.dart';
import 'package:skoomin/src/ui/widgets/drop_down_widget.dart';
import 'package:skoomin/src/ui/widgets/image_selector_widget.dart';
import 'package:skoomin/src/ui/modals/dialog.dart' as prefix0;
import 'package:skoomin/src/data/report_model.dart';
import 'package:skoomin/src/utils/const.dart';

class ReportPage extends StatefulWidget {
  const ReportPage({Key? key}) : super(key: key);

  @override
  createState() => _ReportPageState();
}

class _ReportPageState extends State<ReportPage> {
  var imageSelector = ImageSelector();
  bool reportActive = true;
  final _reportFormKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final TextEditingController reportTextController = TextEditingController();
  final TextEditingController reportTitleController = TextEditingController();
  String? selectedReportType;
  final user = AppData().getUser();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      floatingActionButton: FloatingActionButton(
        onPressed: reportActive ? _submitReport : null,
        child: const Icon(
          Icons.done,
          color: Colors.white,
        ),
        backgroundColor: AppTheme.primaryColor,
      ),
      body: Form(
        key: _reportFormKey,
        child: ListView(
          padding: const EdgeInsets.only(bottom: 20),
          children: <Widget>[
            const Center(
              heightFactor: 4.3,
              child: Text(
                "Submit a Report",
                style: TextStyle(
                  fontSize: 24.0,
                  color: Colors.black,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 20, 10, 0),
              child: SimpleAppTextField(
                textEditingController: reportTitleController,
                validator: (value) =>
                    value!.isEmpty ? 'Please enter title' : null,
                maxLength: 50,
                textCapitalization: TextCapitalization.characters,
                label: 'Report Title',
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 20, 10, 0),
              child: SimpleAppTextField(
                textEditingController: reportTextController,
                validator: (value) =>
                    value!.isEmpty ? 'Please enter description' : null,
                label: 'Describe the incident',
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                right: 11,
                left: 11,
                top: 20,
                bottom: 10,
              ),
              child: DropDownWidget(
                list: bullyingType.keys.toList(),
                onChanged: (value) {
                  setState(() {
                    selectedReportType = value;
                  });
                  prefix0.getDialogModal(
                    context: context,
                    child: AlertDialog(
                      title: Row(
                        children: <Widget>[
                          const Icon(
                            Icons.warning,
                            color: Colors.yellow,
                            size: 40.0,
                          ),
                          const SizedBox(width: 20),
                          Expanded(
                            child: selectedReportType != "Other"
                                ? Text(
                                    "Are you sure you want to report about $selectedReportType?",
                                    style: const TextStyle(fontSize: 16.0),
                                  )
                                : const Text(
                                    "Are you sure you want to submit report in 'other' category?",
                                    style: TextStyle(fontSize: 16.0),
                                  ),
                          ),
                        ],
                      ),
                      content: Text(bullyingType[selectedReportType]!),
                      actions: <Widget>[
                        TextButtonWidget(
                          title: "Yes",
                          onPressed: () => AppNavigation.pop(context),
                        ),
                        TextButtonWidget(
                          title: "No",
                          onPressed: () {
                            setState(() {
                              selectedReportType = null;
                            });
                            AppNavigation.pop(context);
                          },
                        ),
                      ],
                    ),
                  );
                },
                select: selectedReportType,
              ),
            ),
            imageSelector
          ],
        ),
      ),
    );
  }

  Future<void> _submitReport() async {
    if (await ConnectivityServices().getNetworkStatus()) {
      if (_reportFormKey.currentState!.validate()) {
        if (selectedReportType == null) {
          prefix0.getDialogModal(
            context: context,
            child: AlertDialog(
              content: Row(
                children: const [
                  Icon(
                    Icons.warning,
                    color: Colors.yellow,
                    size: 40.0,
                  ),
                  SizedBox(width: 20),
                  Expanded(
                    child: Text(
                      "You can't submit a report without selecting report type.",
                      style: TextStyle(fontSize: 16),
                    ),
                  )
                ],
              ),
              actions: [
                TextButtonWidget(
                  onPressed: () => AppNavigation.pop(context),
                  title: "Ok",
                )
              ],
            ),
          );
        } else {
          prefix0.getDialogModal(
            context: context,
            child: AlertDialog(
              title: const Text(
                "Are you sure you want to report?",
              ),
              content: const Text(
                "False reporting will be investigated and consequences may occur. Do you still want to report?",
                textAlign: TextAlign.justify,
              ),
              actions: [
                TextButtonWidget(
                  onPressed: () async {
                    Navigator.of(context).pop();
                    getLoadingDialog(
                      context: context,
                      loadingMessage: 'Reporting...',
                    );
                    setState(() {
                      reportActive = false;
                    });
                    final imageURLs = await ImageUploadServices().uploadImages(
                      imageSelector.images.values.toList(),
                    );
                    ReportModel reportModel = ReportModel(
                      name: reportTitleController.text,
                      reportText: reportTextController.text,
                      imageURL: imageURLs,
                      reportType: selectedReportType,
                      schoolId: user.schoolId,
                      studentId: user.personId,
                      timestamp: Timestamp.now(),
                      chatActivated: false,
                      reportChatId: '9NP41hDYBLSk9S59bCw1',
                      followup: false,
                    );

                    ReportServices().insertFirestore(reportModel).then((_) {
                      Navigator.of(context).pop();
                      displaySnackBar(context, "Reported");
                      Future.delayed(const Duration(seconds: 2),
                          () => AppNavigation.pop(context));
                    });
                  },
                  title: "Yes",
                ),
                TextButtonWidget(
                  onPressed: () => AppNavigation.pop(context),
                  title: "No",
                )
              ],
            ),
          );
        }
      }
    } else {
      prefix0.showConnectionErrorDialog(context);
    }
  }
}
