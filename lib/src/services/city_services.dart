
import 'package:cloud_firestore/cloud_firestore.dart';

import '../data/city_model.dart';
import 'firebase_firestore_service.dart';

class CityServices extends AppFirestoreService<CityModel> {
  @override
  String get collectionName => 'Cities';

  @override
  CityModel parseModel(DocumentSnapshot<Object?> document) {
    return CityModel.fromJson(document.data() as Map<String, dynamic>)
      ..id = document.id;
  }
}
