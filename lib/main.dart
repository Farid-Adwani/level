import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_phone_auth_handler/firebase_phone_auth_handler.dart';
import 'package:flutter/material.dart';
import 'package:levels/screens/daily.dart';
import 'package:levels/screens/hourly.dart';
import 'package:levels/screens/multiple_gadgets_screen.dart';
import 'package:levels/screens/sign_up_screen.dart';
import 'package:levels/screens/splash_screen.dart';
import 'package:levels/utils/app_theme.dart';
import 'package:levels/utils/globals.dart';
import 'package:levels/utils/route_generator.dart';
import 'screens/people_screen.dart';
import 'screens/female_screen.dart';
import 'screens/male_screen.dart';

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
    return FirebasePhoneAuthProvider(
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'levels',
        scaffoldMessengerKey: Globals.scaffoldMessengerKey,
        theme: AppTheme.darkTheme,
        darkTheme: AppTheme.darkTheme,
        onGenerateRoute: RouteGenerator.generateRoute,
        routes: {
          PeopleScreen.id: (context) => PeopleScreen(),
          FemaleScreen.id: (context) => FemaleScreen(),
          MaleScreen.id: (context) => MaleScreen(),
          DailyPage.id: (context) => DailyPage(),
          HourlyPage.id: (context) => HourlyPage(),
          SignUpScreen.id: (context) => SignUpScreen(),
          MultipleGadgets.id: (context) => MultipleGadgets(),
        },
        initialRoute: SplashScreen.id,
      ),
    );
  }
}
