import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../data/principal_model.dart';
import 'firebase_firestore_service.dart';

class PrincipalServices extends AppFirestoreService<PrincipalModel> {
  @override
  String get collectionName => 'Principals';

  @override
  PrincipalModel parseModel(DocumentSnapshot<Object?> document) {
    return PrincipalModel.fromJson(document.data() as Map<String, dynamic>)
      ..id = document.id;
  }

  Future<PrincipalModel> fetchOneFirestoreWhere(
    dynamic isEqualTo,
    String where,
  ) async {
    try {
      debugPrint('****');
      debugPrint((await FirebaseFirestore.instance
              .collection('Principals')
              .where('schoolId', isEqualTo: 'VeLtv91hszWHBw7Tgvws')
              .get())
          .docs
          .length
          .toString());
      debugPrint('----');
      final List<PrincipalModel> _docs = (await FirebaseFirestore.instance
              .collection(collectionName)
              .where(where, isEqualTo: isEqualTo)
              .get())
          .docs
          .map((e) => parseModel(e))
          .toList();

      debugPrint('Going Data - $isEqualTo - $where - ${_docs.length}');
      if (_docs.isEmpty) {
        throw 'No Record Found';
      }
      return _docs.first;
    } catch (e) {
      rethrow;
    }
  }

  Future<PrincipalModel> signIn({
    required String userName,
    required String password,
  }) async {
    try {
      final _docs = (await FirebaseFirestore.instance
              .collection('Principals')
              .where("name", isEqualTo: userName)
              .where("password", isEqualTo: password)
              .get())
          .docs
          .map((e) => parseModel(e))
          .toList();
      if (_docs.isEmpty) {
        throw 'Username or password is incorrect';
      }
      return _docs.first;
    } catch (_) {
      rethrow;
    }
  }
}
