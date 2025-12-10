// lib/services/server_service.dart
import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import '../models/response.dart';
import '../models/session.dart';
import 'storage_service.dart';

class ServerService {
  HttpServer? _server;
  final StorageService storage;
  final Map<String, List<WebSocket>> _wsClients = {}; // sessionId -> sockets
  Session? activeSession;

  ServerService({required this.storage});

  Future<String?> startServer({
    required String sessionId,
    required String topic,
    required String facultyName,
    int port = 8080,
  }) async {
    // create session object and file
    final ts = DateTime.now().millisecondsSinceEpoch ~/ 1000;
    final sid = sessionId;
    activeSession = Session(
      sessionId: sid,
      topic: topic,
      facultyName: facultyName,
      createdAt: ts,
      responses: [],
    );
    await storage.writeSession(activeSession!);

    // Bind to IPv4 address on all interfaces
    try {
      _server = await HttpServer.bind(
        InternetAddress.anyIPv4,
        port,
        shared: false,
      );
    } catch (e) {
      debugPrint('Failed to bind server: $e');
      return null;
    }

    // serve loop
    _server!.listen((HttpRequest req) async {
      final path = req.uri.path;
      debugPrint('HTTP ${req.method} ${req.uri}');
      // WebSocket upgrade for /ws/<sessionId>
      if (path.startsWith('/ws/')) {
        final sidFromPath = path.split('/').last;
        try {
          final ws = await WebSocketTransformer.upgrade(req);
          _registerWebSocket(sidFromPath, ws);
          ws.listen(
            (msg) {
              _handleIncomingMessage(sidFromPath, msg);
            },
            onDone: () {
              _unregisterWebSocket(sidFromPath, ws);
            },
          );
        } catch (e) {
          debugPrint('WebSocket upgrade failed: $e');
        }
        return;
      }

      // Serve static student HTML on root or /session/<sessionId>
      if (path == '/' || path.startsWith('/session/')) {
        final html = _studentPageHtml(req.requestedUri, sessionId, port);
        req.response.headers.contentType = ContentType.html;
        req.response.write(html);
        await req.response.close();
        return;
      }

      // Accept POST /submit/<sessionId> fallback (if using fetch instead of ws)
      if (req.method == 'POST' && path.startsWith('/submit/')) {
        final sidFromPath = path.split('/').last;
        final body = await utf8.decoder.bind(req).join();
        try {
          final map = jsonDecode(body) as Map<String, dynamic>;
          await _saveResponse(
            sidFromPath,
            StudentResponse(
              name: map['name'] ?? '',
              roll: map['roll'] ?? '',
              choice: map['choice'] ?? '',
              timestamp: DateTime.now().millisecondsSinceEpoch ~/ 1000,
            ),
          );
          req.response
            ..statusCode = 200
            ..write('ok');
        } catch (e) {
          req.response
            ..statusCode = 400
            ..write('error');
        }
        await req.response.close();
        return;
      }

      // 404 for other endpoints
      req.response.statusCode = HttpStatus.notFound;
      req.response.write('Not found');
      await req.response.close();
    });

    // Return local IP:port link for students
    final ip = await _getLocalIp();
    return 'http://$ip:$port/session/$sessionId';
  }

  Future<void> stopServer() async {
    await _server?.close(force: true);
    _server = null;
    _wsClients.clear();
    activeSession = null;
  }

  void _registerWebSocket(String sid, WebSocket ws) {
    _wsClients.putIfAbsent(sid, () => []).add(ws);
    // Send current session state immediately
    if (activeSession != null && activeSession!.sessionId == sid) {
      ws.add(
        jsonEncode({'type': 'session', 'payload': activeSession!.toJson()}),
      );
    }
  }

  void _unregisterWebSocket(String sid, WebSocket ws) {
    _wsClients[sid]?.remove(ws);
  }

  Future<void> _handleIncomingMessage(String sid, dynamic msg) async {
    try {
      final m = jsonDecode(msg as String) as Map<String, dynamic>;
      if (m['type'] == 'response') {
        final payload = m['payload'] as Map<String, dynamic>;
        final resp = StudentResponse(
          name: payload['name'] ?? '',
          roll: payload['roll'] ?? '',
          choice: payload['choice'] ?? '',
          timestamp: DateTime.now().millisecondsSinceEpoch ~/ 1000,
        );
        await _saveResponse(sid, resp);
      }
    } catch (e) {
      debugPrint('Invalid WS message: $e');
    }
  }

  Future<void> _saveResponse(String sid, StudentResponse resp) async {
    // update activeSession in memory if matches
    if (activeSession != null && activeSession!.sessionId == sid) {
      activeSession!.responses.add(resp);
      await storage.writeSession(activeSession!);
      _broadcast(
        sid,
        jsonEncode({'type': 'new_response', 'payload': resp.toJson()}),
      );
    } else {
      // If session file exists, append to file by reading it and adding
      final s = await storage.readSession(sid);
      if (s != null) {
        s.responses.add(resp);
        await storage.writeSession(s);
        _broadcast(
          sid,
          jsonEncode({'type': 'new_response', 'payload': resp.toJson()}),
        );
      }
    }
  }

  void _broadcast(String sid, String message) {
    final clients = _wsClients[sid];
    if (clients == null) return;
    for (final ws in clients.toList()) {
      if (ws.readyState == WebSocket.open) {
        ws.add(message);
      }
    }
  }

  Future<String> _getLocalIp() async {
    try {
      final interfaces = await NetworkInterface.list(
        type: InternetAddressType.IPv4,
        includeLoopback: false,
      );
      for (final i in interfaces) {
        for (final addr in i.addresses) {
          final ip = addr.address;
          // naive filter for likely Wi-Fi LAN address
          if (!ip.startsWith('127.') &&
              (ip.startsWith('10.') ||
                  ip.startsWith('192.') ||
                  ip.startsWith('172.'))) {
            return ip;
          }
        }
      }
    } catch (e) {
      debugPrint('IP detection failed: $e');
    }
    // fallback
    return '127.0.0.1';
  }

  String _studentPageHtml(Uri baseUri, String sessionId, int port) {
    // Note: For brevity we return a simple HTML with inline JS that connects to ws endpoint.
    final ip = 'HOST_PLACEHOLDER'; // We'll instruct replacing on server-side
    // But we can make client use location.host
    return '''
<!doctype html>
<html>
<head>
<meta charset="utf-8">
<title>Submit Feedback</title>
<style>
  body{font-family: Arial; padding:20px; max-width:600px; margin:auto;}
  label{display:block;margin-top:12px;}
  input, select{width:100%; padding:8px; margin-top:4px;}
  button{margin-top:12px; padding:10px 16px;}
</style>
</head>
<body>
  <h2>Feedback — ${Uri.decodeComponent(activeSession?.topic ?? sessionId)}</h2>
  <label>Name <input id="name"/></label>
  <label>Roll <input id="roll"/></label>
  <label>Understanding
    <select id="choice">
      <option value="A">A - Excellent</option>
      <option value="B">B - Good</option>
      <option value="C">C - Poor</option>
      <option value="D">D - Very Poor</option>
    </select>
  </label>
  <button id="submit">Submit</button>
  <div id="status"></div>
<script>
(function(){
  const sessionId = '$sessionId';
  const host = location.hostname; // student's device will request via IP
  const port = $port;
  const wsUrl = 'ws://' + host + ':' + port + '/ws/' + sessionId;
  let ws;
  function connect() {
    try {
      ws = new WebSocket(wsUrl);
      ws.onopen = () => { console.log('WS open'); document.getElementById('status').innerText='Connected'; };
      ws.onmessage = (ev) => console.log('msg',ev.data);
      ws.onclose = ()=> { console.log('closed'); document.getElementById('status').innerText='Disconnected'; };
      ws.onerror = (e)=> console.log('err',e);
    } catch(e) { console.error(e); }
  }
  connect();

  document.getElementById('submit').addEventListener('click', function(){
    const name = document.getElementById('name').value.trim();
    const roll = document.getElementById('roll').value.trim();
    const choice = document.getElementById('choice').value;
    if(!name || !roll){ alert('Please enter name and roll'); return; }
    const payload = { type: 'response', payload: { name, roll, choice } };
    if(ws && ws.readyState === WebSocket.OPEN){
      ws.send(JSON.stringify(payload));
      document.getElementById('status').innerText='Submitted — thank you';
    } else {
      // Fallback POST
      fetch('/submit/' + sessionId, {
        method:'POST',
        headers:{'Content-Type':'application/json'},
        body: JSON.stringify({ name, roll, choice })
      }).then(r=>r.text()).then(t=>{
        document.getElementById('status').innerText='Submitted via POST';
      }).catch(e=>{
        document.getElementById('status').innerText='Failed to submit';
      });
    }
  });
})();
</script>
</body>
</html>
''';
  }
}
