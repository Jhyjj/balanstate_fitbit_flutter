import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:dio/dio.dart'; // or 'package:http/http.dart' for http package

class SleepChart extends StatefulWidget {
  @override
  _SleepChartState createState() => _SleepChartState();
}

class SleepLog {
  final int level;
  final DateTime dateTime;

  SleepLog({required this.level, required this.dateTime});

  factory SleepLog.fromJson(Map<String, dynamic> json) {
    final level = json['levels']['summary']['deep']['minutes'].toInt();
    final dateTime = DateTime.parse(json['startTime']);
    return SleepLog(level: level, dateTime: dateTime);
  }
}

class _SleepChartState extends State<SleepChart> {
  List<SleepLog> _sleepLogs = [];

  @override
  void initState() {
    super.initState();
    _fetchSleepLogs();
  }

  Future<void> _fetchSleepLogs() async {
    // Fetch sleep log data from the API
    final dio = Dio();
    final response = await dio.get(
      'https://api.fitbit.com/1.2/user/-/sleep/list.json?afterDate=2022-01-16&sort=asc&offset=0&limit=100',
      options: Options(
        headers: {
          'Authorization':
              'Bearer eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiIyMzk2OEwiLCJzdWIiOiJCMk1XMkoiLCJpc3MiOiJGaXRiaXQiLCJ0eXAiOiJhY2Nlc3NfdG9rZW4iLCJzY29wZXMiOiJyc29jIHJlY2cgcnNldCByb3h5IHJwcm8gcm51dCByc2xlIHJjZiByYWN0IHJsb2MgcnJlcyByd2VpIHJociBydGVtIiwiZXhwIjoxNjc2OTk3OTMxLCJpYXQiOjE2NzY5NjkxMzF9.qs5uYnrg2sdC914f6UsS2gVYl_lPh-9_jHP6O2fRZq0'
        },
      ),
    );

    // Parse sleep log data into a list of SleepLog objects
    final List<dynamic> sleepData = response.data['sleep'];
    _sleepLogs = sleepData.map((data) => SleepLog.fromJson(data)).toList();

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Sleep Pattern')),
      body: _sleepLogs.isNotEmpty
          ? BarChart(
              BarChartData(
                barGroups: _sleepLogs
                    .map((data) => BarChartGroupData(
                          x: data.dateTime.millisecondsSinceEpoch.toInt(),
                          barRods: [
                            BarChartRodData(
                              y: data.level.toDouble(),
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
                      return value.toInt().toString();
                    },
                  ),
                  bottomTitles: SideTitles(
                    showTitles: true,
                    getTitles: (value) {
                      final time =
                          DateTime.fromMillisecondsSinceEpoch(value.toInt());
                      return '${time.hour}:${time.minute}';
                    },
                  ),
                ),
              ),
            )
          : Center(child: CircularProgressIndicator()),
    );
  }
}
