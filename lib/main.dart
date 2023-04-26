import 'dart:async';

import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // int totalTime = 60;
  int times = 60; // min
  late Timer timer;
  String timeView = '0:00:00';
  bool isRunning = false;

  void timeStart() {
    if (isRunning) {
      // 돌고 있는가? => 시간을 멈춤, 상태 변경
      timeStop();
      setState(() {
        isRunning = !isRunning;
      });
    } else {
      // 안돌고 있음 => 돌아감, 변경
      // 1초마다 1씩 내려감.. 일정간격마다 수행
      setState(() {
        isRunning = !isRunning;
      });
      timer = Timer.periodic(const Duration(seconds: 1), (timer) {
        setState(() {
          timeView = Duration(seconds: times).toString().split('.').first;
          times--;
          print(times);
          if (times < 0) {
            timeStop();
            isRunning = !isRunning;
          }
        });
      });
    }
  }

  void timeStop() {
    timer.cancel();
  }

  void timeReset() {
    //초기 시간으로 설정
    //상태를 변경 false
    setState(() {
      if (timer == null) timeStop();
      timeStop();
      times = 60;
      isRunning = false;
      timeView = Duration(seconds: times).toString().split('.').first;
    });
  }

  void addTime(int sec) {
    times += sec; // times = times + sec;
    times = times < 0 ? 0 : times;
    setState(() {
      timeView = Duration(seconds: times).toString().split('.').first;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Column(
          children: [
            Flexible(
                flex: 1,
                child: Container(
                  width: double.infinity,
                  height: double.infinity,
                  color: Colors.black,
                  child: const Center(
                    child: Text(
                      'my timer',
                      style: TextStyle(color: Colors.white, fontSize: 50),
                    ),
                  ),
                )),
            Flexible(
                flex: 1,
                child: Container(
                  width: double.infinity,
                  height: double.infinity,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      timeButton(sec: 60, color: Colors.teal),
                      timeButton(
                          sec: 30, color: Color.fromARGB(255, 51, 111, 202)),
                      timeButton(
                          sec: -60, color: Color.fromARGB(255, 25, 139, 101)),
                      timeButton(
                          sec: -30, color: Color.fromARGB(255, 51, 163, 60)),
                    ],
                  ),
                )),
            Flexible(
                flex: 2,
                child: Container(
                  width: double.infinity,
                  height: double.infinity,
                  color: Colors.blueGrey,
                  child: Center(
                      child: Text(timeView,
                          style: const TextStyle(
                              color: Colors.white, fontSize: 50))),
                )),
            Flexible(
                flex: 1,
                child: Container(
                  width: double.infinity,
                  height: double.infinity,
                  color: Colors.white,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (isRunning)
                        IconButton(
                            iconSize: 50,
                            onPressed: timeStart,
                            icon: Icon(Icons.pause_circle_rounded))
                      else
                        IconButton(
                            iconSize: 50,
                            onPressed: timeStart,
                            icon: const Icon(Icons.play_circle_rounded)),
                      SizedBox(
                        width: 20,
                      ),
                      IconButton(
                          iconSize: 50,
                          onPressed: timeReset,
                          icon: Icon(Icons.restore_rounded))
                    ],
                  ),
                ))
          ],
        ),
      ),
    );
  }

  GestureDetector timeButton({required int sec, required Color color}) {
    return GestureDetector(
      onTap: () => addTime(sec),
      child: Container(
        width: 100,
        height: 100,
        decoration: BoxDecoration(shape: BoxShape.circle, color: color),
        child: Center(child: Text('$sec')),
      ),
    );
  }
}
