import 'package:Aerobotix/HomeScreen/Aerobotix_app_theme.dart';
import 'package:Aerobotix/HomeScreen/ui_view/wave_view.dart';
import 'package:Aerobotix/model/member.dart';
import 'package:Aerobotix/services/firebase_service.dart';
import 'package:Aerobotix/ui/HexColor.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'dart:math' as math;



class MediterranesnDietView extends StatefulWidget {
  final AnimationController? animationController;
  final Animation<double>? animation;
Map<String,String> other;
int xp=0;
   MediterranesnDietView(
      {Key? key, this.animationController, this.animation,this.other=const {},required this.xp})
      : super(key: key);


  @override
  State<MediterranesnDietView> createState() => _MediterranesnDietViewState();
}

class _MediterranesnDietViewState extends State<MediterranesnDietView> {

String song="";
bool playing=false;
String levelText="";
String gif="";
Color colorLevel=Color.fromARGB(255,255,0,255);
void setGameLevel(){
  String toSwitch="";
  if(widget.other.isNotEmpty){
    toSwitch=widget.other["gameLevel"]!;
  }else{
    toSwitch=Member.gameLevel;
  }
  switch (toSwitch) {
    case "wlidha":
      print("wlidha");
      song="audio/wlidha.mp3";
      levelText='7arbi';
      gif="assets/HomeScreen/wlidha.gif";
      colorLevel=HexColor("973747");
      break;
      case "kassa7":

      song="audio/kassa7.mp3";
      levelText='Kassa7';
      gif="assets/HomeScreen/kassa7.gif";
colorLevel=HexColor("911E0E");
      break;
      case "r3ad":
      print("r3ad");
      song="audio/r3ad.mp3";
      levelText='R3ad';
      gif="assets/HomeScreen/r3ad.gif";
colorLevel=HexColor("E1CB53");

      break;
      case "jen":
      print("jen");
      song="audio/jen.mp3";
      levelText='Jen';
      gif="assets/HomeScreen/jen.gif";
colorLevel=HexColor("CA9FC8");

      break;
      case "3orsa":
      print("3orsa");
      song="audio/3orsa.mp3";
      levelText='3orsa';
      gif="assets/HomeScreen/3orsa.gif";
colorLevel=HexColor("#90F1FB");

      break;
    default:
    print("3asfour");
    	colorLevel=HexColor("BD8484");
      song="audio/3asfour.mp3";
      levelText='3asfour';
      gif="assets/HomeScreen/3asfour.gif";
  }
}
AudioPlayer player = AudioPlayer();
void playAudio() async{
  
await player.setVolume(1);
await player.setSourceAsset(song);

}

  
void fetch() async{
  await   FirestoreService.fetchUser(Member.phone).then((value) {
              setState(() {
                
              });
            });  
}
 void initState() {
   fetch();
playAudio();
super.initState();
 }



@override
  void dispose() async{
    super.dispose();
    await player.stop();
    
  }


  @override
  Widget build(BuildContext context) {
    setGameLevel();
    return AnimatedBuilder(
      animation: widget.animationController!,
      builder: (BuildContext context, Widget? child) {
        return FadeTransition(
          opacity: widget.animation!,
          child: new Transform(
            transform: new Matrix4.translationValues(
                0.0, 30 * (1.0 - widget.animation!.value), 0.0),
            child: Padding(
              padding: const EdgeInsets.only(
                  left: 24, right: 24, top: 0, bottom: 18),
              child: GestureDetector(
                onTap: () async {
                 if(playing==false)  {
                  playing=true;
                  await player.play(AssetSource(song));
                  
                 }else{
                  playing=false;
                  await player.stop();
                  
                  }
                },
                child: Container(
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage(gif),
                      fit: BoxFit.fill,
                    ),
                    color: AerobotixAppTheme.white,
                    borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(20.0),
                        bottomLeft: Radius.circular(20.0),
                        bottomRight: Radius.circular(20.0),
                        topRight: Radius.circular(20.0)),
                        
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                    
                      Column(
                        children: [
                          Stack(
  children: <Widget>[
    // Stroked text as border.
    Text(
      levelText,
      style: TextStyle(
        fontSize: 40,
        foreground: Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = 6
          ..color = colorLevel,
      ),
    ),
    // Solid text as fill.
    Text(
      levelText,
      style: TextStyle(
        fontSize: 40,
        color: Colors.grey[300],
      ),
    ),
  ],
),
                              // Text(
                              //   levelText,
                              //   textAlign: TextAlign.center,

                              //   style: TextStyle(
                              //     fontFamily: AerobotixAppTheme.fontName,
                              //     fontWeight: FontWeight.w600,
                              //     fontSize: 32,
                              //     color: colorLevel,

                              //   ),
                              // ),
                                   Padding(
                        padding:
                            const EdgeInsets.only(top: 16, left: 16, right: 16),
                        child: Row(
                          children: <Widget>[
                        Padding(
                              padding: const EdgeInsets.only(right: 16),
                              child: Center(
                                child: Stack(
                                  clipBehavior: Clip.none,
                                  children: <Widget>[
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Container(
                                        width: 100,
                                        height: 100,
                                        decoration: BoxDecoration(
                                          color: AerobotixAppTheme.white,
                                          borderRadius: BorderRadius.all(
                                            Radius.circular(100.0),
                                          ),
                                          border: new Border.all(
                                              width: 4,
                                              color: AerobotixAppTheme
                                                  .nearlyDarkBlue
                                                  .withOpacity(0.2)),
                                        ),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: <Widget>[
                                            Text(
                                             widget.other.isNotEmpty? (widget.xp*widget.animation!.value.toInt()).toString() : (widget.xp*widget.animation!.value).toInt().toString(),
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                fontFamily:
                                                    AerobotixAppTheme.fontName,
                                                fontWeight: FontWeight.normal,
                                                fontSize: 24,
                                                letterSpacing: 0.0,
                                                color:Colors.purple[900],
                                              ),
                                            ),
                                            Text(
                                              'XP',
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                fontFamily:
                                                    AerobotixAppTheme.fontName,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 12,
                                                letterSpacing: 0.0,
                                                color: AerobotixAppTheme.grey
                                                    .withOpacity(0.5),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(4.0),
                                      child: CustomPaint(
                                        painter: CurvePainter(
                                            colors: [
                                              colorLevel,
                                              HexColor("#8A98E8"),
                                              colorLevel
                                            ],
                                            angle: widget.xp*360/5000 +
                                                (360 - 140) *
                                                    (1.0 - widget.animation!.value)),
                                        child: SizedBox(
                                          width: 108,
                                          height: 108,
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    
                            
                             
                        ],
                      )
                    , 
                      Padding(
                          padding:
                              const EdgeInsets.only(left: 16, right: 8, top: 16),
                          child: Container(
                            width: 60,
                            height: 160,
                            decoration: BoxDecoration(
                              color: HexColor('#E8EDFE'),
                              borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(80.0),
                                  bottomLeft: Radius.circular(80.0),
                                  bottomRight: Radius.circular(80.0),
                                  topRight: Radius.circular(80.0)),
                              boxShadow: <BoxShadow>[
                                BoxShadow(
                                    color: AerobotixAppTheme.grey.withOpacity(0.4),
                                    offset: const Offset(2, 2),
                                    blurRadius: 4),
                              ],
                            ),
                            child: WaveView(
                              couleur: colorLevel,
                              percentageValue: widget.xp*100/5000,
              
                            ),
                          ),
                        )
              
                    
                      ,
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

}

class CurvePainter extends CustomPainter {
  final double? angle;
  final List<Color>? colors;

  CurvePainter({this.colors, this.angle = 140});

  @override
  void paint(Canvas canvas, Size size) {
    List<Color> colorsList = [];
    if (colors != null) {
      colorsList = colors ?? [];
    } else {
      colorsList.addAll([Colors.white, Colors.white]);
    }

    final shdowPaint = new Paint()
      ..color = Colors.black.withOpacity(0.4)
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke
      ..strokeWidth = 14;
    final shdowPaintCenter = new Offset(size.width / 2, size.height / 2);
    final shdowPaintRadius =
        math.min(size.width / 2, size.height / 2) - (14 / 2);
    canvas.drawArc(
        new Rect.fromCircle(center: shdowPaintCenter, radius: shdowPaintRadius),
        degreeToRadians(278),
        degreeToRadians(360 - (365 - angle!)),
        false,
        shdowPaint);

    shdowPaint.color = Colors.grey.withOpacity(0.3);
    shdowPaint.strokeWidth = 16;
    canvas.drawArc(
        new Rect.fromCircle(center: shdowPaintCenter, radius: shdowPaintRadius),
        degreeToRadians(278),
        degreeToRadians(360 - (365 - angle!)),
        false,
        shdowPaint);

    shdowPaint.color = Colors.grey.withOpacity(0.2);
    shdowPaint.strokeWidth = 20;
    canvas.drawArc(
        new Rect.fromCircle(center: shdowPaintCenter, radius: shdowPaintRadius),
        degreeToRadians(278),
        degreeToRadians(360 - (365 - angle!)),
        false,
        shdowPaint);

    shdowPaint.color = Colors.grey.withOpacity(0.1);
    shdowPaint.strokeWidth = 22;
    canvas.drawArc(
        new Rect.fromCircle(center: shdowPaintCenter, radius: shdowPaintRadius),
        degreeToRadians(278),
        degreeToRadians(360 - (365 - angle!)),
        false,
        shdowPaint);

    final rect = new Rect.fromLTWH(0.0, 0.0, size.width, size.width);
    final gradient = new SweepGradient(
      startAngle: degreeToRadians(268),
      endAngle: degreeToRadians(270.0 + 360),
      tileMode: TileMode.repeated,
      colors: colorsList,
    );
    final paint = new Paint()
      ..shader = gradient.createShader(rect)
      ..strokeCap = StrokeCap.round // StrokeCap.round is not recommended.
      ..style = PaintingStyle.stroke
      ..strokeWidth = 14;
    final center = new Offset(size.width / 2, size.height / 2);
    final radius = math.min(size.width / 2, size.height / 2) - (14 / 2);

    canvas.drawArc(
        new Rect.fromCircle(center: center, radius: radius),
        degreeToRadians(278),
        degreeToRadians(360 - (365 - angle!)),
        false,
        paint);

    final gradient1 = new SweepGradient(
      tileMode: TileMode.repeated,
      colors: [Colors.white, Colors.white],
    );

    var cPaint = new Paint();
    cPaint..shader = gradient1.createShader(rect);
    cPaint..color = Colors.white;
    cPaint..strokeWidth = 14 / 2;
    canvas.save();

    final centerToCircle = size.width / 2;
    canvas.save();

    canvas.translate(centerToCircle, centerToCircle);
    canvas.rotate(degreeToRadians(angle! + 2));

    canvas.save();
    canvas.translate(0.0, -centerToCircle + 14 / 2);
    canvas.drawCircle(new Offset(0, 0), 14 / 5, cPaint);

    canvas.restore();
    canvas.restore();
    canvas.restore();
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }

  double degreeToRadians(double degree) {
    var redian = (math.pi / 180) * degree;
    return redian;
  }
}
