import 'package:flutter/material.dart';
import 'screens/signup_screen.dart';
import 'screens/login_screen.dart';
import 'screens/health_screen.dart';
import 'screens/medicine_screen.dart';
import 'screens/emergency_screen.dart';
import 'screens/air_quality_screen.dart';
import 'screens/profile.dart';
import 'screens/splash_screen.dart';
import 'screens/navigation.dart';

import 'services/notification_service.dart';



void main() async {


  WidgetsFlutterBinding.ensureInitialized();


  await NotificationService.initialize();


  runApp(const AroCareXAI());


}



class AroCareXAI extends StatelessWidget {


  const AroCareXAI({super.key});



  @override
  Widget build(BuildContext context) {


    return MaterialApp(


      debugShowCheckedModeBanner: false,


      title: "AroCareX AI",



      theme: ThemeData.dark().copyWith(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF5FE4CE),
          brightness: Brightness.dark,
        ),
        scaffoldBackgroundColor: const Color(0xFF080D1B),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF111A2E),
          foregroundColor: Colors.white,
          elevation: 0,
        ),
        cardColor: const Color(0xFF141E31),
      ),



      // First screen

      home: const SplashScreen(),



      routes: {

          "/signup":
(context)=>const SignupScreen(),

        "/login":
        (context)=>const LoginScreen(),



        "/home":
        (context)=> MainNavigation(),



        "/health":
        (context)=>const HealthScreen(),



        "/medicine":
        (context)=>const MedicineScreen(),



        "/emergency":
        (context)=>const EmergencyScreen(),



        "/air":
        (context)=>const AirQualityScreen(),



        "/profile":
        (context)=>const ProfilePage(),



      },


    );


  }


}