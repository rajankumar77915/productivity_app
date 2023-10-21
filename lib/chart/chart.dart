import 'package:flutter/material.dart';
import 'dart:async';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pomodoro Timer',
      theme: ThemeData(
        primaryColor: Colors.teal,
        hintColor: Colors.tealAccent,
        fontFamily: 'Montserrat',
      ),
      home: PomodoroTimer(),
    );
  }
}

class PomodoroTimer extends StatefulWidget {
  @override
  _PomodoroTimerState createState() => _PomodoroTimerState();
}

class _PomodoroTimerState extends State<PomodoroTimer> {
  int workDuration = 1; // Work duration in minutes
  int breakDuration = 1; // Break duration in minutes
  bool isWorking = true;
  late Timer _timer;
  int _currentMinutes = 25;
  int _currentSeconds = 0;
  int completedPomodoros = 0;

  @override
  void initState() {
    super.initState();
    _currentMinutes = workDuration;
  }

  void startTimer() {
    const oneSec = const Duration(seconds: 1);
    _timer = Timer.periodic(
      oneSec,
          (Timer timer) {
        setState(() {
          if (_currentSeconds == 0) {
            if (_currentMinutes == 0) {
              if (isWorking) {
                _currentMinutes = breakDuration;
              } else {
                _currentMinutes = workDuration;
                completedPomodoros++;
                setState(() {});
              }
              isWorking = !isWorking;
            } else {
              _currentMinutes -= 1;
            }
            _currentSeconds = 59;
          } else {
            _currentSeconds -= 1;
          }
        });
      },
    );
  }

  void stopTimer() {
    if (_timer != null && _timer.isActive) {
      _timer.cancel();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Pomodoro Timer'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              isWorking ? 'Work Time' : 'Break Time',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            Text(
              '$_currentMinutes:${_currentSeconds.toString().padLeft(2, '0')}',
              style: TextStyle(fontSize: 72, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                ElevatedButton(
                  onPressed: startTimer,
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(horizontal: 40, vertical: 20),
                  ),
                  child: Text('Start', style: TextStyle(fontSize: 20)),
                ),
                SizedBox(width: 20),
                ElevatedButton(
                  onPressed: stopTimer,
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(horizontal: 40, vertical: 20),
                  ),
                  child: Text('Stop', style: TextStyle(fontSize: 20)),
                ),
              ],
            ),
            SizedBox(height: 40),
            Text(
              'Completed Pomodoros: $completedPomodoros',
              style: TextStyle(fontSize: 18),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }
}