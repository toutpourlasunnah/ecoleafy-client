import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:web_socket_channel/io.dart';

class DashboardTab extends StatefulWidget {
  const DashboardTab({super.key});

  @override
  State<DashboardTab> createState() => _DashboardTabState();
}

class _DashboardTabState extends State<DashboardTab> {
  late WebSocketChannel channel;
  late WebSocketChannel channelEvents;

  List<double> temperatureData = [];
  List<double> humidityData = [];
  List<Text> eventList = [];

  @override
  void initState() {
    super.initState();
    channel = WebSocketChannel.connect(Uri.parse("ws://localhost:8181/ws/app"));
    channelEvents =
        WebSocketChannel.connect(Uri.parse("ws://localhost:8181/ws/app"));

    channelEvents.sink.add(jsonEncode({"room_history": "room1"}));

    channel.sink.add(jsonEncode({"room_history": "room1"}));

    channel.stream.listen(
      (dynamic message) {
        final Map<String, dynamic> messageJson = jsonDecode(message);
        // final List<dynamic> values = messageJson['values'];

        setState(() {
          if (temperatureData.length > 25)
            temperatureData.removeAt(temperatureData.length - 1);
          temperatureData.insert(0, messageJson['temperature'].toDouble());

          if (humidityData.length > 25)
            humidityData.removeAt(humidityData.length - 1);
          humidityData.insert(0, messageJson['humidity'].toDouble());
        });
      },
      onError: (error) => print(error),
    );

    channel.sink.add(jsonEncode({"room": "room1"}));
    channelEvents.sink.add(jsonEncode({"room": "room1"}));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color.fromARGB(235, 218, 218, 218),
      child: GridView.count(
        crossAxisCount: 2,
        crossAxisSpacing: 0,
        childAspectRatio: (16 / 9),
        children: [
          Center(
            child: AspectRatio(
              aspectRatio: 16 / 9,
              child: Container(
                padding: const EdgeInsets.all(10),
                margin: const EdgeInsets.only(
                    left: 10.0, right: 10, top: 50, bottom: 50),
                decoration: BoxDecoration(
                    color: Colors.blueGrey[50],
                    // border: Border.all(
                    //   color: Colors.redAccent,
                    // ),
                    borderRadius: BorderRadius.all(Radius.circular(5))),
                child: LineChart(
                  swapAnimationDuration:
                      Duration(milliseconds: 100), // Optional
                  swapAnimationCurve: Curves.decelerate,
                  LineChartData(
                    titlesData: FlTitlesData(
                      topTitles:
                          AxisTitles(axisNameWidget: Text("Temperature")),
                      bottomTitles: AxisTitles(axisNameWidget: Text("Time")),
                      leftTitles:
                          AxisTitles(axisNameWidget: Text("Degrees (°C)")),
                    ),
                    borderData: FlBorderData(
                      show: true,
                      border: Border.all(
                          color: const Color(0xff37434d),
                          width: 2,
                          style: BorderStyle.solid),
                    ),
                    gridData: FlGridData(
                      verticalInterval: 10,
                      show: true,
                      drawVerticalLine: true,
                      getDrawingHorizontalLine: (value) {
                        return FlLine(
                          color: const Color(0xff37434d),
                          strokeWidth: 1,
                        );
                      },
                      getDrawingVerticalLine: (value) {
                        return FlLine(
                          color: const Color(0xff37434d),
                          strokeWidth: 1,
                        );
                      },
                    ),
                    maxY: temperatureData.reduce(max) + 1,
                    minY: temperatureData.reduce(min) - 1,
                    // maxX: 20,
                    // minX: 0,
                    lineBarsData: [
                      LineChartBarData(
                        color: Colors.red,
                        belowBarData: BarAreaData(
                          show: true,
                          gradient: LinearGradient(
                            colors: [
                              ColorTween(begin: Colors.red, end: Colors.red)
                                  .lerp(0.2)!,
                              ColorTween(begin: Colors.blue, end: Colors.green)
                                  .lerp(0.2)!,
                            ],
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                          ),
                        ),
                        spots: convertToSpots(temperatureData),
                        isStrokeCapRound: true,
                        isCurved: true,
                        barWidth: 5,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          Center(
            child: AspectRatio(
              aspectRatio: 16 / 9,
              child: Container(
                padding: const EdgeInsets.all(10),
                margin: const EdgeInsets.only(
                    left: 10.0, right: 10, top: 50, bottom: 50),
                decoration: BoxDecoration(
                    color: Colors.blueGrey[50],
                    // border: Border.all(
                    //   color: Colors.redAccent,
                    // ),
                    borderRadius: BorderRadius.all(Radius.circular(5))),
                child: LineChart(
                  swapAnimationDuration:
                      Duration(milliseconds: 100), // Optional
                  swapAnimationCurve: Curves.decelerate,
                  LineChartData(
                    titlesData: FlTitlesData(
                      topTitles: AxisTitles(axisNameWidget: Text("Humidity")),
                      bottomTitles: AxisTitles(axisNameWidget: Text("Time")),
                      leftTitles:
                          AxisTitles(axisNameWidget: Text("Percentage (%)")),
                    ),
                    borderData: FlBorderData(
                      show: true,
                      border: Border.all(
                          color: const Color(0xff37434d),
                          width: 2,
                          style: BorderStyle.solid),
                    ),
                    gridData: FlGridData(
                      verticalInterval: 10,
                      show: true,
                      drawVerticalLine: true,
                      getDrawingHorizontalLine: (value) {
                        return FlLine(
                          color: const Color(0xff37434d),
                          strokeWidth: 1,
                        );
                      },
                      getDrawingVerticalLine: (value) {
                        return FlLine(
                          color: const Color(0xff37434d),
                          strokeWidth: 1,
                        );
                      },
                    ),
                    maxY: humidityData.reduce(max) + 1,
                    minY: humidityData.reduce(min) - 1,
                    // maxX: 20,
                    // minX: 0,
                    lineBarsData: [
                      LineChartBarData(
                        color: Colors.red,
                        belowBarData: BarAreaData(
                          show: true,
                          gradient: LinearGradient(
                            colors: [
                              ColorTween(
                                      begin: Colors.blue[900],
                                      end: Colors.blue[900])
                                  .lerp(0.2)!,
                              ColorTween(
                                      begin: Colors.blue[100],
                                      end: Colors.blue[100])
                                  .lerp(0.2)!,
                            ],
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                          ),
                        ),
                        spots: convertToSpots(humidityData),
                        isStrokeCapRound: true,
                        isCurved: true,
                        barWidth: 5,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: Container(
              child: Column(
                children: [
                  Text("Recent Events :"),
                  StreamBuilder(
                    stream: channelEvents.stream,
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        final Map<String, dynamic> messageJson =
                            jsonDecode(snapshot.data);
                        if (messageJson['presence']) {
                          eventList.add(Text(
                              "Presence detected in " + messageJson['room']));
                          return new Row(
                          children: eventList,
                        );
                        }
                        eventList.add(Text("No presence detected"));
                        return new Row(
                          children: eventList,
                        );
                      } else {
                        return Text("No data received yet");
                      }
                    },
                  ),
                ],
              ),
              // child: StreamBuilder(
              //   stream: channel.stream,
              //   builder: (context, snapshot) {
              //     if (snapshot.hasData) {
              //       return Text("snapshot.data");
              //     } else {
              //       return Text("No data received yet");
              //     }
              //   },
              // ),
            ),
          ),
        ],
      ),
    );
  }
}

// temperatureData.map((e) =>
//                             FlSpot(temperatureData.indexOf(e).toDouble(), e))
//                         .toList(),

//
List<FlSpot> convertToSpots(List sensorData) {
  List<FlSpot> temperatureSpots = [];
  for (var i = 0; i < sensorData.length; i++) {
    temperatureSpots.add(FlSpot(i.toDouble(), sensorData[i]));
  }
  return temperatureSpots;
}
