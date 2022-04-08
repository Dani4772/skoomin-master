import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:skoomin/src/data/student_model.dart';
import 'package:skoomin/src/services/firebase_firestore_service.dart';

class StudentRegistrationServices extends AppFirestoreService<StudentModel> {
  @override
  String get collectionName => 'Students';

  @override
  StudentModel parseModel(DocumentSnapshot<Object?> document) {
    return StudentModel.fromJson(document.data() as Map<String, dynamic>)
      ..id = document.id;
  }

  Future<StudentModel> signIn({
    required String userName,
    required String password,
  }) async {
    try {
      final _docs = (await FirebaseFirestore.instance
              .collection('Students')
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
