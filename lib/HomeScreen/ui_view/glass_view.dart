import 'package:Aerobotix/HomeScreen/Aerobotix_app_theme.dart';
import 'package:Aerobotix/HomeScreen/ui_view/AllBadges.dart';
import 'package:Aerobotix/HomeScreen/ui_view/badges.dart';
import 'package:Aerobotix/ui/HexColor.dart';
import 'package:flutter/material.dart';

class GlassView extends StatefulWidget {
  final AnimationController? animationController;
  final Animation<double>? animation;
  String text;
  String date;
  IconData icon;
  String phone = "";

  GlassView(
      {Key? key,
      this.animationController,
      this.animation,
      required this.date,
      required this.icon,
      required this.text,
      this.phone = ""})
      : super(key: key);

  @override
  _GlassViewState createState() => _GlassViewState();
}

class _GlassViewState extends State<GlassView> {
  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: widget.animationController!,
      builder: (BuildContext context, Widget? child) {
        return FadeTransition(
            opacity: widget.animation!,
            child: new Transform(
                transform: new Matrix4.translationValues(
                    0.0, 30 * (1.0 - widget.animation!.value), 0.0),
                child: GestureDetector(
                    onTap: () {
                      if (widget.text.toUpperCase().contains("BADGE")) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  AllBadgesScreen(phone: widget.phone)),
                        );
                      }
                    },
                    child: Column(children: <Widget>[
                      Padding(
                        padding: EdgeInsets.only(
                            right: MediaQuery.of(context).size.width / 10,
                            left: MediaQuery.of(context).size.width / 10,
                            top: 8,
                            bottom: 8),
                        child: Container(
                          decoration: BoxDecoration(
                              color: AerobotixAppTheme.white.withOpacity(0.2),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(8))),
                          child: Row(
                            children: <Widget>[
                              Padding(
                                  padding: EdgeInsets.all(8),
                                  child: Icon(widget.icon)),
                              Padding(
                                  padding: const EdgeInsets.all(8),
                                  child: Center(
                                    child: Text(
                                      widget.text + widget.date,
                                      textAlign: TextAlign.left,
                                      style: TextStyle(
                                        fontFamily: AerobotixAppTheme.fontName,
                                        fontWeight: FontWeight.w500,
                                        fontSize: 14,
                                        letterSpacing: 0.0,
                                      ),
                                    ),
                                  )),
                            ],
                          ),
                        ),
                      ),
                    ]))));
      },
    );
  }
}
