import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';


class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Duration selectedDuration = const Duration(hours: 0, minutes: 0, seconds: 0);
  String username = "";

  @override
  void initState() {
    super.initState();
    loadUsername();
  }

  Future<void> loadUsername() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      username = prefs.getString('username') ?? "";
    });
  }

  Future<void> saveDurationToBackend(Duration duration) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('access_token');

    if (token == null) {
      print("Token tidak ditemukan. Login terlebih dahulu.");
      return;
    }

    final url = Uri.parse("http://localhost:8000/api/time-entry/");
    final durationInSeconds = duration.inSeconds;

    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: json.encode({'duration': durationInSeconds}),
    );

    if (response.statusCode == 201) {
      print("Durasi berhasil disimpan.");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Durasi berhasil dikirim!")),
      );
    } else {
      print("Gagal menyimpan durasi: ${response.body}");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Gagal: ${response.body}")),
      );
    }
  }


  void _showTimerForm(BuildContext context) {
    Duration tempDuration = selectedDuration;

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) => Padding(
        padding: const EdgeInsets.only(bottom: 20),
        child: Container(
          decoration: BoxDecoration(
            color: CupertinoColors.systemBackground.resolveFrom(context),
            borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
          ),
          padding: const EdgeInsets.all(16),
          height: 350,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Set Duration',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: const Icon(CupertinoIcons.clear),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              // CupertinoTimerPicker
              Expanded(
                child: CupertinoTimerPicker(
                  mode: CupertinoTimerPickerMode.hms,
                  initialTimerDuration: selectedDuration,
                  onTimerDurationChanged: (Duration newDuration) {
                    tempDuration = newDuration;
                  },
                ),
              ),

              const SizedBox(height: 10),

              // Done button
              CupertinoButton.filled(
                onPressed: () async {
                  setState(() {
                     selectedDuration = tempDuration;
                    });
                      await saveDurationToBackend(selectedDuration);
                  Navigator.pop(context);
                },
                child: const Text('Done'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String formatDuration(Duration duration) {
    final hours = duration.inHours.toString().padLeft(2, '0');
    final minutes = (duration.inMinutes % 60).toString().padLeft(2, '0');
    final seconds = (duration.inSeconds % 60).toString().padLeft(2, '0');
    return '$hours:$minutes:$seconds';
  }

 @override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(title: const Text("Home")),
    body: Column(
      children: [
        const SizedBox(height: 20),
        if (username.isNotEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16,),
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: Color(0xFFF0F0F0),
                borderRadius: BorderRadius.circular(16),
              ),
              padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 10),
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      "SELAMAT DATANG, $username",
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8), // Jarak antar teks
                    const Text(
                      "Semangat Untuk Hari Ini.",
                      style: TextStyle(fontSize: 14),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              )
            ),
          ),

        const SizedBox(height: 40),
        const Text("Selected Duration:", style: TextStyle(fontSize: 18)),
        const SizedBox(height: 8),
        Text(
          formatDuration(selectedDuration),
          style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
        ),
      ],
    ),

    
    floatingActionButton: FloatingActionButton(
      onPressed: () => _showTimerForm(context),
      child: const Icon(Icons.add),
      shape: const CircleBorder(),
    ),
    floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,

    bottomNavigationBar: BottomAppBar(
      shape: const CircularNotchedRectangle(),
      notchMargin: 6.0,
      child: SizedBox(
        height: 60,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            IconButton(
              icon: const Icon(Icons.home),
              onPressed: () {},
            ),
            const SizedBox(width: 40),
            IconButton(
              icon: const Icon(Icons.history),
              onPressed: () {},
            ),
          ],
        ),
      ),
    ),
  );
}

}