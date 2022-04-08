import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:skoomin/src/data/followup_model.dart';
import 'package:skoomin/src/services/firebase_firestore_service.dart';

class FollowupServices extends AppFirestoreService<FollowupModel> {
  final String reportID;

  FollowupServices({required this.reportID});

  @override
  String get collectionName => 'reports/$reportID/followup';

  @override
  FollowupModel parseModel(DocumentSnapshot<Object?> document) {
    return FollowupModel.fromJson(document.data() as Map<String, dynamic>)
      ..id = document.id;
  }
}