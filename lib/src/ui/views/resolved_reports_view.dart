import 'package:flutter/material.dart';
import 'package:skoomin/src/base/data.dart';
import 'package:skoomin/src/base/nav.dart';
import 'package:skoomin/src/data/report_model.dart';
import 'package:skoomin/src/services/chat_services.dart';
import 'package:skoomin/src/services/reports_services.dart';
import 'package:skoomin/src/ui/pages/view_report_page.dart';
import 'package:skoomin/src/ui/widgets/simple_stream_builder.dart';
import 'package:skoomin/src/utils/utils.dart';

class ResolvedReportsView extends StatefulWidget {
  const ResolvedReportsView({
    Key? key,
    this.schoolIsActive,
  }) : super(key: key);

  final bool? schoolIsActive;

  @override
  _ResolvedReportsViewState createState() => _ResolvedReportsViewState();
}

class _ResolvedReportsViewState extends State<ResolvedReportsView> {
  final appData = AppData();

  @override
  Widget build(BuildContext context) {
    final user = appData.getUser();
    return SimpleStreamBuilder<List<ReportModel>>.simpler(
      context: context,
      stream: (user.isStudent!)
          ? ReportServices().getStudentFollowUp(followUp: true)
          : ReportServices().getReportsByPrincipal(followUp: true),
      builder: (data) => Column(children: [
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
                          ).fetchSelected(false, read).then((value) {
                            var chatCounter = value.length;

                            AppNavigation.to(
                              context,
                              ViewReportPage(
                                report: data[i],
                                chatCounter: chatCounter,
                                followup: true,
                              ),
                            );
                          });
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(15),
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  data[i].name ?? '',
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 8.0),
                                  child: Text(
                                    data[i].reportType ?? '',
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                        fontFamily: 'Quicksand'),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 13.0),
                                  child: Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        Text(
                                          getFormatedDate(
                                              data[i].timestamp!.toDate()),
                                          style: const TextStyle(
                                              fontSize: 11,
                                              color: Color(0x88000000),
                                              fontFamily: 'Lato'),
                                        ),
                                        const SizedBox(width: 4),
                                        Text(
                                          timeFormat(
                                              data[i].timestamp!.toDate()),
                                          style: const TextStyle(
                                            fontSize: 11,
                                            color: Color(0x88000000),
                                            fontFamily: 'Lato',
                                          ),
                                        ),
                                      ]),
                                )
                              ]),
                        ),
                      ),
                    );
                  },
                ),
              )
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                    Padding(
                      padding: EdgeInsets.only(top: 15),
                    ),
                    Icon(Icons.info),
                    Text("No Reports Yet."),
                  ]),
      ]),
    );
  }
}
