import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:skoomin/src/base/data.dart';
import 'package:skoomin/src/base/nav.dart';
import 'package:skoomin/src/data/chat_model.dart';
import 'package:skoomin/src/data/student_model.dart';
import 'package:skoomin/src/services/chat_services.dart';
import 'package:skoomin/src/services/connectivity_services.dart';
import 'package:skoomin/src/services/report_chat_services.dart';
import 'package:skoomin/src/services/student_registration_services.dart';
import 'package:skoomin/src/ui/modals/dialog.dart';
import 'package:skoomin/src/ui/modals/snackbar.dart';
import 'package:skoomin/src/ui/widgets/app_text_field.dart';
import 'package:skoomin/src/ui/widgets/auth_button.dart';
import 'package:skoomin/src/ui/widgets/chat_bubble_widget.dart';
import 'package:skoomin/src/ui/widgets/simple_stream_builder.dart';
import 'package:skoomin/src/utils/utils.dart';

class ChatPage extends StatefulWidget {
  final String reportChatId;

  const ChatPage(this.reportChatId, {Key? key}) : super(key: key);

  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final TextEditingController messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  late String studentId;
  final user = AppData().getUser();

  @override
  void initState() {
    ReportChatServices().fetchOneFirestore(widget.reportChatId).then(
          (value) => studentId = value.studentID,
        );
    var read = (user.isStudent!) ? "isReadByStudent" : "isReadByPrincipal";
    ChatServices(reportChatId: widget.reportChatId)
        .fetchSelected(false, read)
        .then((value) {
      for (ChatModel chat in value) {
        read == "isReadByStudent"
            ? chat.isReadByStudent = true
            : chat.isReadByPrincipal = true;
        ChatServices(reportChatId: widget.reportChatId).updateFirestore(chat);
      }
    });

    super.initState();
  }

  void _blockStudent() {
    () {
      getDialogModal(
        context: context,
        child: AlertDialog(
            title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: const [
                  Padding(
                    padding: EdgeInsets.only(right: 16.0),
                    child: Icon(
                      Icons.block,
                    ),
                  ),
                  Text(
                    'Block',
                    softWrap: true,
                    style: TextStyle(fontSize: 15),
                  ),
                ]),
            content: const Text(
              'Are you sure you want to block this student?',
              softWrap: true,
              textAlign: TextAlign.justify,
            ),
            actions: [
              TextButtonWidget(
                child: Text(
                  "Yes",
                  style: TextStyle(color: Colors.grey.shade700),
                ),
                onPressed: () async {
                  StudentModel studentData = await StudentRegistrationServices()
                      .fetchOneFirestore(studentId);
                  studentData.isActive = false;
                  StudentRegistrationServices()
                      .updateFirestore(studentData)
                      .catchError(
                        (e) => debugPrint(e),
                      );
                  displaySnackBar(
                    context,
                    "Student is Blocked, He will not be able to send message again.",
                  );
                  AppNavigation.pop(context);
                },
              ),
              TextButtonWidget(
                child: Text(
                  "No",
                  style: TextStyle(color: Colors.grey.shade700),
                ),
                onPressed: () => AppNavigation.pop(context),
              ),
            ]),
      );
    };
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Chat"),
        actions: <Widget>[
          (!user.isStudent!)
              ? IconButton(
                  icon: const Icon(Icons.block),
                  tooltip: 'Block',
                  onPressed: _blockStudent,
                )
              : const SizedBox()
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: SimpleStreamBuilder<List<ChatModel>>.simpler(
              stream: ChatServices(reportChatId: widget.reportChatId).getChat(),
              context: context,
              builder: (data) => ListView.builder(
                reverse: true,
                controller: _scrollController,
                itemCount: data.length,
                itemBuilder: (context, i) {
                  if (!data[i].isReadByStudent && user.isStudent!) {
                    data[i].isReadByStudent = true;
                    ChatServices(reportChatId: widget.reportChatId)
                        .updateFirestore(data[i]);
                  }

                  if (!data[i].isReadByPrincipal && (!user.isStudent!)) {
                    data[i].isReadByPrincipal = true;
                    ChatServices(reportChatId: widget.reportChatId)
                        .updateFirestore(data[i]);
                  }
                  return Padding(
                    padding: const EdgeInsets.only(
                        right: 8.0, left: 8.0, top: 10, bottom: 5),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        ChatBubbleWidget(
                          message: data[i].text,
                          time: timeFormat(data[i].timeStamp!.toDate()),
                          isMe:
                              (user.personId == data[i].sentBy) ? true : false,
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ),
          Material(
            elevation: 20,
            child: Padding(
              padding: const EdgeInsets.only(top: 15.0),
              child: Row(
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(
                          bottom: 12.0, left: 8, right: 8),
                      child: Material(
                        elevation: 1,
                        child: SimpleAppTextField(
                          textEditingController: messageController,
                          hint: 'Type a message',
                        ),
                      ),
                    ),
                  ),
                  Container(
                    width: 45,
                    height: 45,
                    margin: const EdgeInsets.only(right: 10, bottom: 13),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(50),
                      color: const Color(0xFF77A200),
                    ),
                    child: IconButton(
                      padding: const EdgeInsets.only(
                        left: 4,
                        right: 11,
                        top: 0,
                        bottom: 13,
                      ),
                      alignment: Alignment.bottomRight,
                      iconSize: 20,
                      icon: const Icon(
                        Icons.send,
                        color: Colors.white,
                      ),
                      onPressed: messageController.text.trim().isEmpty
                          ? null
                          : () async {
                              if (await ConnectivityServices()
                                  .getNetworkStatus()) {
                                debugPrint('Message Sent');
                                if (messageController.text.isNotEmpty) {
                                  bool isReadByPrincipal =
                                      (!user.isStudent!) ? true : false;
                                  bool isReadByStudent =
                                      (user.isStudent!) ? true : false;

                                  ChatModel chatModel = ChatModel(
                                    text: messageController.text,
                                    timeStamp: Timestamp.now(),
                                    sentBy: user.personId,
                                    isReadByPrincipal: isReadByPrincipal,
                                    isReadByStudent: isReadByStudent,
                                  );
                                  ChatServices(
                                    reportChatId: widget.reportChatId,
                                  ).insertFirestore(chatModel).catchError((e) =>
                                      throw Exception('Error While Insertion'));

                                  messageController.clear();
                                }
                              } else {
                                showConnectionErrorDialog(context);
                              }
                            },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
