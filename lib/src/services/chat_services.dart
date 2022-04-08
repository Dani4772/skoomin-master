import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:skoomin/src/data/chat_model.dart';
import 'package:skoomin/src/services/firebase_firestore_service.dart';

class ChatServices extends AppFirestoreService<ChatModel> {
  final String reportChatId;

  ChatServices({required this.reportChatId});

  @override
  String get collectionName => 'reportChats/$reportChatId/chats';

  @override
  ChatModel parseModel(DocumentSnapshot<Object?> document) {
    return ChatModel.fromJson(document.data() as Map<String, dynamic>)
      ..id = document.id;
  }

  Stream<List<ChatModel>> getChat() => FirebaseFirestore.instance
      .collection(collectionName)
      .orderBy('timestamp')
      .snapshots()
      .map((e) => e.docs.map((document) => parseModel(document)).toList());
}
