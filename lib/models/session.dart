// lib/models/session.dart
import 'response.dart';

class Session {
  final String sessionId;
  final String topic;
  final String facultyName;
  final int createdAt;
  final List<StudentResponse> responses;

  Session({
    required this.sessionId,
    required this.topic,
    required this.facultyName,
    required this.createdAt,
    required this.responses,
  });

  Map<String, dynamic> toJson() => {
        'sessionId': sessionId,
        'topic': topic,
        'facultyName': facultyName,
        'createdAt': createdAt,
        'responses': responses.map((r) => r.toJson()).toList(),
      };

  factory Session.fromJson(Map<String, dynamic> j) => Session(
        sessionId: j['sessionId'] ?? '',
        topic: j['topic'] ?? '',
        facultyName: j['facultyName'] ?? '',
        createdAt: j['createdAt'] ?? 0,
        responses: (j['responses'] as List<dynamic>? ?? [])
            .map((e) => StudentResponse.fromJson(e as Map<String, dynamic>))
            .toList(),
      );
}
