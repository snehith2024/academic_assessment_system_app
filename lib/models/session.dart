import 'response.dart';

class Session {
  final String id;
  final String topic;
  final int timestamp;
  final List<ResponseData> responses;

  Session({
    required this.id,
    required this.topic,
    required this.timestamp,
    required this.responses,
  });

  // Computed counts
  int get countA => responses.where((r) => r.level == "A").length;
  int get countB => responses.where((r) => r.level == "B").length;
  int get countC => responses.where((r) => r.level == "C").length;
  int get countD => responses.where((r) => r.level == "D").length;

  Map<String, dynamic> toJson() => {
        "id": id,
        "topic": topic,
        "timestamp": timestamp,
        "responses": responses.map((e) => e.toJson()).toList(),
      };

  factory Session.fromJson(Map<String, dynamic> map) => Session(
        id: map["id"],
        topic: map["topic"],
        timestamp: map["timestamp"],
        responses: (map["responses"] as List)
            .map((e) => ResponseData.fromJson(e))
            .toList(),
      );
}
