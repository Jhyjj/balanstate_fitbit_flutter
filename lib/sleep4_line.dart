import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:dio/dio.dart';
import 'package:intl/intl.dart';

class SleepLog {
  final DateTime dateTime;
  final int level;

  SleepLog({required this.level, required this.dateTime});


  factory SleepLog.fromJson(Map<String, dynamic> json) {

    final level = int.tryParse(json['level']);
    print("level은 ${level}");
    final dateTime = DateTime.parse(json['dateTime']);
    if (level == null) {
      throw FormatException('Invalid level: ${json['level']}');
    }
    return SleepLog(dateTime: dateTime, level: level);
  }
}

class SleepChart extends StatefulWidget {
  @override
  _SleepChartState createState() => _SleepChartState();
}

class _SleepChartState extends State<SleepChart> {
  Future<List<SleepLog>>? _sleepLogsFuture;

  @override
  void initState() {
    super.initState(); //딱 한번 실행됨
    print("initstate 실행");
    _sleepLogsFuture = _fetchSleepLogs();
  }

  Future<List<SleepLog>>? _fetchSleepLogs() async {
    try {
      final dio = Dio();
      dio.options.headers['Authorization'] =
          'Bearer eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiIyMzk2OEwiLCJzdWIiOiJCMk1XMkoiLCJpc3MiOiJGaXRiaXQiLCJ0eXAiOiJhY2Nlc3NfdG9rZW4iLCJzY29wZXMiOiJyc29jIHJlY2cgcnNldCByb3h5IHJudXQgcnBybyByc2xlIHJjZiByYWN0IHJyZXMgcmxvYyByd2VpIHJociBydGVtIiwiZXhwIjoxNjc3MDUzMzkxLCJpYXQiOjE2NzcwMjQ1OTF9.NFJdDL4xrZuja0zYNGqSzRT_HGu3Awkxv9nI47BYNCE';
      final response = await dio.get(
        'https://api.fitbit.com/1.2/user/-/sleep/list.json?beforeDate=${DateFormat('yyyy-MM-dd').format(DateTime.now())}&sort=desc&offset=0&limit=7',
      );

      final List<dynamic> sleepData =
          response.data['sleep'][0]['levels']['data'];
      _sleepLogsFuture = sleepData.map((data) => SleepLog.fromJson(data)).toList();
      print("sleepLogs는 ${_sleepLogsFuture}");

      setState(() {});
    } catch (e) {
      print(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<SleepLog>>(
      future: _sleepLogsFuture,
      builder: (context, snapshot){
        if(snapshot.connectionState == ConnectionState.waiting){
          return CircularProgressIndicator();
        }else if(snapshot.hasData){
          final data = snapshot.data!.map((sleepLog){
            return FlSpot(sleepLog.dateTime.millisecondsSinceEpoch.toDouble(),
                sleepLog.level.toDouble());
          }).toList();
          return LineChart(
            LineChartData(
              minX: _sleepLogsFuture.isEmpty ? 0 : data.first.x,
              maxX: _sleepLogsFuture.isEmpty ? 0 : data.last.x,
              minY: 0,
              maxY: 5,
              titlesData: FlTitlesData(
                leftTitles: SideTitles(
                  showTitles: true,
                  getTitles: (value) {
                    switch (value.toInt()) {
                      case 0:
                        return 'none';
                      case 1:
                        return 'deep';
                      case 2:
                        return 'light';
                      case 3:
                        return 'rem';
                      case 4:
                        return 'wake';
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
                    return '${dateTime.day}/${dateTime.month}';
                  },
                ),
              ),
              lineBarsData: [
                LineChartBarData(
                  spots: data
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
        }else if(snapshot.hasError) {
          return Text('Error : ${snapshot.error}')
        }else{
          return Text('No data available');
        }
      }
    );
    }
  }

