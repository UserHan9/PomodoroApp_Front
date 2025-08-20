import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'home_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  String error = "";

  Future<void> login() async {
    final url = Uri.parse("http://localhost:8000/api/token/");
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'username': usernameController.text,
        'password': passwordController.text,
      }),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final prefs = await SharedPreferences.getInstance();

      await prefs.setString('access_token', data['access']);
      await prefs.setString('refresh_token', data['refresh']);
      await prefs.setString('username', usernameController.text);

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const HomeScreen()),
      );
    } else {
      setState(() {
        error = "Login gagal. Username atau password salah.";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final horizontalPadding = width * 0.06;

    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              padding: const EdgeInsets.only(bottom: 16),
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: IntrinsicHeight(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 40),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
                        child: const Text(
                          "{TIMER_APP}",
                          style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                        ),
                      ),
                      const SizedBox(height: 20),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
                        child: const Text(
                          "HALO, SELAMAT DATANG",
                          style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                        ),
                      ),
                      const SizedBox(height: 5),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
                        child: const Text(
                          "LOGIN",
                          style: TextStyle(fontSize: 35, fontWeight: FontWeight.bold),
                        ),
                      ),
                      const SizedBox(height: 20),
                      Expanded(
                        child: Container(
                          width: double.infinity,
                          padding: EdgeInsets.symmetric(
                            horizontal: horizontalPadding,
                            vertical: 32,
                          ),
                          decoration: const BoxDecoration(
                            color: Color(0xFFF0F0F0),
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(32),
                              topRight: Radius.circular(32),
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black12,
                                blurRadius: 12,
                                offset: Offset(0, -4),
                              ),
                            ],
                          ),
                          child: Form(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  "Username",
                                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(height: 5),
                                TextFormField(
                                  controller: usernameController,
                                  decoration: const InputDecoration(
                                    labelText: "Username/Gmail",
                                    border: OutlineInputBorder(),
                                  ),
                                ),
                                const SizedBox(height: 16),
                                const Text(
                                  "Password",
                                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(height: 5),
                                TextFormField(
                                  controller: passwordController,
                                  obscureText: true,
                                  decoration: const InputDecoration(
                                    labelText: "Password",
                                    border: OutlineInputBorder(),
                                  ),
                                ),
                                const SizedBox(height: 24),
                                SizedBox(
                                  width: double.infinity,
                                  child: ElevatedButton(
                                    onPressed: login,
                                    style: ElevatedButton.styleFrom(
                                      minimumSize: const Size.fromHeight(48),
                                    ),
                                    child: const Text("Login"),
                                  ),
                                ),
                                const SizedBox(height: 16),
                                if (error.isNotEmpty)
                                  Text(
                                    error,
                                    style: const TextStyle(color: Colors.red),
                                  ),
                                const SizedBox(height: 20),
                                const Row(
                                  children: [
                                    Expanded(child: Divider(thickness: 1, color: Colors.grey)),
                                    Padding(
                                      padding: EdgeInsets.symmetric(horizontal: 12),
                                      child: Text(
                                        "LOGIN DENGAN",
                                        style: TextStyle(color: Colors.black54),
                                      ),
                                    ),
                                    Expanded(child: Divider(thickness: 1, color: Colors.grey)),
                                  ],
                                ),
                                const SizedBox(height: 20),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    SizedBox(
                                      width: 150,
                                      child: ElevatedButton.icon(
                                        onPressed: () {
                                          // TODO: Login Google
                                        },
                                        icon: const FaIcon(
                                          FontAwesomeIcons.google,
                                          color: Colors.red,
                                        ),
                                        label: const Text("Google"),
                                        style: ElevatedButton.styleFrom(
                                          foregroundColor: Colors.black87,
                                          backgroundColor: Colors.white,
                                          side: const BorderSide(color: Colors.black12),
                                          padding: const EdgeInsets.symmetric(vertical: 0),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 20),
                                    SizedBox(
                                      width: 150,
                                      child: ElevatedButton.icon(
                                        onPressed: () {
                                          // TODO: Login Facebook
                                        },
                                        icon: const FaIcon(
                                          FontAwesomeIcons.facebookF,
                                          color: Colors.white,
                                        ),
                                        label: const Text("Facebook"),
                                        style: ElevatedButton.styleFrom(
                                          foregroundColor: Colors.white,
                                          backgroundColor: Colors.blue,
                                          padding: const EdgeInsets.symmetric(vertical: 12),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 20),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
