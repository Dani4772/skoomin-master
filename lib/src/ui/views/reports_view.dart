import 'package:flutter/material.dart';
import 'package:skoomin/src/base/data.dart';
import 'package:skoomin/src/base/nav.dart';
import 'package:skoomin/src/data/report_model.dart';
import 'package:skoomin/src/services/chat_services.dart';
import 'package:skoomin/src/services/reports_services.dart';
import 'package:skoomin/src/ui/modals/dialog.dart' as prefix0;
import 'package:skoomin/src/ui/pages/view_report_page.dart';
import 'package:skoomin/src/ui/widgets/simple_stream_builder.dart';
import 'package:skoomin/src/utils/utils.dart';

class ReportsView extends StatelessWidget {
  const ReportsView({
    Key? key,
    required this.schoolIsActive,
  }) : super(key: key);

  final bool? schoolIsActive;

  @override
  Widget build(BuildContext context) {
    final user = AppData().getUser();
    return SimpleStreamBuilder<List<ReportModel>>.simpler(
      context: context,
      stream: (user.isStudent!)
          ? ReportServices().getStudentFollowUp(followUp: false)
          : ReportServices().getReportsByPrincipal(followUp: false),
      key: key,
      builder: (data) => Column(children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: (user.isStudent == null
              ? Container()
              : ((!user.isStudent!)
                  ? (schoolIsActive == null
                      ? Container()
                      : (!schoolIsActive!
                          ? _getSchoolIsNotActive(context)
                          : null))
                  : null)),
        ),
        data.isNotEmpty
            ? Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.only(bottom: 60),
                  itemCount: data.length,
                  shrinkWrap: true,
                  itemBuilder: (context, i) {
                    return Card(
                      elevation: 1,
                      margin: const EdgeInsets.all(10),
                      child: InkWell(
                        onTap: () {
                          var read = (user.isStudent!)
                              ? "isReadByStudent"
                              : "isReadByPrincipal";

                          ChatServices(
                            reportChatId: data[i].reportChatId ?? '',
                          ).fetchSelected(false, read).then(
                            (value) {
                              var chatCounter = value.length;

                              AppNavigation.to(
                                context,
                                ViewReportPage(
                                  report: data[i],
                                  schoolIsActive: schoolIsActive ?? true,
                                  chatCounter: chatCounter,
                                  followup: false,
                                ),
                              );
                            },
                          );
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(15),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              FutureBuilder(
                                future:
                                    messageReceived(data[i].reportChatId ?? ''),
                                builder: (context, flag) {
                                  switch (flag.connectionState) {
                                    case ConnectionState.waiting:
                                      return Container();
                                    default:
                                      return Align(
                                          alignment: Alignment.topRight,
                                          child: flag.data != null
                                              ? const Icon(
                                                  Icons.add_comment,
                                                  color: Colors.green,
                                                )
                                              : null);
                                  }
                                },
                              ),
                              Text(
                                data[i].name ?? '',
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 8.0),
                                child: Text(
                                  data[i].reportType ?? '',
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    fontFamily: 'Quicksand',
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 13.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Text(
                                      getFormatedDate(
                                        data[i].timestamp!.toDate(),
                                      ),
                                      style: const TextStyle(
                                        fontSize: 11,
                                        fontFamily: 'Lato',
                                        color: Color(0x88000000),
                                      ),
                                    ),
                                    const SizedBox(width: 4),
                                    Text(
                                      timeFormat(data[i].timestamp!.toDate()),
                                      style: const TextStyle(
                                        fontSize: 11,
                                        color: Color(0x88000000),
                                        fontFamily: 'Lato',
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              )
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const <Widget>[
                    Icon(Icons.info),
                    Text("No Reports Yet."),
                  ]),
      ]),
    );
  }

  Widget _getSchoolIsNotActive(BuildContext context) =>
      Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
        const Icon(Icons.do_not_disturb_alt),
        const Text(
          "You will not receive new reports.",
          style: TextStyle(fontSize: 15),
        ),
        GestureDetector(
          child: Text(
            "Details",
            softWrap: true,
            style: TextStyle(
              color: Theme.of(context).primaryColor,
              fontWeight: FontWeight.bold,
              decoration: TextDecoration.underline,
            ),
          ),
          onTap: () => prefix0.showContractEndedDialog(context),
        )
      ]);

  Future<bool> messageReceived(reportChatId) async {
    var readBy = (AppData().getUser().isStudent!)
        ? "isReadByStudent"
        : "isReadByPrincipal";
    var data = await ChatServices(reportChatId: reportChatId)
        .fetchSelected(false, readBy);

    return data.isNotEmpty;
  }
}
