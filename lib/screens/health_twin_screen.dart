import 'package:flutter/material.dart';

import '../models/health_data.dart';



class HealthTwinScreen extends StatefulWidget {


  const HealthTwinScreen({super.key});


  @override
  State<HealthTwinScreen> createState() =>
      _HealthTwinScreenState();


}



class _HealthTwinScreenState extends State<HealthTwinScreen> {



  final nameController = TextEditingController();


  final ageController = TextEditingController();


  final heightController = TextEditingController();


  final weightController = TextEditingController();



  @override
  void initState() {

    super.initState();


    // Load saved health data automatically

    nameController.text = HealthData.userName;


    ageController.text =
        HealthData.age == 0
        ? ""
        : HealthData.age.toString();


    heightController.text =
        HealthData.height == 0
        ? ""
        : HealthData.height.toString();


    weightController.text =
        HealthData.weight == 0
        ? ""
        : HealthData.weight.toString();


  }





  void saveProfile(){


    HealthData.userName = nameController.text;


    HealthData.age =
        int.tryParse(ageController.text) ?? 0;


    HealthData.height =
        double.tryParse(heightController.text) ?? 0;


    HealthData.weight =
        double.tryParse(weightController.text) ?? 0;



    setState(() {});


  }





  @override
  Widget build(BuildContext context) {


    return Scaffold(


      appBar: AppBar(


        title: const Text(
          "AI Health Twin",
        ),


        backgroundColor: Colors.blue,


        foregroundColor: Colors.white,


      ),





      body: SingleChildScrollView(


        padding: const EdgeInsets.all(20),



        child: Column(


          children: [




            CircleAvatar(


              radius: 50,


              backgroundColor:
                  Colors.blue.shade100,



              child: const Icon(


                Icons.health_and_safety,


                size:50,


                color:Colors.blue,


              ),


            ),




            const SizedBox(height:20),





            Text(


              HealthData.userName.isEmpty

                  ? "Your Health Twin"

                  : HealthData.userName,



              style: const TextStyle(


                fontSize:24,


                fontWeight:FontWeight.bold,


              ),


            ),





            const SizedBox(height:25),





            inputBox(

              "Name",

              nameController,

            ),





            inputBox(

              "Age",

              ageController,

            ),





            inputBox(

              "Height (cm)",

              heightController,

            ),





            inputBox(

              "Weight (kg)",

              weightController,

            ),





            const SizedBox(height:20),





            ElevatedButton(


              onPressed: saveProfile,



              style: ElevatedButton.styleFrom(


                minimumSize:
                    const Size(double.infinity,50),


                backgroundColor:Colors.blue,


              ),




              child: const Text(


                "Update Health Twin",



                style: TextStyle(


                  color:Colors.white,


                  fontSize:18,


                ),


              ),


            ),





            const SizedBox(height:30),





            healthCard(),





            const SizedBox(height:20),





            suggestionCard(),





          ],


        ),


      ),


    );


  }






  Widget healthCard(){


    return Container(


      width:double.infinity,


      padding:const EdgeInsets.all(20),



      decoration:BoxDecoration(


        color:Colors.blue.shade50,


        borderRadius:
            BorderRadius.circular(20),


      ),





      child:Column(


        crossAxisAlignment:
            CrossAxisAlignment.start,



        children:[



          const Text(


            "Health Information",


            style:TextStyle(


              fontSize:20,


              fontWeight:FontWeight.bold,


            ),


          ),




          const SizedBox(height:15),





          Text(
            "Age: ${HealthData.age} years",
          ),



          Text(
            "Height: ${HealthData.height} cm",
          ),



          Text(
            "Weight: ${HealthData.weight} kg",
          ),



          Text(
            "Heart Rate: ${HealthData.heartRate} BPM",
          ),



          Text(
            "Sleep: ${HealthData.sleepHours} Hours",
          ),




          const Divider(),




          Text(


            "AI Health Score: ${HealthData.healthScore}/100",



            style:const TextStyle(


              fontSize:18,


              fontWeight:FontWeight.bold,


            ),


          ),





          const SizedBox(height:10),





          Text(


            HealthData.healthStatus,



            style:const TextStyle(


              fontSize:18,


            ),


          ),



        ],


      ),


    );


  }







  Widget suggestionCard(){


    return Container(


      width:double.infinity,


      padding:const EdgeInsets.all(20),



      decoration:BoxDecoration(


        color:Colors.green.shade50,


        borderRadius:
            BorderRadius.circular(20),


      ),




      child:Column(


        crossAxisAlignment:
            CrossAxisAlignment.start,



        children:[




          const Text(


            "AI Suggestions",



            style:TextStyle(


              fontSize:20,


              fontWeight:FontWeight.bold,


            ),


          ),




          const SizedBox(height:10),





          if(HealthData.suggestions.isEmpty)


            const Text(
              "Complete health analysis to get suggestions"
            )

          else


            ...HealthData.suggestions.map(

              (item)=>Padding(

                padding:
                const EdgeInsets.only(bottom:8),


                child:Text(
                  "✓ $item",
                ),


              ),

            ),



        ],


      ),


    );


  }






  Widget inputBox(

      String title,

      TextEditingController controller,

      ){



    return Padding(


      padding:
      const EdgeInsets.only(bottom:15),



      child:TextField(


        controller:controller,



        keyboardType:
        TextInputType.number,



        decoration:InputDecoration(


          labelText:title,



          border:OutlineInputBorder(


            borderRadius:
            BorderRadius.circular(15),


          ),


        ),


      ),


    );


  }



}