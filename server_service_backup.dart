import 'package:cloud_firestore/cloud_firestore.dart';

class ServerService {
  final FirebaseFirestore db = FirebaseFirestore.instance;

  ServerService();

  /// Create a new session in Firestore
  Future<String> createSession(String topic, String faculty) async {
    final String id = DateTime.now().millisecondsSinceEpoch.toString();

    await db.collection("sessions").doc(id).set({
      "id": id,
      "topic": topic,
      "faculty": faculty,
      "timestamp": DateTime.now().millisecondsSinceEpoch,
    });

    return id;
  }

  /// Generate a public link for students
  String buildSessionLink(String sessionId) {
    return "https://academic-assessment-system.web.app/student_page.html?session=$sessionId";
  }

  /// Add a student response
  Future<void> addResponse({
    required String sessionId,
    required String name,
    required String roll,
    required int level,
  }) async {
    final ref =
        db.collection("sessions").doc(sessionId).collection("responses").doc();

    await ref.set({
      "name": name,
      "roll": roll,
      "level": level,
      "timestamp": DateTime.now().millisecondsSinceEpoch,
    });
  }

  /// Dashboard live stream
  Stream<QuerySnapshot<Map<String, dynamic>>> streamResponses(
      String sessionId) {
    return db
        .collection("sessions")
        .doc(sessionId)
        .collection("responses")
        .orderBy("timestamp")
        .snapshots();
  }

  /// History page
  Stream<QuerySnapshot<Map<String, dynamic>>> streamPastSessions() {
    return db.collection("sessions").orderBy("timestamp").snapshots();
  }
}
