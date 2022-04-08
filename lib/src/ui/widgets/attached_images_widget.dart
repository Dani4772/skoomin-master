import 'package:flutter/material.dart';
import 'package:skoomin/src/base/nav.dart';
import 'package:skoomin/src/data/followup_model.dart';
import 'package:skoomin/src/data/report_model.dart';
import 'package:skoomin/src/ui/widgets/carousel_view_widget.dart';

class AttachedImages extends StatefulWidget {
  final ReportModel? report;
  final FollowupModel? followupModel;

  const AttachedImages({Key? key, this.report, this.followupModel})
      : super(key: key);

  @override
  _AttachedImagesState createState() => _AttachedImagesState();
}

class _AttachedImagesState extends State<AttachedImages> {
  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints.expand(height: 150),
      child: Container(
        margin: const EdgeInsets.all(8.0),
        decoration: BoxDecoration(
          color: Colors.grey.shade200,
          border: Border.all(
            color: Colors.black26,
            width: 2.0,
          ),
        ),
        padding: const EdgeInsets.all(8.0),
        child: widget.report != null
            ? widget.report!.imageURL!.isEmpty
                ? _getNoImagesAttached()
                : ListView.builder(
                    itemCount: widget.report?.imageURL!.length,
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (context, i) => GestureDetector(
                      onTap: () {
                        AppNavigation.to(
                          context,
                          CarouselView(
                            imageUrls: widget.report!.imageURL!,
                            currentId: i,
                          ),
                        );
                      },
                      child: Image.network(
                        widget.report!.imageURL![i],
                        fit: BoxFit.cover,
                        height: 150,
                        width: 150,
                      ),
                    ),
                  )
            : widget.followupModel!.imageUrl!.isEmpty
                ? _getNoImagesAttached()
                : ListView.builder(
                    itemCount: widget.report?.imageURL!.length,
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (context, i) => GestureDetector(
                      onTap: () {
                        AppNavigation.to(
                          context,
                          CarouselView(
                            imageUrls: widget.followupModel!.imageUrl!,
                            currentId: i,
                          ),
                        );
                      },
                      child: Image.network(
                        widget.followupModel!.imageUrl![i],
                        fit: BoxFit.cover,
                        height: 150,
                        width: 150,
                      ),
                    ),
                  ),
      ),
    );
  }

  Widget _getNoImagesAttached() => Center(
        child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const <Widget>[
              Icon(Icons.image),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 3),
              ),
              Text(
                "No Attached Images!",
                style: TextStyle(
                  fontFamily: 'Quicksand',
                  fontWeight: FontWeight.w400,
                ),
              ),
            ]),
      );
}
