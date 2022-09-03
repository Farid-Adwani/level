import 'dart:io';

import 'package:Aerobotix/HomeScreen/Aerobotix_app_home_screen.dart';
import 'package:Aerobotix/app/app.dart';
import 'package:Aerobotix/services/firebase_service.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:Aerobotix/screens/authentication_screen.dart';
import 'package:Aerobotix/utils/globals.dart';
import 'package:Aerobotix/widgets/custom_loader.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher_string.dart';

class SplashScreen extends StatefulWidget {
  static const id = 'SplashScreen';

  const SplashScreen({
    Key? key,
  }) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    (() async {
      await Future.delayed(Duration.zero);
      bool isLoggedIn = false;
      await FirestoreService.isUpToDate().then((Map<String,String> value) async {
          if(value.isNotEmpty){
            if(value.containsKey("error")){
            popUp(context,"",0,0,true);

          }else{
            if (double.parse(value["version"].toString()) > version){
            popUp(context, value["link"].toString(),version,double.parse(value["version"].toString()),false);
          }else{
            isLoggedIn = await FirestoreService.isConnected();
        if (isLoggedIn) {
          return Navigator.pushReplacementNamed(
            context,
            AerobotixAppHomeScreen.id,
          );
        } else {
          Navigator.pushReplacementNamed(context, AuthenticationScreen.id);
        }
          }
          }
          }

        
      });
    })();
    super.initState();
  }

  late AwesomeDialog ad;
  bool popUp(context, String link,double oldVersion,double newVersion,error) {
    ad = AwesomeDialog(
      dismissOnBackKeyPress: false,
      dismissOnTouchOutside: false,
      context: context,
      animType: AnimType.SCALE,
      dialogType: DialogType.ERROR,
      body: Center(
        child: Column(
          children: [
            if(error==false) Text(
              "You have the version "+oldVersion.toString()+"\nPlease install the last update of the application ⚠️ !\nRequired version = "+newVersion.toString(),
            textAlign: TextAlign.center,
            ),
            if(error==true) Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                "Please check your internet connection and try again ",
                textAlign: TextAlign.center,
              ),
            ),

            if(error==false) TextButton(
                onPressed: () async{
                  print("hani mchet");
                  await launch(link);
                },
                child: Text("update now"),
                
                ),
              if(error==true) TextButton(
                style: ButtonStyle(
                  
                ),
                onPressed: () {
                   Navigator.pushReplacementNamed(context, SplashScreen.id);
                },
                child: Text("Rerun")),  
          ],
        ),
      ),
    );

    ad..show();
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          body: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        Image.asset(
          "assets/images/icon.png",
          fit: BoxFit.cover,
          height: MediaQuery.of(context).size.height / 8,
          width: MediaQuery.of(context).size.width,
        ),
        CustomLoader(),
      ])),
    );
  }
}
