import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:skoomin/src/data/states_model.dart';
import 'package:skoomin/src/services/firebase_firestore_service.dart';

class StatesServices extends AppFirestoreService<StatesModel> {
  @override
  String get collectionName => 'States';

  @override
  StatesModel parseModel(DocumentSnapshot<Object?> document) {
    return StatesModel.fromJson(document.data() as Map<String, dynamic>)
      ..id = document.id;
  }
}
