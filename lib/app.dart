// lib/app.dart
import 'package:flutter/material.dart';
import 'services/storage_service.dart';
import 'services/server_service.dart';
import 'ui/onboarding_page.dart';

class MyApp extends StatelessWidget {
  final StorageService storage = StorageService();
  late final ServerService server;

  MyApp({super.key}) {
    server = ServerService(storage: storage);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Academic Assessment',
      theme: ThemeData(primarySwatch: Colors.indigo),
      home: OnboardingPage(storage: storage, server: server),
    );
  }
}
