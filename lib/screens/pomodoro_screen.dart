import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'dart:async';
import '../widgets/custom_button.dart';
import '../services/notification_service.dart';

class PomodoroScreen extends StatefulWidget {
  @override
  _PomodoroScreenState createState() => _PomodoroScreenState();
}

class _PomodoroScreenState extends State<PomodoroScreen> {
  int _pomodoroDuration = 25;
  int _shortBreakDuration = 5;
  int _longBreakDuration = 15;

  int _remainingTime = 0;
  bool _isWorking = true;
  bool _isBreak = false;

  int _completedCycles = 0;
  int _pomodoroCount = 0;
  final int _cyclesUntilLongBreak = 4;

  late NotificationService _notificationService;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _notificationService = NotificationService();
    _resetTimer();
  }

  void _startTimer() {
    if (_timer != null) {
      _timer?.cancel();
    }

    setState(() {
      if (_isWorking) {
        _remainingTime = _pomodoroDuration * 60;
      } else if (_isBreak && _pomodoroCount % _cyclesUntilLongBreak == 0) {
        _remainingTime = _longBreakDuration * 60;
      } else {
        _remainingTime = _shortBreakDuration * 60;
      }
    });

    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        if (_remainingTime > 0) {
          _remainingTime--;
        } else {
          _timer?.cancel();
          _notificationService.showNotification(
              _isWorking ? 'Pomodoro Completed' : 'Break Completed',
              _isWorking ? 'Time for a break!' : 'Time to get back to work!');
          if (_isWorking) {
            _completedCycles++;
            _pomodoroCount++;
            _isWorking = false;
            _isBreak = true;
          } else {
            _isWorking = true;
            _isBreak = false;
          }
          _startTimer();
        }
      });
    });
  }

  void _resetTimer() {
    setState(() {
      _timer?.cancel();
      _remainingTime = 0;
      _completedCycles = 0;
      _pomodoroCount = 0;
      _isWorking = true;
      _isBreak = false;
    });
  }

  void _configureDurations() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Configure Durations'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildDurationField('Pomodoro Duration (minutes)', _pomodoroDuration, (value) {
                setState(() {
                  _pomodoroDuration = int.tryParse(value) ?? 25;
                });
              }),
              _buildDurationField('Short Break Duration (minutes)', _shortBreakDuration, (value) {
                setState(() {
                  _shortBreakDuration = int.tryParse(value) ?? 5;
                });
              }),
              _buildDurationField('Long Break Duration (minutes)', _longBreakDuration, (value) {
                setState(() {
                  _longBreakDuration = int.tryParse(value) ?? 15;
                });
              }),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Close'),
            ),
          ],
        );
      },
    );
  }

  Widget _buildDurationField(String label, int initialValue, ValueChanged<String> onChanged) {
    return TextField(
      decoration: InputDecoration(labelText: label),
      keyboardType: TextInputType.number,
      onChanged: onChanged,
      controller: TextEditingController(text: initialValue.toString()),
    );
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
                  CustomButton(
                      text: 'pomodoro', isSelected: _isWorking && !_isBreak, onPressed: _startTimer),
                  SizedBox(width: 10),
                  CustomButton(text: 'short break', isSelected: _isBreak && _pomodoroCount % _cyclesUntilLongBreak != 0, onPressed: _startTimer),
                  SizedBox(width: 10),
                  CustomButton(text: 'long break', isSelected: _isBreak && _pomodoroCount % _cyclesUntilLongBreak == 0, onPressed: _startTimer),
                ],
              ),
              SizedBox(height: 20),
              Text(
                '${(_remainingTime ~/ 60).toString().padLeft(2, '0')}:${(_remainingTime % 60).toString().padLeft(2, '0')}',
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
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.black,
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
              SizedBox(height: 20),
              Text(
                'Completed Pomodoro Cycles: $_completedCycles',
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
