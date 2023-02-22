// import 'package:fl_chart/fl_chart.dart';
// import 'package:flutter/material.dart';
// import 'package:dio/dio.dart';
//
//
// class SleepData {
//   final DateTime dateTime;
//   final int level;
//
//   SleepData(this.dateTime, this.level);
// }
//
// class SleepChart extends StatefulWidget {
//   @override
//   _SleepChartState createState() => _SleepChartState();
// }
//
// class _SleepChartState extends State<SleepChart> {
//   List<SleepData> _sleepData = [];
//
//   @override
//   void initState() {
//     super.initState();
//     _fetchSleepData();
//   }
//
//   Future<void> _fetchSleepData() async {
//     // TODO: Replace with your own Fitbit API code to fetch sleep data
//     // and set _sleepData variable with the response
//     try {
//       final dio = Dio();
//       final response = await dio.get(
//         'https://api.fitbit.com/1.2/user/-/sleep/list.json?afterDate=2022-01-16&sort=asc&offset=0&limit=100',
//         options: Options(headers: {
//           'Authorization': 'Bearer eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiIyMzk2OEwiLCJzdWIiOiJCMk1XMkoiLCJpc3MiOiJGaXRiaXQiLCJ0eXAiOiJhY2Nlc3NfdG9rZW4iLCJzY29wZXMiOiJyc29jIHJlY2cgcnNldCByb3h5IHJudXQgcnBybyByc2xlIHJjZiByYWN0IHJsb2MgcnJlcyByd2VpIHJociBydGVtIiwiZXhwIjoxNjc2OTY2NjY1LCJpYXQiOjE2NzY5Mzc4NjV9.neeVOm4qvJWzMYj1eQEqgiFoeHeRBWdx9x8fUv7K4lE'
//           ,
//         }),
//       );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Sleep Pattern'),
//       ),
//       body: _sleepData.isNotEmpty
//           ? BarChart(
//           BarChartData(
//           barGroups: _sleepData
//           .map((data) => BarChartGroupData(
//       x: data.level,
//       barRods: [
//         BarChartRodData(
//           y: data.dateTime.millisecondsSinceEpoch.toDouble(),
//           width: 16,
//           colors: [Colors.blue],
//           borderRadius: BorderRadius.circular(8),
//         ),
//       ],
//     ))
//         .toList(),
//     borderData: FlBorderData(show: false),
//     titlesData: FlTitlesData(
//     leftTitles: SideTitles(
//     showTitles: true,
//     getTitles: (value) {
//     final time = DateTime.fromMillisecondsSinceEpoch(value.toInt());
//     return '${time.hour}:${time.minute}';
//

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         appBar: AppBar(
//           title: Text('Sleep Pattern'),
//         ),
//         body: _sleepData.isNotEmpty
//             ? BarChart(
//           BarChartData(
//               barGroups: _sleepData
//                   .map((data) =>
//                   BarChartGroupData(
//                     x: data.level,
//                     barRods: [
//                       BarChartRodData(
//                         y: data.dateTime.millisecondsSinceEpoch.toDouble(),
//                         width: 16,
//                         colors: [Colors.blue],
//                         borderRadius: BorderRadius.circular(8),
//                       ),
//                     ],
//                   ))
//                   .toList(),
//               borderData: FlBorderData(show: false),
//               titlesData: FlTitlesData(
//                   leftTitles: SideTitles(
//                     showTitles: true,
//                     getTitles: (value) {
//                       final time = DateTime.fromMillisecondsSinceEpoch(
//                           value.toInt());
//                       return '${time.hour}:${time.minute}';
//                     },
//                   ),
//                   bottomTitles: SideTitles(
//                     showTitles: true,
//                     getTitles: (value) {
//                       return _sleepData[value.toInt()].level.toString();
//                     },
//                   ),
//               ),
//           ),
//         )
//     );
//   }
// }
