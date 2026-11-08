import 'package:flutter/material.dart';


class HospitalRecommendationScreen extends StatefulWidget {

  const HospitalRecommendationScreen({super.key});


  @override
  State<HospitalRecommendationScreen> createState() =>
      _HospitalRecommendationScreenState();

}



class _HospitalRecommendationScreenState
    extends State<HospitalRecommendationScreen> {



  final TextEditingController symptomController =
      TextEditingController();



  String result = "";





  void analyzeSymptoms(){


    String symptoms =
        symptomController.text.toLowerCase();



    String recommendation = "";




    if(symptoms.contains("chest pain") ||
       symptoms.contains("heart") ||
       symptoms.contains("breathing")){


      recommendation = """

🚨 Emergency Level: HIGH


Recommended Department:

❤️ Cardiology
🏥 Emergency Care


Action:

• Call ambulance if severe.
• Visit nearest emergency hospital.
• Do not delay treatment.


Emergency Numbers:

🚑 Ambulance: 108

""";


    }




    else if(symptoms.contains("fever") ||
            symptoms.contains("cough") ||
            symptoms.contains("cold")){


      recommendation = """

Emergency Level: LOW


Recommended Department:

🩺 General Physician


Suggestion:

• Visit a nearby clinic.
• Drink enough fluids.
• Take proper rest.


""";


    }





    else if(symptoms.contains("bone") ||
            symptoms.contains("fracture") ||
            symptoms.contains("pain")){


      recommendation = """

Emergency Level: MEDIUM


Recommended Department:

🦴 Orthopedic Department


Suggestion:

• Avoid putting pressure on injury.
• Consult an orthopedic doctor.


""";


    }





    else{


      recommendation = """

Unable to identify exact department.


Recommended:

🏥 General Physician


Please provide more symptoms.

""";


    }



    setState((){

      result = recommendation;

    });



  }







  @override
  Widget build(BuildContext context){


    return Scaffold(



      appBar: AppBar(


        title:
        const Text(
          "AI Hospital Recommendation",
        ),


        backgroundColor:
        Colors.green,


      ),





      body:Padding(


        padding:
        const EdgeInsets.all(16),




        child:Column(


          children:[




            TextField(


              controller:
              symptomController,



              maxLines:3,



              decoration:

              InputDecoration(


                hintText:
                "Enter your symptoms...",


                border:
                OutlineInputBorder(


                  borderRadius:
                  BorderRadius.circular(15),


                ),


              ),



            ),





            const SizedBox(height:20),






            ElevatedButton(



              onPressed:
              analyzeSymptoms,



              style:

              ElevatedButton.styleFrom(

                backgroundColor:
                Colors.green,

              ),



              child:

              const Text(
                "Find Hospital",
              ),



            ),





            const SizedBox(height:20),





            Expanded(


              child:

              SingleChildScrollView(


                child:

                Text(

                  result,

                  style:

                  const TextStyle(

                    fontSize:16,

                  ),

                ),


              ),


            )



          ],



        ),



      ),



    );


  }


}