import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:dio/dio.dart';
import 'package:intl/intl.dart';

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

class SleepChart extends StatefulWidget {
  @override
  _SleepChartState createState() => _SleepChartState();
}

class _SleepChartState extends State<SleepChart> {
  List<SleepLog> _sleepLogs = [];

  @override
  void initState() {
    super.initState();
    _fetchSleepLogs();
  }

  Future<void> _fetchSleepLogs() async {
    final dio = Dio();
    final response = await dio.get(
      'https://api.fitbit.com/1.2/user/-/sleep/date/${DateFormat('yyyy-MM-dd').format(DateTime.now())}.json',
      options: Options(
        headers: {
          'Authorization':
              'Bearer eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiIyMzk2OEwiLCJzdWIiOiJCMk1XMkoiLCJpc3MiOiJGaXRiaXQiLCJ0eXAiOiJhY2Nlc3NfdG9rZW4iLCJzY29wZXMiOiJyc29jIHJlY2cgcnNldCByb3h5IHJudXQgcnBybyByc2xlIHJjZiByYWN0IHJyZXMgcmxvYyByd2VpIHJociBydGVtIiwiZXhwIjoxNjc3MDUzMzkxLCJpYXQiOjE2NzcwMjQ1OTF9.NFJdDL4xrZuja0zYNGqSzRT_HGu3Awkxv9nI47BYNCE',
        },
      ),
    );
    final sleepData = response.data['sleep'][0]['levels']['data'];
    _sleepLogs = sleepData.map((data) => SleepLog.fromJson(data)).toList();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return LineChart(
      LineChartData(
        minX: _sleepLogs.first.dateTime.millisecondsSinceEpoch.toDouble(),
        maxX: _sleepLogs.last.dateTime.millisecondsSinceEpoch.toDouble(),
        minY: 0,
        maxY: 5,
        titlesData: FlTitlesData(
          leftTitles: SideTitles(
            showTitles: true,
            getTitles: (value) {
              switch (value.toInt()) {
                case 0:
                  return 'None';
                case 1:
                  return 'Deep';
                case 2:
                  return 'Light';
                case 3:
                  return 'Rem';
                case 4:
                  return 'Wake';
                default:
                  return '';
              }
            },
          ),
          bottomTitles: SideTitles(
            showTitles: true,
            reservedSize: 22,
            getTitles: (value) {
              DateTime dateTime =
                  DateTime.fromMillisecondsSinceEpoch(value.toInt());
              return '${dateTime.hour}:${dateTime.minute}';
            },
          ),
        ),
        lineBarsData: [
          LineChartBarData(
            spots: _sleepLogs
                .map((data) => FlSpot(
                    data.dateTime.millisecondsSinceEpoch.toDouble(),
                    data.level.toDouble()))
                .toList(),
            isCurved: true,
            colors: [Colors.blue],
            barWidth: 2,
            belowBarData: BarAreaData(
              show: true,
              colors: [Colors.blue.withOpacity(0.2)],
            ),
          ),
        ],
      ),
    );
  }
}
