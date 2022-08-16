import 'dart:math';
import 'package:flutter/material.dart';
import 'package:Aerobotix/model/profiles.dart';
import 'package:Aerobotix/services/firebase_service.dart';
import 'package:Aerobotix/ui/common/profile_summary.dart';
import 'package:Aerobotix/ui/common/separator.dart';
import 'package:fl_animated_linechart/chart/area_line_chart.dart';
import 'package:fl_animated_linechart/common/pair.dart';
import 'package:fl_animated_linechart/fl_animated_linechart.dart';
import 'package:Aerobotix/ui/text_style.dart';

class HourlyPage extends StatefulWidget {
  static const id = 'HourlyPage';

  HourlyPage({Key? key}) : super(key: key);

  @override
  State<HourlyPage> createState() => _HourlyPageState();
}

class _HourlyPageState extends State<HourlyPage> {
  String dropdownValue = "One";

  @override
  Widget build(BuildContext context) {
    // Map<DateTime, double> line1 = createLineHour();
    Map<DateTime, double> line1 = Profile.hourLine;

    LineChart chart;
    chart = AreaLineChart.fromDateTimeMaps(
        [line1], [Colors.red.shade900], ['#'],
        yAxisName: "Number",
        gradients: [Pair(Colors.yellow.shade400, Colors.red.shade700)]);

    void changeDay() async {
      FirestoreService fs = FirestoreService();

      Profile.hourLine = await fs.getDayHours(FirestoreService.gadget,
          FirestoreService.selectedDay, "total_persons");
      setState(() {});
    }

    return  Scaffold(
      body:  Container(
        constraints:  BoxConstraints.expand(),
        color:  Color(0xFF736AB7),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
           
            DropdownButton<String>(
              value: FirestoreService.selectedDay,
              icon: const Icon(Icons.arrow_downward),
              elevation: 16,
              style: const TextStyle(color: Colors.deepPurple),
              underline: Container(
                height: 2,
                color: Colors.deepPurpleAccent,
              ),
              onChanged: (String? Value) {
                print(Value);
                FirestoreService.selectedDay = Value!;
                changeDay();
              },
              items: FirestoreService.days
                  .map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
           Profile.hourLine.isNotEmpty ? Padding(
              padding: const EdgeInsets.all(15.0),
              child: Container(
                height: 300,
                width: MediaQuery.of(context).size.width,
                // color: Colors.white,
                child: AnimatedLineChart(
                  chart,
                  key: UniqueKey(),
                  gridColor: Colors.grey,
                  textStyle: TextStyle(fontSize: 12, color: Colors.white),
                  toolTipColor: Colors.grey,
                ), //Unique key to force animations
              ),
            ):
            Image.asset("assets/images/noDate.jpg"),
          ],
        ),
      ),
    );
  }

  Container _getGradient() {
    return  Container(
      margin:  EdgeInsets.only(top: 190.0),
      height: 110.0,
      decoration:  BoxDecoration(
        gradient:  LinearGradient(
          colors: <Color>[ Color(0x00736AB7),  Color(0xFF736AB7)],
          stops: [0.0, 0.9],
          begin: const FractionalOffset(0.0, 0.0),
          end: const FractionalOffset(0.0, 1.0),
        ),
      ),
    );
  }

  
Map<DateTime, double> createLineHour() {
  Map<DateTime, double> data = {};
  data[DateTime.parse("1969-07-20 01:00:00Z")] = Random().nextDouble();
  data[DateTime.parse("1969-07-20 02:00:00Z")] = Random().nextDouble();
  data[DateTime.parse("1969-07-20 03:00:00Z")] = Random().nextDouble();
  data[DateTime.parse("1969-07-20 04:00:00Z")] = Random().nextDouble();
  data[DateTime.parse("1969-07-20 05:00:00Z")] = Random().nextDouble();
  data[DateTime.parse("1969-07-20 06:00:00Z")] = Random().nextDouble();
  data[DateTime.parse("1969-07-20 07:00:00Z")] = Random().nextDouble();
  data[DateTime.parse("1969-07-20 08:00:00Z")] = Random().nextDouble();
  data[DateTime.parse("1969-07-20 09:00:00Z")] = Random().nextDouble();
  data[DateTime.parse("1969-07-20 10:00:00Z")] = Random().nextDouble();
  data[DateTime.parse("1969-07-20 11:00:00Z")] = Random().nextDouble();
  data[DateTime.parse("1969-07-20 12:00:00Z")] = Random().nextDouble();
  data[DateTime.parse("1969-07-20 13:00:00Z")] = Random().nextDouble();
  data[DateTime.parse("1969-07-20 14:00:00Z")] = Random().nextDouble();
  return data;
}

}