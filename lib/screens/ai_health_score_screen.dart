import 'package:flutter/material.dart';

import 'dashboard.dart';


class AIHealthScoreScreen extends StatelessWidget {

  const AIHealthScoreScreen({super.key});


  @override
  Widget build(BuildContext context) {


    return Scaffold(

      backgroundColor: const Color(0xffF5F9FF),


      appBar: AppBar(

        backgroundColor: Colors.white,

        elevation: 0,


        // BACK BUTTON

        leading: IconButton(

          icon: const Icon(

            Icons.arrow_back,

            color: Colors.blue,

          ),


          onPressed: () {


            Navigator.of(context).pop();


          },

        ),



        title: const Text(

          "AI Health Score",

          style: TextStyle(

            color: Colors.blue,

            fontWeight: FontWeight.bold,

          ),

        ),

      ),



      body: SingleChildScrollView(


        padding: const EdgeInsets.all(20),



        child: Column(


          children: [



            const SizedBox(height:20),



            Container(

              height:250,

              width:double.infinity,


              decoration:BoxDecoration(

                gradient:const LinearGradient(

                  colors:[

                    Colors.blue,

                    Colors.cyan,

                  ],

                ),


                borderRadius:BorderRadius.circular(30),

              ),



              child:Column(

                mainAxisAlignment:MainAxisAlignment.center,


                children:[



                  const Text(

                    "Your AI Health Score",

                    style:TextStyle(

                      color:Colors.white,

                      fontSize:22,

                    ),

                  ),



                  const SizedBox(height:20),




                  Container(

                    height:120,

                    width:120,


                    decoration:const BoxDecoration(

                      color:Colors.white,

                      shape:BoxShape.circle,

                    ),



                    child:const Center(

                      child:Text(

                        "92",

                        style:TextStyle(

                          color:Colors.blue,

                          fontSize:50,

                          fontWeight:FontWeight.bold,

                        ),

                      ),

                    ),

                  ),




                  const SizedBox(height:10),




                  const Text(

                    "Excellent Health",

                    style:TextStyle(

                      color:Colors.white,

                      fontSize:18,

                    ),

                  ),


                ],

              ),

            ),





            const SizedBox(height:25),





            infoCard(

              Icons.favorite,

              "Heart Health",

              "Normal",

            ),



            infoCard(

              Icons.calculate,

              "BMI",

              "22.5",

            ),



            infoCard(

              Icons.water_drop,

              "Hydration",

              "Good",

            ),



            infoCard(

              Icons.directions_walk,

              "Activity",

              "Active",

            ),





            const SizedBox(height:25),





            Container(

              padding:const EdgeInsets.all(20),


              decoration:BoxDecoration(

                color:Colors.white,

                borderRadius:BorderRadius.circular(20),

              ),



              child:const Column(

                crossAxisAlignment:CrossAxisAlignment.start,

                children:[



                  Text(

                    "AI Suggestions",

                    style:TextStyle(

                      fontSize:20,

                      fontWeight:FontWeight.bold,

                    ),

                  ),




                  SizedBox(height:15),




                  Text(

                    "✓ Drink enough water\n\n"

                    "✓ Exercise regularly\n\n"

                    "✓ Maintain healthy food habits\n\n"

                    "✓ Take medicines on time",

                    style:TextStyle(

                      fontSize:16,

                    ),

                  ),


                ],

              ),

            ),



            const SizedBox(height:30),




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



                onPressed:(){



                  Navigator.push(

                    context,

                    MaterialPageRoute(

                      builder:(context)=>const Dashboard(),

                    ),

                  );


                },



                child:const Text(

                  "GO TO DASHBOARD",

                  style:TextStyle(

                    color:Colors.white,

                    fontSize:18,

                  ),

                ),

              ),

            )


          ],

        ),

      ),

    );


  }




  Widget infoCard(

      IconData icon,

      String title,

      String value

  ){


    return Container(

      margin:const EdgeInsets.only(bottom:15),

      padding:const EdgeInsets.all(15),


      decoration:BoxDecoration(

        color:Colors.white,

        borderRadius:BorderRadius.circular(20),

      ),


      child:Row(

        children:[



          CircleAvatar(

            backgroundColor:Colors.blue.shade100,

            child:Icon(

              icon,

              color:Colors.blue,

            ),

          ),



          const SizedBox(width:15),



          Text(

            title,

            style:const TextStyle(

              fontSize:17,

              fontWeight:FontWeight.bold,

            ),

          ),



          const Spacer(),



          Text(

            value,

            style:const TextStyle(

              color:Colors.blue,

              fontWeight:FontWeight.bold,

            ),

          ),



        ],

      ),

    );

  }

}