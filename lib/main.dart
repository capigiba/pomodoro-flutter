import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

void main() {
  runApp(PomodoroApp());
}

class PomodoroApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pomodoro Timer',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: PomodoroScreen(),
    );
  }
}

class PomodoroScreen extends StatefulWidget {
  @override
  _PomodoroScreenState createState() => _PomodoroScreenState();
}

class _PomodoroScreenState extends State<PomodoroScreen> {
  int _pomodoroDuration = 25;
  int _shortBreakDuration = 5;
  int _longBreakDuration = 10;

  int _remainingTime = 0;

  bool _isWorking = true;

  int _completedCycles = 0;
  int _cyclesUntilLongBreak = 4;

  late FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin;

  @override
  void initState() {
    super.initState();
    _initializeNotifications();
  }

  void _initializeNotifications() {
    // TODO: Initialize FlutterLocalNotificationsPlugin
  }

  void _startTimer() {
    // TODO: Implement the logic to start the timer
  }

  void _pauseTimer() {
    // TODO: Implement the logic to pause the timer
  }

  void _resetTimer() {
    // TODO: Implement the logic to reset the timer
  }

  void _configureDurations() {
    // TODO: Implement the logic to show dialog to configure durations
  }

  void _showNotification(String title, String body) {
    // TODO: Implement the logic to show a local notification
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Pomodoro Timer'),
      ),
      body: Container(
        color: Colors.blue.shade200,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Pomodoro, Short Break, and Long Break buttons
                  // ----------------------------------------------
                  // When user taps Pomodoro, it should be selected and pomodoro
                  // counter should start.
                  //
                  // When counter reaches 0, a notification should be shown,
                  //
                  // If completed cycles is less than cycles until long break,
                  // short break counter should start.
                  // Otherwise, long break counter should start.
                  _buildButton('pomodoro', isSelected: true),
                  SizedBox(width: 10),
                  // When user taps Short Break, it should be selected and short break counter should start.
                  //
                  // When counter reaches 0, a notification should be shown,
                  // and pomodoro counter should start again.
                  _buildButton('short break'),
                  // When user taps Long Break, it should be selected and long break counter should start.
                  // When counter reaches 0, a notification should be shown,
                  // and pomodoro counter should start again.
                  SizedBox(width: 10),
                  _buildButton('long break'),
                ],
              ),
              SizedBox(height: 20),
              Text(
                '25:00',
                style: TextStyle(
                  fontSize: 80,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _startTimer,
                child: Text('start'),
                style: ElevatedButton.styleFrom(
                  primary: Colors.white,
                  onPrimary: Colors.black,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    onPressed: _resetTimer,
                    icon: Icon(Icons.refresh),
                    color: Colors.white,
                  ),
                  SizedBox(width: 10),
                  IconButton(
                    onPressed: _configureDurations,
                    icon: Icon(Icons.settings),
                    color: Colors.white,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildButton(String text, {bool isSelected = false}) {
    return ElevatedButton(
      onPressed: () {
        // TODO: Implement button functionality
      },
      child: Text(
        text,
        style: TextStyle(color: isSelected ? Colors.white : Colors.black),
      ),
      style: ElevatedButton.styleFrom(
        primary: isSelected ? Colors.red : Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      ),
    );
  }
}
