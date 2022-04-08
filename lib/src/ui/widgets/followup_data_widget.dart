import 'package:flutter/material.dart';
import 'package:skoomin/src/data/followup_model.dart';
import 'package:skoomin/src/data/report_model.dart';
import 'package:skoomin/src/services/followup_services.dart';
import 'package:skoomin/src/ui/widgets/attached_images_widget.dart';
import 'package:skoomin/src/ui/widgets/simple_stream_builder.dart';

class FollowUpDataWidget extends StatefulWidget {
  final ReportModel report;

  const FollowUpDataWidget({Key? key, required this.report}) : super(key: key);

  @override
  _FollowUpDataWidgetState createState() => _FollowUpDataWidgetState();
}

class _FollowUpDataWidgetState extends State<FollowUpDataWidget> {
  @override
  Widget build(BuildContext context) {
    return SimpleStreamBuilder<List<FollowupModel>>.simpler(
      stream: FollowupServices(reportID: widget.report.id!).fetchAllFirestore(),
      context: context,
      builder: (data) => ListView.builder(
        shrinkWrap: true,
        itemCount: data.length,
        itemBuilder: (context, i) {
          FollowupModel followupData = data[i];
          return ExpansionTile(
            title: const Text('Comments'),
            children: <Widget>[
              Container(
                margin: const EdgeInsets.all(5),
                decoration: BoxDecoration(
                  color: Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(10),
                ),
                padding: const EdgeInsets.all(15.0),
                child: Text(
                  '${followupData.comment}',
                  style: const TextStyle(
                    fontFamily: 'ProductSans',
                    fontSize: 17.0,
                    color: Colors.black87,
                  ),
                ),
              ),
              AttachedImages(
                followupModel: followupData,
              ),
            ],
          );
        },
      ),
    );
  }
}
