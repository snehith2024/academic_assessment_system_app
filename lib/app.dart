import 'package:academic_assessment_system_app/ui/create_session_page.dart';
import 'package:flutter/material.dart';
import 'services/local_prefs.dart';
import 'services/firebase_session_service.dart';
import 'services/storage_service.dart';
import 'services/auth_service.dart';
import 'ui/onboarding_page.dart';
import 'ui/login_page.dart';

class MyApp extends StatelessWidget {
  final LocalPrefs prefs = LocalPrefs();
  final FirebaseSessionService firebase = FirebaseSessionService();
  final StorageService storage = StorageService();
  final auth = AuthService();

  MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Academic Assessment System",
      debugShowCheckedModeBanner: false,
      theme: ThemeData(useMaterial3: true, colorSchemeSeed: Colors.blue),
      home: StreamBuilder(
        stream: auth.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          }
          if (snapshot.hasData) {
            return OnboardingPage(
              prefs: prefs,
              firebase: firebase,
              storage: storage,
            );
          }
          return LoginPage(auth: auth);
        },
      ),
    );
  }
}
