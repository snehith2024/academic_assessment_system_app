import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

import 'services/auth_service.dart';
import 'services/firebase_session_service.dart';
import 'services/storage_service.dart';

import 'ui/login_page.dart';
import 'ui/create_session_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = AuthService();
    final firebase = FirebaseSessionService();

    return MaterialApp(
      title: 'Academic Assessment System',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.blue,
      ),

      // 🔐 AUTH GATE (THIS FIXES THE HISTORY LEAK ISSUE)
      home: StreamBuilder(
        stream: auth.authStateChanges(),
        builder: (context, snapshot) {
          // Firebase still checking login state
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          }

          // ❌ Not logged in → Login page
          if (!snapshot.hasData) {
            return LoginPage(auth: auth);
          }

          // ✅ Logged in → Faculty session page
          final user = snapshot.data!;
          final storage = StorageService(); // Instantiate StorageService
          return CreateSessionPage(
            facultyName: user.email ?? 'Faculty',
            firebase: firebase,
            storage: storage, // Pass storage service
          );
        },
      ),
    );
  }
}
