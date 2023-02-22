import 'package:flutter/material.dart';
import 'package:sleeplevels/date.dart';
import 'sleep3_line_copy.dart';
// import 'sleep3_rev.dart';
import 'package:intl/intl.dart';

// import 'sleep4_line.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  DateTime selected = DateTime.utc(DateTime.now().year,DateTime.now().month,DateTime.now().day);
  //DateFormat formatter = DateFormat('yyyy-MM-dd');


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sleep Chart',
      home: Scaffold(
        appBar: AppBar(
          title: Text('Sleep Chart'),
        ),
        body: Column(
          children: [
            SizedBox(
              height: 50,
                child:  Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(onPressed: (){
                      setState(() {
                        DateTime prevDate = selected.subtract(Duration(days: 1));
                        selected = prevDate;
                      });
                    }, icon: Icon(Icons.arrow_back)),
                    Text(
                      selected.toString(),
                      style: TextStyle(
                        fontSize: 18,
                      ) ,),
                    IconButton(onPressed: (){
                      setState(() {
                        DateTime nextDate = selected.add(Duration(days: 1));
                        selected = nextDate;
                      });
                    }, icon: Icon(Icons.arrow_forward))
                  ],
                ),
            ),
            Expanded(child: SleepChart(
                selectedDate: selected
            )),
          ],
        ),
      ),
    );
  }
}
