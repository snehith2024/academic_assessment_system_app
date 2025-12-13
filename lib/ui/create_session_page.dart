import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../services/firebase_session_service.dart';
import '../services/storage_service.dart';
import 'dashboard_page.dart';
import 'history_page.dart';

class CreateSessionPage extends StatefulWidget {
  final String facultyName;
  final FirebaseSessionService firebase;
  final StorageService storage;

  const CreateSessionPage({
    super.key,
    required this.facultyName,
    required this.firebase,
    required this.storage,
  });

  @override
  State<CreateSessionPage> createState() => _CreateSessionPageState();
}

class _CreateSessionPageState extends State<CreateSessionPage> {
  final TextEditingController topicCtrl = TextEditingController();

  String? sessionId;
  String? sessionLink;
  bool loading = false;

  Future<void> _startSession() async {
    final topic = topicCtrl.text.trim();
    if (topic.isEmpty) return;

    setState(() => loading = true);

    final id = await widget.firebase.createSession(
      topic,
      faculty: widget.facultyName,
    );

    final link = widget.firebase.buildSessionLink(id);

    setState(() {
      sessionId = id;
      sessionLink = link;
      loading = false;
    });
  }

  void _goDashboard() {
    if (sessionId == null) return;

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => DashboardPage(
          sessionId: sessionId!,
          firebase: widget.firebase,
        ),
      ),
    );
  }

  void _goHistory() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => HistoryPage(
          firebase: widget.firebase,
          facultyId: widget.facultyName,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Hello, ${widget.facultyName}"),
        actions: [
          IconButton(
            icon: const Icon(Icons.history),
            onPressed: _goHistory,
          ),
        ],
      ),
      body: Center(
        child: Container(
          padding: const EdgeInsets.all(32),
          constraints: const BoxConstraints(maxWidth: 480),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                "Create New Session",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: topicCtrl,
                decoration: const InputDecoration(labelText: "Topic Name"),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                height: 52,
                child: FilledButton(
                  onPressed: loading ? null : _startSession,
                  child: loading
                      ? const CircularProgressIndicator()
                      : const Text("Start Session"),
                ),
              ),
              const SizedBox(height: 20),
              if (sessionLink != null) ...[
                SelectableText(
                  "Session Link:\n$sessionLink",
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton.icon(
                      onPressed: _goDashboard,
                      icon: const Icon(Icons.open_in_new),
                      label: const Text("Open Dashboard"),
                    ),
                    const SizedBox(width: 12),
                    ElevatedButton.icon(
                      onPressed: () {
                        Clipboard.setData(ClipboardData(text: sessionLink!));
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text("Link copied")),
                        );
                      },
                      icon: const Icon(Icons.copy),
                      label: const Text("Copy Link"),
                    ),
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
