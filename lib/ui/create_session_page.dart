// lib/ui/create_session_page.dart
import 'package:flutter/material.dart';
import '../services/storage_service.dart';
import '../services/server_service.dart';
import 'dashboard_page.dart';

class CreateSessionPage extends StatefulWidget {
  final StorageService storage;
  final ServerService server;
  final String facultyName;
  const CreateSessionPage(
      {required this.storage,
      required this.server,
      required this.facultyName,
      super.key});

  @override
  State<CreateSessionPage> createState() => _CreateSessionPageState();
}

class _CreateSessionPageState extends State<CreateSessionPage> {
  final _topicCtrl = TextEditingController();
  bool _starting = false;
  String? _link;

  Future<void> _startSession() async {
    final topic = _topicCtrl.text.trim();
    if (topic.isEmpty) return;
    setState(() {
      _starting = true;
    });
    final ts = DateTime.now().millisecondsSinceEpoch ~/ 1000;
    final sid = 'session_$ts';
    final link = await widget.server.startServer(
        sessionId: sid,
        topic: topic,
        facultyName: widget.facultyName,
        port: 8080);
    setState(() {
      _starting = false;
      _link = link;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Create Session')),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
                controller: _topicCtrl,
                decoration: InputDecoration(labelText: 'Topic name')),
            SizedBox(height: 16),
            ElevatedButton(
                onPressed: _starting ? null : _startSession,
                child: Text(_starting ? 'Starting...' : 'Start Session')),
            if (_link != null) ...[
              SizedBox(height: 12),
              SelectableText('Student Link: $_link'),
              SizedBox(height: 12),
              ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (_) => DashboardPage(
                            server: widget.server, storage: widget.storage)));
                  },
                  child: Text('Open Dashboard'))
            ]
          ],
        ),
      ),
    );
  }
}
