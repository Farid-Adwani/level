import 'package:Aerobotix/HomeScreen/Aerobotix_app_home_screen.dart';
import 'package:Aerobotix/HomeScreen/my_diary/otherProfile.dart';
import 'package:Aerobotix/screens/authentication_screen.dart';
import 'package:Aerobotix/screens/sign_up_screen.dart';
import 'package:Aerobotix/screens/verify_phone_number_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_phone_auth_handler/firebase_phone_auth_handler.dart';
import 'package:flutter/material.dart';
import 'package:Aerobotix/screens/splash_screen.dart';
import 'package:Aerobotix/utils/app_theme.dart';
import 'package:Aerobotix/utils/globals.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  FirebaseAuth auth = FirebaseAuth.instance;
  await auth.setSettings(appVerificationDisabledForTesting: true);
  runApp(const levelsApp());
}

class levelsApp extends StatelessWidget {
  const levelsApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Aerobotix',
      scaffoldMessengerKey: Globals.scaffoldMessengerKey,
      theme: AppTheme.darkTheme,
      darkTheme: AppTheme.darkTheme,

      //onGenerateRoute: RouteGenerator.generateRoute,
      routes: {
        "/sign_in": (context) => SignUpScreen(),
         AerobotixAppHomeScreen.id: (context) => AerobotixAppHomeScreen(),
         "/otherProfile": (context) => OtherProfile(),

        VerifyPhoneNumberScreen.id: (context) => VerifyPhoneNumberScreen(),
       
        
        
        SplashScreen.id: (context) => SplashScreen(),
        AuthenticationScreen.id: (context) => AuthenticationScreen(),
      },
      initialRoute: SplashScreen.id,
      
    );
  }
}
