import 'package:Aerobotix/HomeScreen/Aerobotix_app_theme.dart';
import 'package:Aerobotix/HomeScreen/ui_view/wave_view.dart';
import 'package:Aerobotix/ui/HexColor.dart';
import 'package:flutter/material.dart';
import 'dart:math' as math;

import 'package:glassmorphism/glassmorphism.dart';

class DetailsView extends StatelessWidget {
  final AnimationController? animationController;
  final Animation<double>? animation;
  String fname;
  String lname;
  String branch;
  int level;


   DetailsView(
      {Key? key, this.animationController, this.animation, required this.fname,required this.lname,required this.level,required this.branch})
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
            child: Padding(
              padding: const EdgeInsets.only(
                  left: 24, right: 24, top: 16, bottom: 18),
              child: 
                 Column(
                  children: [
                    GlassmorphicContainer(
                      width: MediaQuery.of(context).size.width / 1.1,
                      height: MediaQuery.of(context).size.width / 9,
                      borderRadius: 20,
                      blur: 20,
                      alignment: Alignment.bottomCenter,
                      border: 2,
                      linearGradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            Color(0xFFffffff).withOpacity(0.1),
                            Color(0xFFFFFFFF).withOpacity(0.05),
                          ],
                          stops: [
                            0.1,
                            1,
                          ]),
                      borderGradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          Color(0xFFffffff).withOpacity(0.5),
                          Color((0xFFFFFFFF)).withOpacity(0.5),
                        ],
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(child: Center(child: Text(fname))),
                          IconButton(onPressed: () {}, icon: Icon(Icons.edit))
                        ],
                      ),
                    ),                
                   SizedBox(
                    height: MediaQuery.of(context).size.height/150,
                   ),
                    GlassmorphicContainer(
                      width: MediaQuery.of(context).size.width / 1.5,
                      height: MediaQuery.of(context).size.width / 9,
                      borderRadius: 20,
                      blur: 20,
                      alignment: Alignment.bottomCenter,
                      border: 2,
                      linearGradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            Color(0xFFffffff).withOpacity(0.1),
                            Color(0xFFFFFFFF).withOpacity(0.05),
                          ],
                          stops: [
                            0.1,
                            1,
                          ]),
                      borderGradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          Color(0xFFffffff).withOpacity(0.5),
                          Color((0xFFFFFFFF)).withOpacity(0.5),
                        ],
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(child: Center(child: Text(lname))),
                          IconButton(onPressed: () {}, icon: Icon(Icons.edit))
                        ],
                      ),
                    ),
                    SizedBox(
                    height: MediaQuery.of(context).size.height/150,
                   ),
                    GlassmorphicContainer(
                      width: MediaQuery.of(context).size.width / 2.5,
                      height: MediaQuery.of(context).size.width / 9,
                      borderRadius: 20,
                      blur: 20,
                      alignment: Alignment.bottomCenter,
                      border: 2,
                      linearGradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            Color(0xFFffffff).withOpacity(0.1),
                            Color(0xFFFFFFFF).withOpacity(0.05),
                          ],
                          stops: [
                            0.1,
                            1,
                          ]),
                      borderGradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          Color(0xFFffffff).withOpacity(0.5),
                          Color((0xFFFFFFFF)).withOpacity(0.5),
                        ],
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(child: Center(child: Text(branch))),
                          IconButton(onPressed: () {}, icon: Icon(Icons.edit))
                        ],
                      ),
                    ),
                   SizedBox(
                    height: MediaQuery.of(context).size.height/150,
                   ),
                    GlassmorphicContainer(
                      width: MediaQuery.of(context).size.width / 5,
                      height: MediaQuery.of(context).size.width / 9,
                      borderRadius: 20,
                      blur: 20,
                      alignment: Alignment.bottomCenter,
                      border: 2,
                      linearGradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            Color(0xFFffffff).withOpacity(0.1),
                            Color(0xFFFFFFFF).withOpacity(0.05),
                          ],
                          stops: [
                            0.1,
                            1,
                          ]),
                      borderGradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          Color(0xFFffffff).withOpacity(0.5),
                          Color((0xFFFFFFFF)).withOpacity(0.5),
                        ],
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(child: Center(child: Text(level.toString()))),
                          IconButton(onPressed: () {}, icon: Icon(Icons.edit))
                        ],
                      ),
                    ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height/150,
                   ),
                  ],
                )
             ),
          ),
        );
      },
    );
  }
}
