import 'package:Aerobotix/HomeScreen/Aerobotix_app_home_screen.dart';
import 'package:Aerobotix/services/firebase_service.dart';
import 'package:flutter/material.dart';
import 'package:Aerobotix/screens/authentication_screen.dart';
import 'package:Aerobotix/utils/globals.dart';
import 'package:Aerobotix/widgets/custom_loader.dart';

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
      bool isLoggedIn=false;
       isLoggedIn =await FirestoreService.isConnected();

      if (isLoggedIn) {return
      Navigator.pushReplacementNamed(
        context,
        AerobotixAppHomeScreen.id ,
      );}else{
Navigator.pushReplacementNamed(
        context,
        AuthenticationScreen.id );
      }
    })();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return  SafeArea(
      child: Scaffold(
        body: 
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children:[
            Image.asset(
              "assets/images/icon.png",
              fit: BoxFit.cover,
              height: MediaQuery.of(context).size.height / 8,
              width: MediaQuery.of(context).size.width,
            ),
CustomLoader(),
          ]
        )
        
        
      ),
    );
  }
}
