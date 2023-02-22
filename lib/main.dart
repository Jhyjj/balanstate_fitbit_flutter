import 'package:flutter/material.dart';
import 'sleep3_line_copy.dart';
// import 'sleep4_line.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sleep Chart',
      home: Scaffold(
        appBar: AppBar(
          title: Text('Sleep Chart'),
        ),
        body: Center(
          child: SleepChart(),
        ),
      ),
    );
  }
}
