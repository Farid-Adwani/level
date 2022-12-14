import 'package:Aerobotix/HomeScreen/Aerobotix_app_theme.dart';
import 'package:Aerobotix/HomeScreen/ui_view/AllBadges.dart';
import 'package:Aerobotix/HomeScreen/ui_view/badges.dart';
import 'package:Aerobotix/ui/HexColor.dart';
import 'package:flutter/material.dart';


class GlassView extends StatelessWidget {
  final AnimationController? animationController;
  final Animation<double>? animation;
  String text;
  String date;
  String photo;
  String phone="";

   GlassView({Key? key, this.animationController, this.animation,required this.date,required this.photo,required this.text,this.phone=""})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animationController!,
      builder: (BuildContext context, Widget? child) {
        return FadeTransition(
          opacity: animation!,
          child: new Transform(
            transform: new Matrix4.translationValues(
                0.0, 30 * (1.0 - animation!.value), 0.0),
            child: GestureDetector(

              onTap:(){
                print("waaaaaaaa");
                print(text);
                if(text.toUpperCase().contains("BADGE")){
                  Navigator.push(
    context,
    MaterialPageRoute(builder: (context) =>  AllBadgesScreen(phone:phone)),
  );
                }
              },
              child: Column(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(
                        left: 24, right: 24, top: 0, bottom: 0),
                    child: Stack(
                      clipBehavior: Clip.none,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.only(top: 16),
                          child: Container(
                            width: MediaQuery.of(context).size.width/1.5,
                            decoration: BoxDecoration(
                              color: HexColor("#D7E0F9"),
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(8.0),
                                  bottomLeft: Radius.circular(8.0),
                                  bottomRight: Radius.circular(8.0),
                                  topRight: Radius.circular(8.0)),
                              // boxShadow: <BoxShadow>[
                              //   BoxShadow(
                              //       color: AerobotixAppTheme.grey.withOpacity(0.2),
                              //       offset: Offset(1.1, 1.1),
                              //       blurRadius: 10.0),
                              // ],
                            ),
                            child: Column(
                              children: <Widget>[
                                Padding(
                                  padding: const EdgeInsets.only(
                                      left: 68, bottom: 12, right: 16, top: 12),
                                  child: Text(
                                    text+date,
                                    textAlign: TextAlign.left,
                                    style: TextStyle(
                                      fontFamily: AerobotixAppTheme.fontName,
                                      fontWeight: FontWeight.w500,
                                      fontSize: 14,
                                      letterSpacing: 0.0,
                                      color: AerobotixAppTheme.nearlyDarkBlue
                                          .withOpacity(0.6),
                                    ),
                                  ),
                                  
                                ),
                                
                              ],
                            ),
                          ),
                        ),
                        Positioned(
                          top: -12,
                          left: 0,
                          child: SizedBox(
                            width: 60,
                            height: 60,
                            child: Image.asset("assets/HomeScreen/"+photo),
                          ),
                        )
                      ],
                    ),
                  ),
              
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
