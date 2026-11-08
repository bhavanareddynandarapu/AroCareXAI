import 'dart:async';

import 'package:flutter/material.dart';

import '../widgets/app_logo.dart';



class SplashScreen extends StatefulWidget {

  const SplashScreen({super.key});


  @override
  State<SplashScreen> createState() => _SplashScreenState();

}



class _SplashScreenState extends State<SplashScreen>

    with SingleTickerProviderStateMixin {



  late AnimationController _controller;

  late Animation<double> _animation;



  @override
  void initState() {

    super.initState();



    _controller = AnimationController(

      duration: const Duration(seconds: 2),

      vsync: this,

    );



    _animation = CurvedAnimation(

      parent: _controller,

      curve: Curves.easeOut,

    );



    _controller.forward();



    Timer(

      const Duration(seconds: 4),

      () {

        if (mounted) {

          Navigator.pushReplacementNamed(

            context,

            "/login",

          );

        }

      },

    );

  }



  @override
  void dispose() {

    _controller.dispose();

    super.dispose();

  }



  @override
  Widget build(BuildContext context) {


    return Scaffold(

      backgroundColor: Colors.white,


      body: Container(

        width: double.infinity,

        height: double.infinity,


        decoration: const BoxDecoration(

          gradient: LinearGradient(

            colors: [

              Color(0xffE3F2FD),

              Color(0xffFFFFFF),

            ],

            begin: Alignment.topCenter,

            end: Alignment.bottomCenter,

          ),

        ),



        child: Center(


          child: ScaleTransition(


            scale: _animation,


            child: const AppLogo(),


          ),


        ),


      ),


    );

  }

}