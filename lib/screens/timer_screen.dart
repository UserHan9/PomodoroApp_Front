import 'dart:async';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/api_service.dart';
import '../services/api_motivasi.dart';
import '../services/model/models_motivasi.dart';
import 'login_screen.dart';

class TimerScreen extends StatefulWidget {
  final int durationInSeconds;

  const TimerScreen({super.key, required this.durationInSeconds});

  @override
  State<TimerScreen> createState() => _TimerScreenState();
}


class _TimerScreenState extends State<TimerScreen> {
  int _seconds = 25 * 60;
  Timer? _timer;
  Timer? _motivasiTimer;
  late DateTime _startTime;

  String formatToHHMMSS(int totalSeconds) {
    final hours = (totalSeconds ~/ 3600).toString().padLeft(2, '0');
    final minutes = ((totalSeconds % 3600) ~/ 60).toString().padLeft(2, '0');
    final seconds = (totalSeconds % 60).toString().padLeft(2, '0');
    return '$hours:$minutes:$seconds';
  }

  String username = "";
  List<Motivasi> motivasiList = [];
  int currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _seconds = widget.durationInSeconds;
    loadUsername();
    fetchMotivasi();
  }

  Future<void> loadUsername() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      username = prefs.getString('username') ?? "";
    });
  }

  Future<void> fetchMotivasi() async {
    final result = await ApiMotivasi.getMotivasi();
    print("Jumlah motivasi dari API: ${result.length}");
    if (result.isNotEmpty) {
      setState(() {
        motivasiList = result;
        currentIndex = 0;
      });

      _motivasiTimer = Timer.periodic(const Duration(seconds: 10), (timer) {
        setState(() {
          currentIndex = (currentIndex + 1) % motivasiList.length;
        });
      });
    }
  }

  void startTimer() {
    _startTime = DateTime.now();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_seconds > 0) {
        setState(() => _seconds--);
      } else {
        timer.cancel();
        _sendPomodoro(true);
      }
    });
  }

  void stopTimer() {
    _timer?.cancel();
    _sendPomodoro(false);
  }

  Future<void> _sendPomodoro(bool success) async {
    final endTime = DateTime.now();
    final posted = await ApiService.postPomodoroSession(
      start: _startTime,
      end: endTime,
      success: success,
    );
    if (posted && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Pomodoro berhasil dikirim")),
      );
    }
  }

  void logout() async {
    await ApiService.logout();
    if (context.mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const LoginScreen()),
      );
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    _motivasiTimer?.cancel();
    super.dispose();
  }

  @override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(
      title: const Text("Pomodoro Timer"),
      actions: [
        IconButton(
          onPressed: logout,
          icon: const Icon(Icons.logout),
          tooltip: 'Logout',
        ),
      ],
    ),
    body: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const SizedBox(height: 16),
          if (motivasiList.isNotEmpty)
            Container(
              width: 500,
              height: 100,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              decoration: BoxDecoration(
                color: Colors.blue.shade50,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 5,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    motivasiList[currentIndex].teks,
                    style: const TextStyle(
                      fontSize: 16,
                      fontStyle: FontStyle.italic,
                    ),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 10),
                  Text(
                    motivasiList[currentIndex].pembuat,
                    style: const TextStyle(
                      fontSize: 14,
                      fontStyle: FontStyle.italic,
                    ),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                    textAlign: TextAlign.center,
                  )
                ],
              ),
            ),
          const SizedBox(height: 40),
          Text(
            formatToHHMMSS(_seconds),
            style: const TextStyle(fontSize: 48),
          ),
         const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0), 
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  width: 300, 
                  child: ElevatedButton(
                    onPressed: startTimer,
                    child: const Text("Start"),
                  ),
                ),
                SizedBox(
                  width: 300, 
                  child: ElevatedButton(
                    onPressed: stopTimer,
                    child: const Text("Stop"),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}
}