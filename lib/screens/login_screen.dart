import 'package:flutter/material.dart';
import '../services/api_service.dart';
import 'timer_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();
  String error = '';
  bool isLoading = false;

  Future<void> login() async {
    setState(() {
      isLoading = true;
      error = '';
    });

    try {
      final success = await ApiService.login(
        usernameController.text,
        passwordController.text,
      );

      if (success) {
        //navigation
        if (context.mounted) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => const TimerScreen()),
          );
        }
      } else {
        setState(() {
          error = "Login gagal. Username atau password salah.";
        });
      }
    } catch (e) {
      setState(() {
        error = "Terjadi kesalahan saat login: $e";
      });
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

@override
Widget build(BuildContext context) {
  return Scaffold(
    backgroundColor: Colors.white,
    body: Column(
      children: [
        const SizedBox(height: 80),

       const Align(
        alignment: Alignment.centerLeft,
        child: Padding(
          padding: EdgeInsets.only(left: 20),
          child: 
          Text("{TIMER_APP}",style: 
          TextStyle(
            fontSize: 25,
            fontWeight: FontWeight.bold
          ),),
          ),
       ),

       const SizedBox(height: 25),
       const Align(
        alignment: Alignment.centerLeft,
        child: Padding(
          padding: EdgeInsets.only(left: 20),
          child: 
          Text("HALO,SELAMAT DATANG",style: 
          TextStyle(
            fontSize: 25,
            fontWeight: FontWeight.bold
          ),),
          ),
       ),

        const SizedBox(height: 5),

       const Align(
        alignment: Alignment.centerLeft,
        child: Padding(
          padding: EdgeInsets.only(left: 20),
          child: 
          Text("LOGIN",style: 
          TextStyle(
            fontSize: 35,
            fontWeight: FontWeight.bold
          ),),
          ),
       ),
    
        const SizedBox(height: 20),

        // 🟢 Container form login
        Expanded(
          child: Container(
            margin: const EdgeInsets.only(
              left: 0,   
              right: 0,  
              bottom: 0, 
            ),
            padding: const EdgeInsets.symmetric(
              horizontal: 24, 
              vertical: 32,   
            ),
            decoration: BoxDecoration(
              color: const Color(0xFFF0F0F0),
              borderRadius: const BorderRadius.only(
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
            child: SingleChildScrollView(
              child: Form(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("Username", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 5),
                    TextFormField(
                      controller: usernameController,
                      decoration: const InputDecoration(
                        labelText: "Username/Gmail",
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) =>
                          (value == null || value.isEmpty) ? 'Username tidak boleh kosong' : null,
                    ),
                    const SizedBox(height: 16),

                    const Text("Password", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 5),
                    TextFormField(
                      controller: passwordController,
                      obscureText: true,
                      decoration: const InputDecoration(
                        labelText: "Password",
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) =>
                          (value == null || value.isEmpty) ? 'Password tidak boleh kosong' : null,
                    ),
                    const SizedBox(height: 24),

                    isLoading
                        ? const Center(child: CircularProgressIndicator())
                        : SizedBox(
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
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    ),
  );
}
}