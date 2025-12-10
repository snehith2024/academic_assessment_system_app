// lib/services/storage_service.dart
import 'dart:io';
import 'dart:convert';
import 'package:path_provider/path_provider.dart';
import '../models/session.dart';

class StorageService {
  static const String baseFolderName = 'AcademicAssessment';

  Future<Directory> _getBaseDirectory() async {
    // Prefer external storage root if available
    try {
      final dir = await getExternalStorageDirectory();
      if (dir != null) {
        // On Android this may give something like /storage/emulated/0/Android/data/...
        final base = Directory('${dir.path}/$baseFolderName');
        if (!await base.exists()) await base.create(recursive: true);
        return base;
      }
    } catch (_) {}
    // fallback: applicationDocumentsDirectory
    final appDoc = await getApplicationDocumentsDirectory();
    final base = Directory('${appDoc.path}/$baseFolderName');
    if (!await base.exists()) await base.create(recursive: true);
    return base;
  }

  Future<File> sessionFile(String sessionId) async {
    final base = await _getBaseDirectory();
    final f = File('${base.path}/$sessionId.json');
    if (!await f.exists()) await f.create(recursive: true);
    return f;
  }

  Future<void> writeSession(Session session) async {
    final f = await sessionFile(session.sessionId);
    await f.writeAsString(jsonEncode(session.toJson()));
  }

  Future<Session?> readSession(String sessionId) async {
    final f = await sessionFile(sessionId);
    final s = await f.readAsString();
    if (s.trim().isEmpty) return null;
    final m = jsonDecode(s) as Map<String, dynamic>;
    return Session.fromJson(m);
  }

  Future<List<String>> listSessions() async {
    final base = await _getBaseDirectory();
    final files = base.listSync().whereType<File>().toList();
    return files.map((f) => f.path.split('/').last).toList();
  }
}
