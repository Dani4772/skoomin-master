
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:skoomin/src/data/_model.dart';

abstract class AppFirestoreService<T extends Model> {
  String get collectionName;

  T parseModel(DocumentSnapshot document);

  Future<List<T>> fetch() => FirebaseFirestore.instance
      .collection(collectionName)
      .get()
      .then((snap) => snap.docs.map((ds) => parseModel(ds)).toList());

  Future<List<T>> fetchSelected(dynamic isEqualTo, String where) async =>
      FirebaseFirestore.instance
          .collection(collectionName)
          .where(where, isEqualTo: isEqualTo)
          .get()
          .then((snap) => snap.docs.map((ds) => parseModel(ds)).toList());

  Stream<List<T>> fetchAllFirestore() => FirebaseFirestore.instance
      .collection(collectionName)
      .snapshots()
      .map((snapshot) =>
          snapshot.docs.map((document) => parseModel(document)).toList());

  Stream<List<T>> fetchAllSortedFirestore() => FirebaseFirestore.instance
      .collection(collectionName)
      .orderBy('timeStamp', descending: true)
      .snapshots()
      .map((snapshot) =>
          snapshot.docs.map((document) => parseModel(document)).toList());

  Stream<T> fetchOneStreamFirestore(String id) => FirebaseFirestore.instance
      .collection(collectionName)
      .doc(id)
      .snapshots()
      .map((snapshot) => parseModel(snapshot));

  Future<T> fetchOneFirestore(String id) async =>
      parseModel(await FirebaseFirestore.instance
          .collection(collectionName)
          .doc(id)
          .get());

  Future<T> insertFirestore(T model) async {
    try {
      final document = await FirebaseFirestore.instance
          .collection(collectionName)
          .add(model.toJson());
      model.id = document.id;
      return model;
    } catch (e) {
      rethrow;
    }
  }

  Future insertFirestoreWithId(T model) async {
    try {
      await FirebaseFirestore.instance
          .collection(collectionName)
          .doc(model.id)
          .set(model.toJson());
    } catch (e) {
      rethrow;
    }
  }

  Future updateFirestore(T model) async {
    try {
      await FirebaseFirestore.instance
          .collection(collectionName)
          .doc(model.id)
          .update(model.toJson());
    } catch (e) {
      rethrow;
    }
  }

  Future deleteFirestore(String documentId) async {
    try {
      await FirebaseFirestore.instance
          .collection(collectionName)
          .doc(documentId)
          .delete();
    } catch (e) {
      rethrow;
    }
  }
}
