import 'package:flutter/material.dart';
import '../services/firebase_session_service.dart';
import 'dashboard_page.dart';

class HistoryPage extends StatefulWidget {
  final FirebaseSessionService firebase;

  const HistoryPage({
    super.key,
    required this.firebase,
  });

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  List<Map<String, dynamic>> sessions = [];

  @override
  void initState() {
    super.initState();
    _loadSessions();
  }

  Future<void> _loadSessions() async {
    final snap = await widget.firebase.listSessions();
    setState(() {
      sessions = snap.docs
          .map((d) => {
                "id": d.id,
                "data": d.data(),
              })
          .toList();
    });
  }

  void _openSession(String id) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => DashboardPage(
          sessionId: id,
          firebase: widget.firebase,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Session History")),
      body: ListView.builder(
        itemCount: sessions.length,
        itemBuilder: (_, i) {
          final s = sessions[i];
          final topic = s["data"]["topic"] ?? "Untitled";
          final ended = s["data"]["ended"] ?? false;

          return ListTile(
            title: Text(topic),
            subtitle: Text("ID: ${s["id"]}  |  Ended: $ended"),
            trailing: const Icon(Icons.arrow_forward_ios),
            onTap: () => _openSession(s["id"]),
          );
        },
      ),
    );
  }
}
