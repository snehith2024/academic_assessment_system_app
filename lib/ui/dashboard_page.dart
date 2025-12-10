// lib/ui/dashboard_page.dart
import 'package:flutter/material.dart';
import '../services/server_service.dart';
import '../services/storage_service.dart';
import '../models/session.dart';
// optional: to open WS from flutter to local server

class DashboardPage extends StatefulWidget {
  final ServerService server;
  final StorageService storage;
  const DashboardPage({required this.server, required this.storage, super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  Session? session;
  // counts
  Map<String, int> counts = {'A': 0, 'B': 0, 'C': 0, 'D': 0};

  @override
  void initState() {
    super.initState();
    session = widget.server.activeSession;
    _recalc();
    // register a local listener: server broadcasts via WS to clients; but we are in-app server owner.
    // For simplicity, serverService saved activeSession so we can poll from it (or add callbacks).
    // We'll poll every 500ms (cheap). Alternatively implement a Stream in ServerService.
    Future.doWhile(() async {
      await Future.delayed(Duration(milliseconds: 500));
      if (!mounted || widget.server.activeSession == null) return false;
      setState(() {
        session = widget.server.activeSession;
        _recalc();
      });
      return true;
    });
  }

  void _recalc() {
    counts = {'A': 0, 'B': 0, 'C': 0, 'D': 0};
    final rs = session?.responses ?? [];
    for (final r in rs) {
      final k = r.choice.toUpperCase();
      if (counts.containsKey(k)) counts[k] = counts[k]! + 1;
    }
  }

  @override
  Widget build(BuildContext context) {
    final total = counts.values.fold(0, (a, b) => a + b);
    return Scaffold(
      appBar: AppBar(title: Text('Dashboard - ${session?.topic ?? ''}')),
      body: Padding(
        padding: EdgeInsets.all(12),
        child: Column(
          children: [
            Text('Total responses: $total', style: TextStyle(fontSize: 18)),
            SizedBox(height: 12),
            // Simple textual "pie" representation
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _statTile('A', counts['A']!),
                _statTile('B', counts['B']!),
                _statTile('C', counts['C']!),
                _statTile('D', counts['D']!),
              ],
            ),
            SizedBox(height: 12),
            Expanded(
                child: ListView(
              children: (session?.responses.reversed.map((r) => ListTile(
                            title: Text('${r.name} (${r.roll})'),
                            subtitle: Text(
                                'Choice ${r.choice} — ${DateTime.fromMillisecondsSinceEpoch(r.timestamp * 1000)}'),
                          )) ??
                      [])
                  .toList(),
            ))
          ],
        ),
      ),
    );
  }

  Widget _statTile(String label, int value) => Column(children: [
        Text(label, style: TextStyle(fontSize: 16)),
        SizedBox(height: 4),
        Text(value.toString(), style: TextStyle(fontSize: 18))
      ]);
}
