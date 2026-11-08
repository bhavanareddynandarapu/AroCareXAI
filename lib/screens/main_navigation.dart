import 'package:flutter/material.dart';

import 'home_screen.dart';
import 'health_screen.dart';
import 'medicine_screen.dart';
import 'emergency_screen.dart';
import 'profile.dart';
import 'hospital_finder_screen.dart';


class MainNavigation extends StatefulWidget {

  const MainNavigation({super.key});


  @override
  State<MainNavigation> createState() => _MainNavigationState();

}



class _MainNavigationState extends State<MainNavigation> {


  int currentIndex = 0;



  final pages = [

    const HomeScreen(),

    const HealthScreen(),

    const MedicineScreen(),

    const EmergencyScreen(),

    const HospitalFinderScreen(),

    const ProfilePage(),

  ];



  @override
  Widget build(BuildContext context) {


    return Scaffold(


      body: pages[currentIndex],



      bottomNavigationBar: BottomNavigationBar(


        currentIndex: currentIndex,


        type: BottomNavigationBarType.fixed,


        selectedItemColor: Colors.blue,

        unselectedItemColor: Colors.grey,



        onTap: (index){


          setState(() {

            currentIndex = index;

          });


        },



        items: const [


          BottomNavigationBarItem(

            icon: Icon(Icons.home),

            label: "Home",

          ),



          BottomNavigationBarItem(

            icon: Icon(Icons.favorite),

            label: "Health",

          ),



          BottomNavigationBarItem(

            icon: Icon(Icons.medication),

            label: "Medicine",

          ),



          BottomNavigationBarItem(

            icon: Icon(Icons.warning),

            label: "Emergency",

          ),

BottomNavigationBarItem(
  icon: Icon(Icons.local_hospital),
  label: "Hospital",
),

          BottomNavigationBarItem(

            icon: Icon(Icons.person),

            label: "Profile",

          ),


        ],


      ),


    );

  }

}