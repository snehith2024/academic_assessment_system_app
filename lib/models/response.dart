// lib/models/response.dart

class StudentResponse {
  final String name;
  final String roll;
  final String choice; // "A"/"B"/"C"/"D"
  final int timestamp;

  StudentResponse({
    required this.name,
    required this.roll,
    required this.choice,
    required this.timestamp,
  });

  Map<String, dynamic> toJson() => {
    'name': name,
    'roll': roll,
    'choice': choice,
    'timestamp': timestamp,
  };

  static StudentResponse fromJson(Map<String, dynamic> j) => StudentResponse(
    name: j['name'] ?? '',
    roll: j['roll'] ?? '',
    choice: j['choice'] ?? '',
    timestamp: j['timestamp'] ?? 0,
  );
}
