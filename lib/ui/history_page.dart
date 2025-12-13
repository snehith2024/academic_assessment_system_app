import 'package:flutter/material.dart';
import '../services/firebase_session_service.dart';
import 'dashboard_page.dart';

class HistoryPage extends StatefulWidget {
  final FirebaseSessionService firebase;
  final String facultyId;

  const HistoryPage({
    super.key,
    required this.firebase,
    required this.facultyId,
  });

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  List<Map<String, dynamic>> sessions = [];

  String? _errorMessage;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadSessions();
  }

  Future<void> _loadSessions() async {
    try {
      setState(() {
        _isLoading = true;
        _errorMessage = null;
      });
      final snap = await widget.firebase.listSessions(widget.facultyId);
      setState(() {
        sessions = snap.docs
            .map((d) => {
                  "id": d.id,
                  "data": d.data(),
                })
            .toList();
        _isLoading = false;
      });
    } catch (e) {
      debugPrint("Error loading sessions: $e");
      setState(() {
        _errorMessage = e.toString();
        _isLoading = false;
      });
    }
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
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _errorMessage != null
              ? Center(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.error_outline,
                            size: 48, color: Colors.red),
                        const SizedBox(height: 16),
                        Text(
                          "Error loading history:",
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        const SizedBox(height: 8),
                        SelectableText(
                          _errorMessage!,
                          textAlign: TextAlign.center,
                          style: const TextStyle(color: Colors.red),
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: _loadSessions,
                          child: const Text("Retry"),
                        )
                      ],
                    ),
                  ),
                )
              : sessions.isEmpty
                  ? const Center(child: Text("No sessions found."))
                  : ListView.builder(
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
