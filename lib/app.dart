import 'package:flutter/material.dart';
import 'services/local_prefs.dart';
import 'services/firebase_session_service.dart';
import 'services/storage_service.dart';
import 'ui/onboarding_page.dart';

class MyApp extends StatelessWidget {
  final LocalPrefs prefs = LocalPrefs();
  final FirebaseSessionService firebase = FirebaseSessionService();
  final StorageService storage = StorageService();

  MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Academic Assessment System",
      debugShowCheckedModeBanner: false,
      theme: ThemeData(useMaterial3: true, colorSchemeSeed: Colors.blue),
      home: OnboardingPage(
        prefs: prefs,
        firebase: firebase,
        storage: storage,
      ),
    );
  }
}
