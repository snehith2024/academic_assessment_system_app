import 'package:flutter/material.dart';
import '../services/local_prefs.dart';
import '../services/firebase_session_service.dart';
import '../services/storage_service.dart';
import 'create_session_page.dart';

class OnboardingPage extends StatefulWidget {
  final LocalPrefs prefs;
  final FirebaseSessionService firebase;
  final StorageService storage;

  const OnboardingPage({
    super.key,
    required this.prefs,
    required this.firebase,
    required this.storage,
  });

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  final TextEditingController _nameCtrl = TextEditingController();
  bool loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final n = await widget.prefs.loadFacultyName();
    if (n != null) _nameCtrl.text = n;
    setState(() => loading = false);
  }

  void _goNext() async {
    final name = _nameCtrl.text.trim();
    if (name.isEmpty) return;

    await widget.prefs.saveFacultyName(name);

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => CreateSessionPage(
          facultyName: name,
          firebase: widget.firebase,
          storage: widget.storage,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (loading)
      return const Scaffold(body: Center(child: CircularProgressIndicator()));

    return Scaffold(
      appBar: AppBar(title: const Text("Welcome")),
      body: Center(
        child: Container(
          padding: const EdgeInsets.all(24),
          constraints: const BoxConstraints(maxWidth: 480),
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            const Text("Enter your name", style: TextStyle(fontSize: 20)),
            const SizedBox(height: 12),
            TextField(
                controller: _nameCtrl,
                decoration: const InputDecoration(labelText: "Faculty Name")),
            const SizedBox(height: 16),
            ElevatedButton(onPressed: _goNext, child: const Text("Continue"))
          ]),
        ),
      ),
    );
  }
}
