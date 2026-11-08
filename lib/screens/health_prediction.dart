import 'package:flutter/material.dart';

import '../models/health_data.dart';



class HealthPrediction extends StatefulWidget {

  const HealthPrediction({super.key});


  @override
  State<HealthPrediction> createState() =>
      _HealthPredictionState();

}




class _HealthPredictionState extends State<HealthPrediction> {



  final nameController = TextEditingController();

  final ageController = TextEditingController();

  final weightController = TextEditingController();

  final heightController = TextEditingController();

  final heartController = TextEditingController();

  final sleepController = TextEditingController();



  String result =
      "Enter your details to predict health";


  int score = 0;





  void predictHealth(){


    int age =
        int.tryParse(ageController.text) ?? 0;


    double weight =
        double.tryParse(weightController.text) ?? 0;


    double height =
        double.tryParse(heightController.text) ?? 0;


    int heart =
        int.tryParse(heartController.text) ?? 0;


    double sleep =
        double.tryParse(sleepController.text) ?? 0;




    int healthScore = 100;



    if(age > 60){

      healthScore -= 15;

    }



    if(heart < 60 || heart > 100){

      healthScore -= 20;

    }



    if(sleep < 6){

      healthScore -= 15;

    }



    if(height > 0){


      double bmi =
          weight / ((height / 100) * (height / 100));



      if(bmi < 18 || bmi > 30){

        healthScore -= 15;

      }


    }





    String status;


    List<String> advice = [];



    if(healthScore >= 80){


      status =
      "🟢 Good Health\n\nYour health condition looks good.";


      advice = [

        "Maintain healthy diet",

        "Continue exercise",

        "Keep proper sleep schedule",

      ];


    }

    else if(healthScore >= 50){


      status =
      "🟡 Need Attention\n\nImprove your lifestyle.";


      advice = [

        "Increase physical activity",

        "Improve sleep quality",

        "Monitor health regularly",

      ];


    }

    else{


      status =
      "🔴 High Risk\n\nConsult a doctor.";


      advice = [

        "Consult healthcare professional",

        "Reduce stress",

        "Follow medical advice",

      ];


    }





    // Save user information

    HealthData.saveUserDetails(

      name: nameController.text,

      userAge: age,

      userHeight: height,

      userWeight: weight,

      userHeartRate: heart,

      userSleepHours: sleep,

    );





    // Save AI result

    HealthData.updateHealthResult(

      score: healthScore,

      status: status,

      advice: advice,

    );





    setState(() {


      score = healthScore;


      result = status;


    });



  }








  @override
  Widget build(BuildContext context) {


    return Scaffold(


      appBar: AppBar(


        title: const Text(
          "AI Health Prediction",
        ),


        backgroundColor: Colors.blue,


        foregroundColor: Colors.white,


      ),





      body: SingleChildScrollView(


        padding: const EdgeInsets.all(20),



        child: Column(


          children: [



            inputField(

              "Name",

              nameController,

              Icons.person,

            ),



            inputField(

              "Age",

              ageController,

              Icons.calendar_today,

            ),



            inputField(

              "Weight (kg)",

              weightController,

              Icons.monitor_weight,

            ),



            inputField(

              "Height (cm)",

              heightController,

              Icons.height,

            ),



            inputField(

              "Heart Rate BPM",

              heartController,

              Icons.favorite,

            ),



            inputField(

              "Sleep Hours",

              sleepController,

              Icons.bedtime,

            ),




            const SizedBox(height:20),




            ElevatedButton(


              onPressed: predictHealth,



              style: ElevatedButton.styleFrom(


                minimumSize:
                const Size(double.infinity,50),


                backgroundColor: Colors.blue,


              ),



              child: const Text(


                "Analyze Health",


                style: TextStyle(

                  color: Colors.white,

                  fontSize:18,

                ),


              ),


            ),





            const SizedBox(height:30),





            Container(


              width: double.infinity,


              padding: const EdgeInsets.all(20),



              decoration: BoxDecoration(


                color: Colors.blue.shade50,


                borderRadius:
                BorderRadius.circular(20),


              ),




              child: Column(


                children: [



                  Text(

                    "Health Score: $score / 100",

                    style: const TextStyle(

                      fontSize:22,

                      fontWeight:FontWeight.bold,

                    ),

                  ),




                  const SizedBox(height:15),




                  Text(

                    result,

                    textAlign: TextAlign.center,

                    style: const TextStyle(

                      fontSize:18,

                    ),

                  ),



                ],


              ),


            )


          ],


        ),


      ),


    );


  }







  Widget inputField(

      String label,

      TextEditingController controller,

      IconData icon,

      ){



    return Padding(


      padding:
      const EdgeInsets.only(bottom:15),



      child: TextField(


        controller: controller,


        keyboardType:
        TextInputType.number,



        decoration: InputDecoration(


          labelText: label,


          prefixIcon: Icon(icon),



          border: OutlineInputBorder(


            borderRadius:
            BorderRadius.circular(15),


          ),


        ),


      ),


    );


  }



}