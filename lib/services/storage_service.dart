import 'dart:io';
import 'dart:convert';
import 'package:path_provider/path_provider.dart';
import '../models/session.dart';

class StorageService {
  Future<String> _getFolder() async {
    final dir = await getApplicationDocumentsDirectory();
    final folder = "${dir.path}/AcademicAssessment/sessions";
    await Directory(folder).create(recursive: true);
    return folder;
  }

  Future<void> saveSession(Session s) async {
    final folder = await _getFolder();
    final file = File("$folder/session_${s.id}.json");
    await file.writeAsString(jsonEncode(s.toJson()));
  }

  Future<List<Session>> loadAllSessions() async {
    final folder = await _getFolder();
    final dir = Directory(folder);
    if (!dir.existsSync()) return [];

    final List<Session> list = [];
    for (var f in dir.listSync()) {
      if (f.path.endsWith(".json")) {
        final map = jsonDecode(File(f.path).readAsStringSync());
        list.add(Session.fromJson(map));
      }
    }
    return list;
  }

  Future<String> loadStudentPage() async {
    // kept for backward compatibility — now we host student page on Firebase
    final file = File("assets/student_page.html");
    if (file.existsSync()) return file.readAsStringSync();
    return "<html><body>Student page not found.</body></html>";
  }
}
