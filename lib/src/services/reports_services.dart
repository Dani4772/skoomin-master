import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:skoomin/src/base/data.dart';
import 'package:skoomin/src/data/report_model.dart';
import 'package:skoomin/src/services/firebase_firestore_service.dart';

class ReportServices extends AppFirestoreService<ReportModel> {
  @override
  String get collectionName => 'reports';
  final user = AppData().getUser();

  @override
  ReportModel parseModel(DocumentSnapshot<Object?> document) {
    return ReportModel.fromJson(document.data() as Map<String, dynamic>)
      ..id = document.id;
  }

  Stream<List<ReportModel>> getStudentFollowUp({
    required bool followUp,
  }) =>
      (FirebaseFirestore.instance
              .collection(collectionName)
              .orderBy('timestamp', descending: true)
              .where("schoolId", isEqualTo: user.schoolId)
              .where("followup", isEqualTo: followUp)
              .snapshots())
          .map((e) => e.docs.map((document) => parseModel(document)).toList());

  Stream<List<ReportModel>> getReportsByPrincipal({
    required bool followUp,
  }) =>
      (FirebaseFirestore.instance
              .collection(collectionName)
              .orderBy('timestamp', descending: true)
              .where("studentId", isEqualTo: user.personId)
              .where("followup", isEqualTo: followUp)
              .snapshots())
          .map((e) => e.docs.map((document) => parseModel(document)).toList());
}
