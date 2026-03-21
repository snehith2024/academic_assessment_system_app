class ResponseData {
  final String id; // optional, Firestore doc id
  final String name;
  final String roll;
  final String level; // A/B/C/D
  final int timestamp;

  ResponseData({
    this.id = '',
    required this.name,
    required this.roll,
    required this.level,
    required this.timestamp,
  });

  factory ResponseData.fromJson(Map<String, dynamic> m, {String id = ''}) {
    return ResponseData(
      id: id,
      name: m['name'] ?? '',
      roll: m['roll'] ?? '',
      level: m['level'] ?? '',
      timestamp: (m['timestamp'] is int)
          ? m['timestamp']
          : (m['timestamp'] is Map ? (m['timestamp']['_seconds'] ?? 0) : 0),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'roll': roll,
      'level': level,
      'timestamp': timestamp,
    };
  }
}
