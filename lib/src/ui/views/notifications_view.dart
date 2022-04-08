import 'package:flutter/material.dart';
import 'package:skoomin/src/base/data.dart';
import 'package:skoomin/src/base/nav.dart';
import 'package:skoomin/src/base/themes.dart';
import 'package:skoomin/src/data/notifications_model.dart';
import 'package:skoomin/src/services/notification_services.dart';
import 'package:skoomin/src/services/principal_services.dart';
import 'package:skoomin/src/ui/modals/dialog.dart';
import 'package:skoomin/src/ui/widgets/auth_button.dart';
import 'package:skoomin/src/ui/widgets/simple_stream_builder.dart';
import 'package:skoomin/src/utils/utils.dart';

class NotificationsView extends StatefulWidget {
  const NotificationsView({Key? key}) : super(key: key);

  @override
  _NotificationsViewState createState() => _NotificationsViewState();
}

class _NotificationsViewState extends State<NotificationsView> {
  late String principalId;
  bool hasData = false;

  Future<void> _getPrincipleId() async {
    await PrincipalServices()
        .fetchOneFirestoreWhere(AppData().getUser().schoolId, "schoolId")
        .then(
          (value) => principalId = value.id!,
        );
    debugPrint(principalId);
    if (mounted) {
      setState(() {
        hasData = true;
      });
    }
  }

  @override
  void initState() {
    _getPrincipleId();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return !hasData
        ? const Center(
            child: CircularProgressIndicator(
              color: AppTheme.primaryColor,
            ),
          )
        : SimpleStreamBuilder<List<NotificationsModel>>.simpler(
            stream: NotificationServices(principalId: principalId)
                .fetchNotifications(isDescending: true),
            context: context,
            builder: (data) => ListView.builder(
              itemCount: data.length,
              itemBuilder: (context, i) {
                return ListTile(
                  title: Text(data[i].title ?? ''),
                  onTap: () {
                    getDialogModal(
                      context: context,
                      child: AlertDialog(
                        title: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            const Padding(
                              padding: EdgeInsets.only(right: 16.0),
                              child: Icon(
                                Icons.notifications,
                              ),
                            ),
                            Expanded(
                              child: Text(
                                data[i].title ?? '',
                                softWrap: true,
                                style: const TextStyle(fontSize: 15),
                              ),
                            ),
                          ],
                        ),
                        content: Text(
                          data[i].body ?? '',
                          softWrap: true,
                          textAlign: TextAlign.justify,
                        ),
                        actions: [
                          TextButtonWidget(
                            child: Text(
                              "Ok",
                              style: TextStyle(
                                color: Colors.grey.shade700,
                              ),
                            ),
                            onPressed: () => AppNavigation.pop(context),
                          )
                        ],
                      ),
                    );
                  },
                  trailing: Text(
                    dateAndTimeFormat(data[i].timestamp!.toDate()),
                    style: const TextStyle(
                      fontSize: 11,
                      color: Color(0x88000000),
                      fontFamily: 'Lato',
                    ),
                  ),
                );
              },
            ),
          );
  }
}
