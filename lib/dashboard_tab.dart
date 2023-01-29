import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class DashboardTab extends StatefulWidget {
  const DashboardTab({super.key});

  @override
  State<DashboardTab> createState() => _DashboardTabState();
}

class _DashboardTabState extends State<DashboardTab> {
  List<FlSpot> dataTemp = [];
  List<FlSpot> dataHumidity = [];

  @override
  void initState() {
    final channel = WebSocketChannel.connect(
      Uri.parse("ws://192.168.172.222:8181/ws/app"),
    );
    super.initState();
    channel.stream.listen((data) {
      final jsonData = jsonDecode(data);
      setState(() {
        dataTemp.add(FlSpot(
            DateTime.parse(jsonData['timeTaken'])
                .millisecondsSinceEpoch
                .toDouble(),
            jsonData['humidity']));
        dataTemp.add(FlSpot(
            DateTime.parse(jsonData['timeTaken'])
                .millisecondsSinceEpoch
                .toDouble(),
            jsonData['humidity']));
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: GridView.count(
        crossAxisCount: 2,
        children: [
          Container(
            padding: EdgeInsets.all(10),
            child: LineChart(
              LineChartData(
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: true,
                  horizontalInterval: 1,
                  verticalInterval: 1,
                  getDrawingHorizontalLine: (value) {
                    return FlLine(
                      color: Colors.amber,
                      strokeWidth: 1,
                    );
                  },
                  getDrawingVerticalLine: (value) {
                    return FlLine(
                      color: Colors.amber,
                      strokeWidth: 1,
                    );
                  },
                ),
                lineBarsData: [
                  LineChartBarData(
                    belowBarData: BarAreaData(
                      show: true,
                      gradient: LinearGradient(
                        colors: [Colors.blue, Colors.green]
                            .map((color) => color.withOpacity(0.3))
                            .toList(),
                      ),
                    ),
                    gradient: LinearGradient(
                      colors: [Colors.blue, Colors.green],
                    ),
                    spots: [
                      for (var i = 0; i < dataTemp.length; i++)
                        FlSpot(dataTemp[i].x, dataTemp[i].y),
                    ],
                  ),
                ],
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.all(10),
            child: BarChart(
              BarChartData(
                barGroups: [
                  BarChartGroupData(
                    x: 0,
                    barsSpace: 4,
                    barRods: [
                      BarChartRodData(
                        toY: 10,
                        color: Colors.blue,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: Center(
              child: Text("Sennoune"),
            ),
          ),
        ],
      ),
    );
  }
}
