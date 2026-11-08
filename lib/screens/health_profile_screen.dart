import 'package:flutter/material.dart';

import 'dashboard.dart';
import 'ai_health_score_screen.dart';
import '../services/health_profile_service.dart';

class HealthProfileScreen extends StatefulWidget {

  const HealthProfileScreen({super.key});


  @override
  State<HealthProfileScreen> createState() => _HealthProfileScreenState();

}



class _HealthProfileScreenState extends State<HealthProfileScreen> {


  final ageController = TextEditingController();

  final heightController = TextEditingController();

  final weightController = TextEditingController();

  final medicalController = TextEditingController();

  final emergencyController = TextEditingController();



  String gender = "gender";

  String bloodGroup = "O+";



  double bmi = 0;



  void calculateBMI(){


    double height =
        double.tryParse(heightController.text) ?? 0;


    double weight =
        double.tryParse(weightController.text) ?? 0;



    if(height > 0 && weight > 0){


      double heightMeter = height / 100;


      setState(() {

        bmi = weight / (heightMeter * heightMeter);

      });


    }


  }





  @override
  Widget build(BuildContext context) {


    return Scaffold(


      backgroundColor: const Color(0xffF5F9FF),



      appBar: AppBar(

        backgroundColor: Colors.white,

        elevation: 0,


        title: const Text(

          "Health Profile",

          style: TextStyle(

            color: Colors.blue,

            fontWeight: FontWeight.bold,

          ),

        ),


        iconTheme: const IconThemeData(

          color: Colors.blue,

        ),

      ),





      body: SingleChildScrollView(


        padding: const EdgeInsets.all(20),



        child: Column(


          children: [




            const Icon(

              Icons.health_and_safety,

              size:90,

              color:Colors.blue,

            ),





            const SizedBox(height:20),





            const Text(

              "Complete Your Health Profile",

              style:TextStyle(

                fontSize:22,

                fontWeight:FontWeight.bold,

              ),

            ),





            const SizedBox(height:25),





            CustomField(

              controller:ageController,

              label:"Age",

              icon:Icons.calendar_month,

              type:TextInputType.number,

            ),





            CustomField(

              controller:heightController,

              label:"Height (cm)",

              icon:Icons.height,

              type:TextInputType.number,

            ),





            CustomField(

              controller:weightController,

              label:"Weight (kg)",

              icon:Icons.monitor_weight,

              type:TextInputType.number,

            ),





            const SizedBox(height:15),





            Container(

              padding:const EdgeInsets.symmetric(horizontal:15),

              decoration:BoxDecoration(

                color:Colors.white,

                borderRadius:BorderRadius.circular(15),

              ),



              child:DropdownButton<String>(

                value:gender,

                isExpanded:true,

                underline:const SizedBox(),



                items:[

                  "Male",

                  "Female",

                  "Other"

                ].map((e){


                  return DropdownMenuItem(

                    value:e,

                    child:Text(e),

                  );


                }).toList(),



                onChanged:(value){


                  setState(() {

                    gender=value!;

                  });


                },

              ),

            ),





            const SizedBox(height:15),





            Container(

              padding:const EdgeInsets.symmetric(horizontal:15),

              decoration:BoxDecoration(

                color:Colors.white,

                borderRadius:BorderRadius.circular(15),

              ),



              child:DropdownButton<String>(

                value:bloodGroup,

                isExpanded:true,

                underline:const SizedBox(),



                items:[

                  "A+",

                  "A-",

                  "B+",

                  "B-",

                  "O+",

                  "O-",

                  "AB+",

                  "AB-"

                ].map((e){


                  return DropdownMenuItem(

                    value:e,

                    child:Text("Blood Group : $e"),

                  );


                }).toList(),



                onChanged:(value){


                  setState(() {

                    bloodGroup=value!;

                  });


                },

              ),

            ),





            const SizedBox(height:15),





            TextField(

              controller:medicalController,

              maxLines:3,


              decoration:InputDecoration(

                labelText:"Medical History",

                prefixIcon:const Icon(Icons.medical_information),

                filled:true,

                fillColor:Colors.white,

                border:OutlineInputBorder(

                  borderRadius:BorderRadius.circular(15),

                  borderSide:BorderSide.none,

                ),

              ),

            ),





            const SizedBox(height:15),





            CustomField(

              controller:emergencyController,

              label:"Emergency Contact",

              icon:Icons.emergency,

              type:TextInputType.phone,

            ),





            const SizedBox(height:25),





            if(bmi > 0)

            Container(

              padding:const EdgeInsets.all(15),

              decoration:BoxDecoration(

                color:Colors.blue.shade50,

                borderRadius:BorderRadius.circular(15),

              ),


              child:Text(

                "Your BMI: ${bmi.toStringAsFixed(1)}",

                style:const TextStyle(

                  fontSize:20,

                  fontWeight:FontWeight.bold,

                  color:Colors.blue,

                ),

              ),

            ),





            const SizedBox(height:20),





            SizedBox(

              width:double.infinity,

              height:55,


              child:ElevatedButton(

                style:ElevatedButton.styleFrom(

                  backgroundColor:Colors.blue,

                  shape:RoundedRectangleBorder(

                    borderRadius:BorderRadius.circular(15),

                  ),

                ),

onPressed:() async {


calculateBMI();



await HealthProfileService.saveProfile(

age:
ageController.text,

height:
heightController.text,

weight:
weightController.text,

gender:
gender,

bloodGroup:
bloodGroup,

medicalHistory:
medicalController.text,

emergency:
emergencyController.text,

);



Future.delayed(

const Duration(seconds:1),

(){

Navigator.push(

context,

MaterialPageRoute(

builder:(context)=>
const AIHealthScoreScreen(),

),

);

},

);


},



                  Future.delayed(

                    const Duration(seconds:1),

                    (){


                      Navigator.push(

                        context,

                        MaterialPageRoute(

                          builder:(context)=>const  AIHealthScoreScreen(),

                        ),

                      );


                    },

                  );


                },



                child:const Text(

                  "SAVE PROFILE",

                  style:TextStyle(

                    color:Colors.white,

                    fontSize:18,

                    fontWeight:FontWeight.bold,

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






class CustomField extends StatelessWidget {


  final TextEditingController controller;

  final String label;

  final IconData icon;

  final TextInputType type;



  const CustomField({

    super.key,

    required this.controller,

    required this.label,

    required this.icon,

    required this.type,

  });



  @override
  Widget build(BuildContext context){


    return Container(

      margin:const EdgeInsets.only(bottom:15),


      child:TextField(

        controller:controller,

        keyboardType:type,


        decoration:InputDecoration(

          labelText:label,

          prefixIcon:Icon(icon),

          filled:true,

          fillColor:Colors.white,

          border:OutlineInputBorder(

            borderRadius:BorderRadius.circular(15),

            borderSide:BorderSide.none,

          ),

        ),

      ),

    );


  }

}