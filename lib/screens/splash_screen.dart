import 'package:Aerobotix/screens/profile_screen.dart';
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
        ProfileScreen.id ,
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
    return const SafeArea(
      child: Scaffold(
        body: CustomLoader(),
      ),
    );
  }
}
