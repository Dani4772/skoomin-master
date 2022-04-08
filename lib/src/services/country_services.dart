import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:skoomin/src/data/country_model.dart';
import 'package:skoomin/src/services/firebase_firestore_service.dart';

class CountryServices extends AppFirestoreService<CountryModel> {
  @override
  String get collectionName => 'country';

  @override
  CountryModel parseModel(DocumentSnapshot<Object?> document) {
    return CountryModel.fromJson(document.data() as Map<String, dynamic>)
      ..id = document.id;
  }
}
