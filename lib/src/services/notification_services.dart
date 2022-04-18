
import 'package:cloud_firestore/cloud_firestore.dart';

import '../data/notifications_model.dart';
import 'firebase_firestore_service.dart';

class NotificationServices extends AppFirestoreService<NotificationsModel> {
  final String principalId;

  NotificationServices({required this.principalId});

  @override
  String get collectionName => 'Principals/$principalId/notifications';

  @override
  NotificationsModel parseModel(DocumentSnapshot<Object?> document) {
    return NotificationsModel.fromJson(document.data() as Map<String, dynamic>)
      ..id = document.id;
  }

  Stream<List<NotificationsModel>> fetchNotifications({
    required bool isDescending,
  }) =>
      FirebaseFirestore.instance
          .collection(collectionName)
          .orderBy("timestamp", descending: isDescending)
          .snapshots()
          .map((event) => event.docs.map((e) => parseModel(e)).toList());
}
