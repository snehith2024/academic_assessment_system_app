import 'package:flutter/material.dart';
import '../models/session.dart';

class SessionDetailsPage extends StatelessWidget {
  final Session session;

  const SessionDetailsPage({super.key, required this.session});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(session.topic),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Topic: ${session.topic}",
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Text("Total Responses: ${session.responses.length}"),
            const SizedBox(height: 24),
            const Text(
              "Responses will be shown here (PHASE 2).",
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}
