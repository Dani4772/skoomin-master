import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart' as prefix0;
import 'package:flutter/widgets.dart';
import 'package:skoomin/src/base/data.dart';
import 'package:skoomin/src/base/nav.dart';
import 'package:skoomin/src/base/themes.dart';
import 'package:skoomin/src/data/notifications_model.dart';
import 'package:skoomin/src/services/connectivity_services.dart';
import 'package:skoomin/src/services/notification_services.dart';
import 'package:skoomin/src/ui/widgets/auth_button.dart';

showDialog(
  context,
  bool flag, {
  Widget? title,
  Widget? content,
  List<Widget>? actions,
}) {
  prefix0.showDialog(
    context: context,
    barrierDismissible: flag,
    builder: (context) => prefix0.AlertDialog(
      title: title ?? Container(),
      content: content ?? Container(),
      actions: actions ?? [Container()],
    ),
  );
}

showBlockedDialog(context) => showDialog(
      context,
      true,
      title: Row(
        children: const [
          Padding(
            padding: EdgeInsets.only(right: 20.0),
            child: Icon(
              prefix0.Icons.block,
              color: prefix0.Colors.red,
            ),
          ),
          Text(
            'Blocked!',
            softWrap: true,
            style: TextStyle(fontSize: 15, color: prefix0.Colors.red),
          )
        ],
      ),
      content: const Text('You have been blocked by Administration.'),
      actions: [
        TextButtonWidget(
          title: "Ok",
          onPressed: () => AppNavigation.pop(context),
        ),
      ],
    );

showContractEndedDialog(context) => showDialog(
      context,
      true,
      title: Row(
        children: const [
          Padding(
            padding: EdgeInsets.only(right: 20.0),
            child: Icon(
              prefix0.Icons.block,
              color: prefix0.Colors.red,
            ),
          ),
          Text(
            'Contract Ended',
            softWrap: true,
            style: TextStyle(fontSize: 15, color: prefix0.Colors.red),
          )
        ],
      ),
      content: const Text('School Registration has expired.'),
      actions: [
        prefix0.ElevatedButton(
          child: Text(
            "Ok",
            style: TextStyle(color: prefix0.Colors.grey.shade700),
          ),
          onPressed: () => Navigator.of(context).pop(),
        )
      ],
    );

showConnectionErrorDialog(context) => showDialog(
      context,
      true,
      title: const Text("Network Error"),
      content: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [
          Padding(
            padding: EdgeInsets.only(right: 16.0),
            child: Icon(
              prefix0.Icons.signal_cellular_connected_no_internet_4_bar,
            ),
          ),
          Expanded(
            child: Text(
              "No Internet Connection!",
              softWrap: true,
            ),
          ),
        ],
      ),
      actions: [
        prefix0.ElevatedButton(
          child: Text(
            "Ok",
            style: TextStyle(
              color: prefix0.Colors.grey.shade700,
            ),
          ),
          onPressed: () => AppNavigation.pop(context),
        ),
      ],
    );

showCustomNotificationDialog(
  context,
  key,
  titleController,
  descriptionController,
  passwordController,
  password,
) =>
    showDialog(
      context,
      false,
      title: Row(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(right: 10.0),
            child: Icon(
              prefix0.Icons.add_alert,
              color: prefix0.Theme.of(context).colorScheme.secondary,
            ),
          ),
          const Text("Send Notification")
        ],
      ),
      content: Form(
        key: key,
        child: prefix0.Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            prefix0.TextFormField(
              maxLength: 30,
              controller: titleController,
              decoration: const prefix0.InputDecoration(hintText: 'Title'),
              validator: (value) =>
                  value!.isEmpty ? 'Please enter some text' : null,
            ),
            prefix0.TextFormField(
              maxLength: 120,
              controller: descriptionController,
              decoration: const prefix0.InputDecoration(
                hintText: 'Description',
              ),
              validator: (value) =>
                  value!.isEmpty ? 'Please enter some text' : null,
            ),
            prefix0.TextFormField(
              maxLength: 30,
              obscureText: true,
              controller: passwordController,
              decoration: const prefix0.InputDecoration(hintText: 'Password'),
              validator: (value) => value!.isEmpty
                  ? 'Please enter some text'
                  : (value != password
                      ? 'Notification Password is incorrect.'
                      : null),
            ),
          ],
        ),
      ),
      actions: [
        TextButtonWidget(
          title: "Send",
          onPressed: () async {
            if (!await ConnectivityServices().getNetworkStatus()) {
              showConnectionErrorDialog(context);
              return;
            }

            if (key.currentState.validate()) {
              if (password == passwordController.text) {
                final user = AppData().getUser();
                NotificationsModel notificationModel = NotificationsModel(
                  schoolId: user.schoolId,
                  timestamp: Timestamp.now(),
                  body: descriptionController.text,
                  title: titleController.text,
                );
                NotificationServices(principalId: user.personId)
                    .insertFirestore(notificationModel);
                titleController.text = "";
                descriptionController.text = "";
                passwordController.text = "";
                Navigator.of(context).pop();
              }
            }
          },
        ),
        TextButtonWidget(
          title: "Cancel",
          onPressed: () => AppNavigation.pop(context),
        ),
      ],
    );

showLoadingDialog(context) => prefix0.showDialog(
      context: context,
      builder: (BuildContext context) => prefix0.AlertDialog(
        content: Row(
          children: const [
            prefix0.Padding(
              padding: EdgeInsets.all(8.0),
              child: prefix0.CircularProgressIndicator(
                color: AppTheme.primaryColor,
              ),
            ),
            prefix0.Text('Checking provided Info...'),
          ],
        ),
      ),
      barrierDismissible: false,
    );

getDialog({
  required prefix0.BuildContext context,
  Widget? contentWidget,
  String? content,
  String? title,
  Widget? titleWidget,
  List<Widget>? actions,
}) =>
    prefix0.showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) => prefix0.AlertDialog(
        content: contentWidget ?? Text(content ?? ''),
        title: titleWidget ?? Text(title ?? ''),
        actions: actions ?? [],
      ),
    );

getLoadingDialog({
  required prefix0.BuildContext context,
  required String loadingMessage,
}) =>
    prefix0.showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) => prefix0.AlertDialog(
        content: Row(
          children: [
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: prefix0.CircularProgressIndicator(
                color: AppTheme.primaryColor,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(loadingMessage),
            )
          ],
        ),
      ),
    );

getDialogModal({
  required prefix0.BuildContext context,
  required Widget child,
}) =>
    prefix0.showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) => child,
    );
