import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:fl_chart/fl_chart.dart';

class SleepData {
  final DateTime dateTime;
  final int level;

  SleepData(this.dateTime, this.level);
}

class SleepPatternChart extends StatefulWidget {
  final String startDate;
  final String endDate;

  SleepPatternChart({required this.startDate, required this.endDate});

  @override
  _SleepPatternChartState createState() => _SleepPatternChartState();
}

class _SleepPatternChartState extends State<SleepPatternChart> {
  List<SleepData> _sleepData = [];

  @override
  void initState() {
    super.initState();
    _getSleepData();
  }

  Future<void> _getSleepData() async {
    final response = await http.get(
      Uri.parse(
          'https://api.fitbit.com/1.2/user/-/sleep/list.json?beforeDate=${widget.endDate}&afterDate=${widget.startDate}'),
      headers: {
        'Authorization':
            'Bearer eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiIyMzk2OEwiLCJzdWIiOiJCMk1XMkoiLCJpc3MiOiJGaXRiaXQiLCJ0eXAiOiJhY2Nlc3NfdG9rZW4iLCJzY29wZXMiOiJyc29jIHJlY2cgcnNldCByb3h5IHJudXQgcnBybyByc2xlIHJjZiByYWN0IHJsb2MgcnJlcyByd2VpIHJociBydGVtIiwiZXhwIjoxNjc2OTY2NjY1LCJpYXQiOjE2NzY5Mzc4NjV9.neeVOm4qvJWzMYj1eQEqgiFoeHeRBWdx9x8fUv7K4lE'
      },
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body)['sleep'];
      for (final sleep in data) {
        final startTime = DateTime.parse(sleep['startTime']);
        final levels = sleep['levels']['data'];
        for (final level in levels) {
          final dateTime = startTime.add(Duration(seconds: level['seconds']));
          _sleepData.add(SleepData(dateTime, _getSleepLevel(level['level'])));
        }
      }
    } else {
      print('Failed to get sleep data: ${response.statusCode}');
    }
  }

  int _getSleepLevel(String level) {
    switch (level) {
      case 'wake':
        return 0;
      case 'light':
        return 1;
      case 'deep':
        return 2;
      case 'rem':
        return 3;
      default:
        return -1;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sleep Pattern'),
      ),
      body: _sleepData.isNotEmpty
          ? BarChart(
              BarChartData(
                barGroups: _sleepData
                    .map((data) => BarChartGroupData(
                          x: data.level,
                          barRods: [
                            BarChartRodData(
                              y: data.dateTime.millisecondsSinceEpoch
                                  .toDouble(),
                              width: 16,
                              colors: [Colors.blue],
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ],
                        ))
                    .toList(),
                borderData: FlBorderData(show: false),
                titlesData: FlTitlesData(
                  leftTitles: SideTitles(
                    showTitles: true,
                    getTitles: (value) {
                      final time =
                          DateTime.fromMillisecondsSinceEpoch(value.toInt());
                      return '${time.hour}:${time.minute}';
                    },
                  ),
                  bottomTitles: SideTitles(
                    showTitles: true,
                    getTitles: (value) {
                      return _sleepData[value.toInt()].level.toString();
                    },
                  ),
                ),
              ),
            )
          : Container(),
    );
  }
}
