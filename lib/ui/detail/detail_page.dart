import 'dart:math';
import 'package:flutter/material.dart';
import 'package:levels/model/profiles.dart';
import 'package:levels/services/firebase_service.dart';
import 'package:levels/ui/common/profile_summary.dart';
import 'package:levels/ui/common/separator.dart';
import 'package:fl_animated_linechart/chart/area_line_chart.dart';
import 'package:fl_animated_linechart/common/pair.dart';
import 'package:fl_animated_linechart/fl_animated_linechart.dart';
import 'package:levels/ui/text_style.dart';

class DetailPage extends StatefulWidget {
  late final Profile profile;

  DetailPage({required this.profile, Key? key}) : super(key: key);

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  String dropdownValue = "One";
    bool notYet=false;
        void changeDay() async {
      FirestoreService fs = FirestoreService();

      Profile.hourLine = await fs.getDayHours(FirestoreService.gadget,
          FirestoreService.selectedDay, widget.profile.nname);
      setState(() {

        notYet=true;
      });
    }
@override
  void initState() {
    changeDay();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    // Map<DateTime, double> line1 = createLineHour();
    Map<DateTime, double> line1 = Profile.hourLine;

    LineChart chart;
    chart = AreaLineChart.fromDateTimeMaps(
        [line1], [Colors.red.shade900], ['#'],
        yAxisName: "Number",
        gradients: [Pair(Colors.yellow.shade400, Colors.red.shade700)]);



    return  Scaffold(
      body:  Container(
        constraints:  BoxConstraints.expand(),
        color:  Color(0xFF736AB7),
        child: Column(
          children: [
            Expanded(
              child:  Stack(
                children: <Widget>[
                  _getGradient(),
                  _getContent(),
                ],
              ),
            ),
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
                        line1.isNotEmpty
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
                            : Image.asset("assets/images/noData.png")
                            :
                            CircularProgressIndicator(),
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

  Container _getContent() {
    return  Container(
      child:  ListView(

        padding:  EdgeInsets.fromLTRB(0.0, 72.0, 0.0, 32.0),
        children: <Widget>[
           ProfileSummary(
            widget.profile,
            false,
            horizontal: false,
          ),
           Container(
            padding:  EdgeInsets.symmetric(horizontal: 32.0),
            child:  Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                
                 Separator(),
                 Text(widget.profile.description,
                    style: Style.commonTextStyle),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Container _getToolbar(BuildContext context) {
    return  Container(
      margin:  EdgeInsets.only(top: MediaQuery.of(context).padding.top),
      child:  BackButton(color: Colors.white),
    );
  }
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







// import 'dart:ffi';
// import 'dart:math';

// import 'package:flutter/material.dart';
// import 'package:levels/model/profiles.dart';
// import 'package:levels/services/firebase_service.dart';
// import 'package:levels/ui/common/profile_summary.dart';
// import 'package:levels/ui/common/separator.dart';
// import 'package:levels/ui/text_style.dart';

// import 'package:fl_animated_linechart/chart/area_line_chart.dart';
// import 'package:fl_animated_linechart/common/pair.dart';
// import 'package:fl_animated_linechart/fl_animated_linechart.dart';
// import 'package:flutter/material.dart';


// class DetailPage extends StatelessWidget {
//   late final  Profile profile;

//   DetailPage(this.profile);

//   @override
//   Widget build(BuildContext context) {
//     // Map<DateTime, double> line1 = createLineHour();
//     Map<DateTime, double> line1 = Profile.hourLine;
// String dropdownValue = 'One';
//     LineChart chart;
//       chart = AreaLineChart.fromDateTimeMaps(
//           [line1], [Colors.red.shade900], ['#'],

//           yAxisName: "Number",
          
          
//           gradients: [Pair(Colors.yellow.shade400, Colors.red.shade700)]);
    
   

//     return  Scaffold(
//       body:  Container(
//         constraints:  BoxConstraints.expand(),
//         color:  Color(0xFF736AB7),
//         child: Column(
//           children: [
//             Expanded(
//               child:  Stack (
//                 children: <Widget>[
//                   _getGradient(),
//                   _getContent(),
//                   //getToolbar(context),
                  
//                 ],
//               ),
//             ),
            
            
            
//             DropdownButton<String>(
//       value: dropdownValue,
//       icon: const Icon(Icons.arrow_downward),
//       elevation: 16,
//       style: const TextStyle(color: Colors.deepPurple),
//       underline: Container(
//         height: 2,
//         color: Colors.deepPurpleAccent,
//       ),
//       onChanged: (String? Value) {
//         setState(() {
//           dropdownValue = Value!;
//         });
//       },
//       items: <String>['One', 'Two', 'Free', 'Four']
//           .map<DropdownMenuItem<String>>((String value) {
//         return DropdownMenuItem<String>(
//           value: value,
//           child: Text(value),
//         );
//       }).toList(),
//     )

//             ,
//             Padding(
//               padding: const EdgeInsets.all(15.0),
//               child: Container(
//                 height: 300,
//                 width: MediaQuery.of(context).size.width,
//                 // color: Colors.white,
//                     child: AnimatedLineChart(
//                     chart,
                    
//                     key: UniqueKey(),
//                     gridColor: Colors.grey,
//                     textStyle: TextStyle(fontSize: 12, color: Colors.white),
//                     toolTipColor: Colors.grey,

//                   ), //Unique key to force animations
//                 ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }


//   Container _getGradient() {
//     return  Container(
//             margin:  EdgeInsets.only(top: 190.0),
//             height: 110.0,
//             decoration:  BoxDecoration(
//               gradient:  LinearGradient(
//                 colors: <Color>[
//                    Color(0x00736AB7),
//                    Color(0xFF736AB7)
//                 ],
//                 stops: [0.0, 0.9],
//                 begin: const FractionalOffset(0.0, 0.0),
//                 end: const FractionalOffset(0.0, 1.0),
//               ),
//             ),
//           );
//   }

//   Container _getContent() {
//     final _overviewTitle = "Overview".toUpperCase();
//     return  Container(
//             child:  ListView(
//               padding:  EdgeInsets.fromLTRB(0.0, 72.0, 0.0, 32.0),
//               children: <Widget>[
//                  ProfileSummary(profile,
//                 false,
//                   horizontal: false,
//                 ),
//                  Container(
//                   padding:  EdgeInsets.symmetric(horizontal: 32.0),
//                   child:  Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: <Widget>[
//                        Text(_overviewTitle,
//                         style: Style.headerTextStyle,),
//                        Separator(),
//                        Text(
//                           profile.description, style: Style.commonTextStyle),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//           );
//   }

//   Container _getToolbar(BuildContext context) {
//     return  Container(
//             margin:  EdgeInsets.only(
//                 top: MediaQuery
//                     .of(context)
//                     .padding
//                     .top),
//             child:  BackButton(color: Colors.white),
//           );
//   }
// }



//   Map<DateTime, double> createLineHour() {
//     Map<DateTime, double> data = {};
//     data[DateTime.parse("1969-07-20 01:00:00Z")] = Random().nextDouble();
//     data[DateTime.parse("1969-07-20 02:00:00Z")] = Random().nextDouble();
//     data[DateTime.parse("1969-07-20 03:00:00Z")] = Random().nextDouble();
//     data[DateTime.parse("1969-07-20 04:00:00Z")] = Random().nextDouble();
//     data[DateTime.parse("1969-07-20 05:00:00Z")] = Random().nextDouble();
//     data[DateTime.parse("1969-07-20 06:00:00Z")] = Random().nextDouble();
//     data[DateTime.parse("1969-07-20 07:00:00Z")] = Random().nextDouble();
//     data[DateTime.parse("1969-07-20 08:00:00Z")] = Random().nextDouble();
//     data[DateTime.parse("1969-07-20 09:00:00Z")] = Random().nextDouble();
//     data[DateTime.parse("1969-07-20 10:00:00Z")] = Random().nextDouble();
//     data[DateTime.parse("1969-07-20 11:00:00Z")] = Random().nextDouble();
//     data[DateTime.parse("1969-07-20 12:00:00Z")] = Random().nextDouble();
//     data[DateTime.parse("1969-07-20 13:00:00Z")] = Random().nextDouble();
//     data[DateTime.parse("1969-07-20 14:00:00Z")] = Random().nextDouble();
//     return data;
//   }

