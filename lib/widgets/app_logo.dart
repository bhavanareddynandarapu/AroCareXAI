import 'package:flutter/material.dart';

class AppLogo extends StatelessWidget {

  const AppLogo({super.key});


  @override
  Widget build(BuildContext context) {

    return Column(

      mainAxisAlignment: MainAxisAlignment.center,

      children: [

        // Logo Image
        SizedBox(

          height: 280,

          width: 280,

          child: Image.asset(

            "assets/images/logo.png",

            fit: BoxFit.contain,

          ),

        ),



        const SizedBox(height: 35),



        // App Name
        const Text(

          "AroCareX AI",

          style: TextStyle(

            fontSize: 76,

            fontWeight: FontWeight.bold,

            letterSpacing: 1.5,

            color: Colors.blue,

            shadows: [

              Shadow(

                color: Colors.black26,

                blurRadius: 8,

                offset: Offset(2, 2),

              ),

            ],

          ),

        ),



        const SizedBox(height: 8),



        // Tagline
        const Text(

          "Your AI Health Guardian",

          style: TextStyle(

            fontSize: 36,

            letterSpacing: 0.8,

            color: Colors.grey,

          ),

        ),

      ],

    );

  }

}