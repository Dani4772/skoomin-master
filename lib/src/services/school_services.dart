import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:skoomin/src/data/school_model.dart';
import 'package:skoomin/src/services/firebase_firestore_service.dart';

class SchoolServices extends AppFirestoreService<SchoolModel> {
  @override
  String get collectionName => 'Schools_';

  @override
  SchoolModel parseModel(DocumentSnapshot<Object?> document) {
    return SchoolModel.fromJson(document.data() as Map<String, dynamic>)
      ..id = document.id;
  }
}
