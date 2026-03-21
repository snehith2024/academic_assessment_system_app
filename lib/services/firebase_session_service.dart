import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirebaseSessionService {
  final FirebaseFirestore db = FirebaseFirestore.instance;

  /// Create a new session
  Future<String> createSession(String topic, {required String faculty}) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      throw Exception("User must be logged in to create a session");
    }
    final doc = await db.collection("sessions").add({
      "topic": topic,
      "facultyId": user.uid,
      "facultyEmail": user.email,
      "faculty": faculty,
      "createdAt": FieldValue.serverTimestamp(),
      "ended": false,
    });
    return doc.id;
  }

  /// Build shareable link
  String buildSessionLink(String sessionId) {
    return "https://academic-assessment-system.web.app/student_page.html?session=$sessionId";
  }

  /// Listen for live responses
  Stream<QuerySnapshot<Map<String, dynamic>>> streamResponses(
      String sessionId) {
    return db
        .collection("sessions")
        .doc(sessionId)
        .collection("responses")
        .orderBy("timestamp", descending: true)
        .snapshots();
  }

  /// Load session info
  Future<DocumentSnapshot<Map<String, dynamic>>> loadSessionDoc(
      String sessionId) {
    return db.collection("sessions").doc(sessionId).get();
  }

  /// Save student response (from student_page.html)
  Future<void> submitResponse(
      String sessionId, String name, String roll, String level) async {
    await db.collection("sessions").doc(sessionId).collection("responses").add({
      "name": name,
      "roll": roll,
      "level": level,
      "timestamp": FieldValue.serverTimestamp(),
    });
  }

  /// End session → Mark ended:true
  Future<void> endSession(String sessionId) async {
    await db.collection("sessions").doc(sessionId).update({"ended": true});
  }

  /// List all sessions
  Future<QuerySnapshot<Map<String, dynamic>>> listSessions() {
    final user = FirebaseAuth.instance.currentUser;
    return db
        .collection("sessions")
        .where("facultyId", isEqualTo: user?.uid)
        .orderBy("createdAt", descending: true)
        .get();
  }
}
