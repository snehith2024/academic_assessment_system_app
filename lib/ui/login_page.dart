import 'package:flutter/material.dart';
import '../services/auth_service.dart';

class LoginPage extends StatefulWidget {
  final AuthService auth;
  const LoginPage({super.key, required this.auth});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final emailCtrl = TextEditingController();
  final passCtrl = TextEditingController();
  bool isLogin = true;
  bool loading = false;

  Future<void> _submit() async {
    setState(() => loading = true);
    try {
      if (isLogin) {
        await widget.auth.signIn(emailCtrl.text, passCtrl.text);
      } else {
        await widget.auth.register(emailCtrl.text, passCtrl.text);
      }
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.toString())));
    }
    setState(() => loading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          width: 360,
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(isLogin ? "Faculty Login" : "Register",
                  style: const TextStyle(fontSize: 22)),
              const SizedBox(height: 16),
              TextField(
                  controller: emailCtrl,
                  decoration: const InputDecoration(labelText: "Email")),
              TextField(
                  controller: passCtrl,
                  obscureText: true,
                  decoration: const InputDecoration(labelText: "Password")),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: loading ? null : _submit,
                child: Text(isLogin ? "Login" : "Register"),
              ),
              TextButton(
                onPressed: () => setState(() => isLogin = !isLogin),
                child:
                    Text(isLogin ? "Create account" : "Already have account"),
              )
            ],
          ),
        ),
      ),
    );
  }
}
