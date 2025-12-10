// lib/ui/onboarding_page.dart
import 'package:flutter/material.dart';
import '../services/storage_service.dart';
import '../services/server_service.dart';
import 'create_session_page.dart';
import 'package:shared_preferences/shared_preferences.dart'; // optional

class OnboardingPage extends StatefulWidget {
  final StorageService storage;
  final ServerService server;
  const OnboardingPage(
      {required this.storage, required this.server, super.key});

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  final _controller = TextEditingController();
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadFaculty();
  }

  Future<void> _loadFaculty() async {
    final prefs = await SharedPreferences.getInstance();
    final name = prefs.getString('faculty_name');
    if (name != null && name.isNotEmpty) {
      _controller.text = name;
      _navigateNext(name);
    } else {
      setState(() {
        _loading = false;
      });
    }
  }

  void _saveAndContinue() async {
    final name = _controller.text.trim();
    if (name.isEmpty) return;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('faculty_name', name);
    _navigateNext(name);
  }

  void _navigateNext(String name) {
    Navigator.of(context).pushReplacement(MaterialPageRoute(
        builder: (_) => CreateSessionPage(
            storage: widget.storage,
            server: widget.server,
            facultyName: name)));
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    return Scaffold(
      appBar: AppBar(title: Text('Welcome — Faculty')),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            Text('Enter your name to start', style: TextStyle(fontSize: 18)),
            TextField(
                controller: _controller,
                decoration: InputDecoration(hintText: 'Faculty name')),
            SizedBox(height: 20),
            ElevatedButton(onPressed: _saveAndContinue, child: Text('Continue'))
          ],
        ),
      ),
    );
  }
}
