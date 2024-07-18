import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'dart:async';
import '../widgets/custom_button.dart';
import '../services/notification_service.dart';
import '../models/timer_model.dart';

class PomodoroScreen extends StatefulWidget {
  @override
  _PomodoroScreenState createState() => _PomodoroScreenState();
}

class _PomodoroScreenState extends State<PomodoroScreen> {
  late TimerModel _timerModel;
  late NotificationService _notificationService;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _timerModel = TimerModel(
      pomodoroDuration: 25,
      shortBreakDuration: 5,
      longBreakDuration: 15,
    );
    _notificationService = NotificationService();
    _resetTimer();
  }

  void _startTimer() {
    if (_timer != null) {
      _timer?.cancel();
    }

    setState(() {
      if (_timerModel.isWorking) {
        _timerModel.remainingTime = _timerModel.pomodoroDuration * 60;
      } else if (_timerModel.isWorking &&
          _timerModel.completedCycles % _timerModel.cyclesUntilLongBreak == 0) {
        _timerModel.remainingTime = _timerModel.longBreakDuration * 60;
      } else {
        _timerModel.remainingTime = _timerModel.shortBreakDuration * 60;
      }
    });

    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        if (_timerModel.remainingTime > 0) {
          _timerModel.remainingTime--;
        } else {
          _timer?.cancel();
          _notificationService.showNotification(
              _timerModel.isWorking ? 'Pomodoro Completed' : 'Break Completed',
              _timerModel.isWorking
                  ? 'Time for a break!'
                  : 'Time to get back to work!');
          if (_timerModel.isWorking) {
            _timerModel.completedCycles++;
            _timerModel.isWorking = false;
          } else {
            _timerModel.isWorking = true;
          }
          _startTimer();
        }
      });
    });
  }

  void _resetTimer() {
    setState(() {
      _timer?.cancel();
      _timerModel.remainingTime = 0;
      _timerModel.completedCycles = 0;
      _timerModel.isWorking = true;
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
              _buildDurationField(
                  'Pomodoro Duration (minutes)', _timerModel.pomodoroDuration,
                  (value) {
                setState(() {
                  _timerModel.pomodoroDuration = int.tryParse(value) ?? 25;
                });
              }),
              _buildDurationField('Short Break Duration (minutes)',
                  _timerModel.shortBreakDuration, (value) {
                setState(() {
                  _timerModel.shortBreakDuration = int.tryParse(value) ?? 5;
                });
              }),
              _buildDurationField('Long Break Duration (minutes)',
                  _timerModel.longBreakDuration, (value) {
                setState(() {
                  _timerModel.longBreakDuration = int.tryParse(value) ?? 15;
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

  Widget _buildDurationField(
      String label, int initialValue, ValueChanged<String> onChanged) {
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
                      text: 'pomodoro',
                      isSelected: _timerModel.isWorking &&
                          _timerModel.remainingTime ==
                              _timerModel.pomodoroDuration * 60,
                      onPressed: _startTimer),
                  SizedBox(width: 10),
                  CustomButton(
                      text: 'short break',
                      isSelected: !_timerModel.isWorking &&
                          _timerModel.remainingTime ==
                              _timerModel.shortBreakDuration * 60,
                      onPressed: _startTimer),
                  SizedBox(width: 10),
                  CustomButton(
                      text: 'long break',
                      isSelected: !_timerModel.isWorking &&
                          _timerModel.remainingTime ==
                              _timerModel.longBreakDuration * 60,
                      onPressed: _startTimer),
                ],
              ),
              SizedBox(height: 20),
              Text(
                '${(_timerModel.remainingTime ~/ 60).toString().padLeft(2, '0')}:${(_timerModel.remainingTime % 60).toString().padLeft(2, '0')}',
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
                'Completed Pomodoro Cycles: ${_timerModel.completedCycles}',
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
