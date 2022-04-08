import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:skoomin/src/data/report_chat_model.dart';
import 'package:skoomin/src/services/firebase_firestore_service.dart';

class ReportChatServices extends AppFirestoreService<ReportChatModel> {
  @override
  String get collectionName => 'reportChats';

  @override
  ReportChatModel parseModel(DocumentSnapshot<Object?> document) {
    return ReportChatModel.fromJson(document.data() as Map<String, dynamic>)
      ..id = document.id;
  }
}
