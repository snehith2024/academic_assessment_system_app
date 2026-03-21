import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../services/firebase_session_service.dart';
import '../services/storage_service.dart';
import '../models/response.dart';
import '../models/session.dart';
import '../widgets/simple_pie_chart.dart';
import '../widgets/response_tile.dart';

class DashboardPage extends StatefulWidget {
  final String sessionId;
  final FirebaseSessionService firebase;

  const DashboardPage({
    super.key,
    required this.sessionId,
    required this.firebase,
  });

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  List<ResponseData> responses = [];
  String topic = '';
  String faculty = '';
  bool ended = false;

  @override
  void initState() {
    super.initState();
    _loadSessionInfo();
    _listenResponses();
  }

  Future<void> _loadSessionInfo() async {
    final snap = await widget.firebase.loadSessionDoc(widget.sessionId);
    if (snap.exists) {
      final data = snap.data()!;
      setState(() {
        topic = data["topic"] ?? "";
        faculty = data["faculty"] ?? "";
        ended = data["ended"] ?? false;
      });
    }
  }

  void _listenResponses() {
    widget.firebase.streamResponses(widget.sessionId).listen((snap) {
      final list = <ResponseData>[];

      for (var doc in snap.docs) {
        final data = doc.data();

        // FIXED universal timestamp conversion
        int ts;
        if (data["timestamp"] is int) {
          ts = data["timestamp"];
        } else if (data["timestamp"] is Timestamp) {
          ts = (data["timestamp"] as Timestamp).millisecondsSinceEpoch;
        } else {
          ts = DateTime.now().millisecondsSinceEpoch;
        }

        list.add(ResponseData(
          id: doc.id,
          name: data["name"] ?? '',
          roll: data["roll"] ?? '',
          level: data["level"] ?? '',
          timestamp: ts,
        ));
      }

      setState(() => responses = list);
    });
  }

  int get countA => responses.where((r) => r.level == "A").length;
  int get countB => responses.where((r) => r.level == "B").length;
  int get countC => responses.where((r) => r.level == "C").length;
  int get countD => responses.where((r) => r.level == "D").length;

  Future<void> _endSession() async {
    await widget.firebase.endSession(widget.sessionId);

    // SAVE LOCAL BACKUP
    final session = Session(
      id: widget.sessionId,
      topic: topic,
      timestamp: DateTime.now().millisecondsSinceEpoch,
      responses: responses,
    );

    setState(() => ended = true);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Session ended & saved locally")),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Dashboard – $topic"),
        actions: [
          IconButton(
            onPressed: ended ? null : _endSession,
            icon: const Icon(Icons.stop),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            SizedBox(
              height: 180,
              child: SimplePieChart(
                aCount: countA,
                bCount: countB,
                cCount: countC,
                dCount: countD,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _countBox("A", countA, Colors.green),
                _countBox("B", countB, Colors.blue),
                _countBox("C", countC, Colors.orange),
                _countBox("D", countD, Colors.red),
              ],
            ),
            const SizedBox(height: 24),
            Expanded(
              child: ListView.builder(
                itemCount: responses.length,
                itemBuilder: (_, i) => ResponseTile(response: responses[i]),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _countBox(String label, int count, Color color) {
    return Container(
      width: 70,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.15),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Text(label,
              style: TextStyle(color: color, fontWeight: FontWeight.bold)),
          Text(count.toString(), style: const TextStyle(fontSize: 18)),
        ],
      ),
    );
  }
}
