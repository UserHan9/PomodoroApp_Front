import 'dart:async';
import 'package:flutter/material.dart';
import '../services/api_service.dart';

class TimerScreen extends StatefulWidget {
  const TimerScreen({super.key});

  @override
  State<TimerScreen> createState() => _TimerScreenState();
}

class _TimerScreenState extends State<TimerScreen> {
  int _seconds = 25 * 60;
  Timer? _timer;
  late DateTime _startTime;

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
    if (posted) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Pomodoro data terkirim!")));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Gagal kirim data.")));
    }
  }

  @override
  Widget build(BuildContext context) {
    final minutes = (_seconds ~/ 60).toString().padLeft(2, '0');
    final seconds = (_seconds % 60).toString().padLeft(2, '0');

    return Scaffold(
      appBar: AppBar(title: const Text("Pomodoro Timer")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("$minutes:$seconds", style: const TextStyle(fontSize: 48)),
            const SizedBox(height: 20),
            ElevatedButton(onPressed: startTimer, child: const Text("Start")),
            ElevatedButton(onPressed: stopTimer, child: const Text("Stop")),
          ],
        ),
      ),
    );
  }
}
