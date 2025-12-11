import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'app.dart';
// If you used flutterfire configure, uncomment next line and remove comment below:
// import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // If you created firebase_options.dart with flutterfire configure:
  // await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // Otherwise rely on platform config (google-services.json) for Android:
  await Firebase.initializeApp();

  runApp(MyApp());
}
