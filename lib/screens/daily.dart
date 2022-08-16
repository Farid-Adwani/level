import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_toggle_tab/flutter_toggle_tab.dart';
import 'package:Aerobotix/model/profiles.dart';
import 'package:Aerobotix/services/firebase_service.dart';
import 'package:Aerobotix/ui/common/profile_summary.dart';
import 'package:Aerobotix/ui/common/separator.dart';
import 'package:fl_animated_linechart/chart/area_line_chart.dart';
import 'package:fl_animated_linechart/common/pair.dart';
import 'package:fl_animated_linechart/fl_animated_linechart.dart';
import 'package:Aerobotix/ui/text_style.dart';

class DailyPage extends StatefulWidget {
  static const id = 'DailyPage';

  DailyPage({Key? key}) : super(key: key);

  @override
  State<DailyPage> createState() => _DailyPageState();
}

class _DailyPageState extends State<DailyPage> {
  var _listTextTabToggle = ["Per Month", "Per Day"];
  int _tabTextIndexSelected = 0;
    bool notYet=false;

  void changeDay() async {
    FirestoreService fs = FirestoreService();

    Profile.hourLine = await fs.getDayHours(
        FirestoreService.gadget, FirestoreService.selectedDay, "total_persons");
    setState(() {});
  }
void changeMonth() async {
      FirestoreService fs = FirestoreService();

      Profile.hourLine = await fs.getDaysMonth(
          FirestoreService.gadget, FirestoreService.selectedMonth);
      setState(() {
notYet=true;

      });
    }
@override
  void initState() {
    changeMonth();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    // Map<DateTime, double> line1 = createLineHour();
    Map<DateTime, double> line1 = Profile.hourLine;

    LineChart chart;
    chart = AreaLineChart.fromDateTimeMaps(
        [line1], [Colors.red.shade900], ['#'],
        yAxisName: "Number of People",
        gradients: [Pair(Colors.yellow.shade400, Colors.red.shade700)]);

    

    void selectedMonthButton() async {
      FirestoreService fs = FirestoreService();

      Profile.hourLine = await fs.getDaysMonth(
          FirestoreService.gadget, FirestoreService.selectedMonth);
      line1 = Profile.hourLine;
      setState(() {
        
      });
    }

    void selectDayButton() async {
      print("waaaaaaaaaaaaaa");
      FirestoreService fs = FirestoreService();
      FirestoreService.days = await fs.getDays(FirestoreService.gadget);
      print(FirestoreService.days);
      FirestoreService.selectedDay =
          FirestoreService.days[FirestoreService.days.length - 1];
      Profile.hourLine = await fs.getDayHours(
          FirestoreService.gadget,
          FirestoreService.days[FirestoreService.days.length - 1],
          "total_persons");
      line1 = Profile.hourLine;
       setState(() {
        
      });
    }

    return Scaffold(
      body: Container(
          constraints: BoxConstraints.expand(),
          color: Color(0xFF736AB7),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              FlutterToggleTab(
                isShadowEnable: true,
                width: 90,
                borderRadius: 30,
                height: 50,
                selectedIndex: _tabTextIndexSelected,
                selectedBackgroundColors: [Colors.blue, Colors.blueAccent],
                selectedTextStyle: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w700),
                unSelectedTextStyle: TextStyle(
                    color: Colors.black87,
                    fontSize: 14,
                    fontWeight: FontWeight.w500),
                labels: _listTextTabToggle,
                selectedLabelIndex: (index) {
                  _tabTextIndexSelected = index;
                    if (index == 0) {
                      selectedMonthButton();
                    } else {
                      selectDayButton();
                    }
                },
                isScroll: false,
              ),
              _tabTextIndexSelected == 0
                  ? Column(

                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Here default theme colors are used for activeBgColor, activeFgColor, inactiveBgColor and inactiveFgColor

                        DropdownButton<String>(
                          value: FirestoreService.selectedMonthName,
                          icon: const Icon(Icons.arrow_downward),
                          elevation: 16,
                          style: const TextStyle(color: Colors.deepPurple),
                          underline: Container(
                            height: 2,
                            color: Colors.deepPurpleAccent,
                          ),
                          onChanged: (String? Value) {
                            print(Value);
                            String nbMonth = "01";
                            switch (Value) {
                              case 'January':
                                nbMonth = "01";
                                break;
                              case 'February':
                                nbMonth = "02";
                                break;
                              case 'March':
                                nbMonth = "03";
                                break;
                              case 'April':
                                nbMonth = "04";
                                break;
                              case 'May':
                                nbMonth = "05";
                                break;
                              case 'June':
                                nbMonth = "06";
                                break;
                              case 'July':
                                nbMonth = "07";
                                break;
                              case 'August':
                                nbMonth = "08";
                                break;
                              case 'September':
                                nbMonth = "09";
                                break;
                              case 'October':
                                nbMonth = "10";
                                break;
                              case 'November':
                                nbMonth = "11";
                                break;
                              case 'December':
                                nbMonth = "12";
                                break;
                            }
                            FirestoreService.selectedMonth = nbMonth;
                            FirestoreService.selectedMonthName = Value!;

                            changeMonth();
                          },
                          items: <String>[
                            'January',
                            'February',
                            'March',
                            'April',
                            'May',
                            'June',
                            'July',
                            'August',
                            'September',
                            'October',
                            'November',
                            'December'
                          ].map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(
                                  value + " " + DateTime.now().year.toString()),
                            );
                          }).toList(),
                        ),
                        Profile.hourLine.isNotEmpty
                            ?
                        notYet==true?
                         Padding(
                                padding: const EdgeInsets.all(15.0),
                                child: Container(
                                  height: 300,
                                  width: MediaQuery.of(context).size.width,
                                  // color: Colors.white,
                                  child: AnimatedLineChart(
                                    chart,
                                    key: UniqueKey(),
                                    gridColor: Colors.grey,
                                    textStyle: TextStyle(
                                        fontSize: 12, color: Colors.white),
                                    toolTipColor: Colors.grey,
                                  ), //Unique key to force animations
                                ),
                              )
                            : CircularProgressIndicator():
                            Image.asset("assets/images/noData.png"),
                            
                      ],
                    )
                  : Column(
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
                        notYet==true?
                        Profile.hourLine.isNotEmpty
                            ? Padding(
                                padding: const EdgeInsets.all(15.0),
                                child: Container(
                                  height: 300,
                                  width: MediaQuery.of(context).size.width,
                                  // color: Colors.white,
                                  child: AnimatedLineChart(
                                    chart,
                                    key: UniqueKey(),
                                    gridColor: Colors.grey,
                                    textStyle: TextStyle(
                                        fontSize: 12, color: Colors.white),
                                    toolTipColor: Colors.grey,
                                  ), //Unique key to force animations
                                ),
                              )
                            : Image.asset("assets/images/noData.png"):
                            CircularProgressIndicator(),
                      ],
                    ),
            ],
          )),
    );
  }

  Container _getGradient() {
    return Container(
      margin: EdgeInsets.only(top: 190.0),
      height: 110.0,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: <Color>[Color(0x00736AB7), Color(0xFF736AB7)],
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
