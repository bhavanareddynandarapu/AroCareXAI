import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;


class HydrationScreen extends StatefulWidget {

  const HydrationScreen({super.key});

  @override
  State<HydrationScreen> createState() =>
      _HydrationScreenState();

}



class _HydrationScreenState
    extends State<HydrationScreen> {


  final TextEditingController locationController =
  TextEditingController();



  double? temperature;


  String locationName = "";


  String hydrationStatus = "";


  String advice = "";


  String waterGoal = "";


  int riskPercentage = 0;


  bool loading = false;





  Future<void> searchLocation() async {


    if(locationController.text.isEmpty){

      showMessage("Enter location");

      return;

    }



    setState((){

      loading=true;

    });



    try{


      final url = Uri.parse(

          "https://nominatim.openstreetmap.org/search?"
              "q=${locationController.text}"
              "&format=json&limit=1"

      );



      final response =
      await http.get(

          url,

          headers:{

            "User-Agent":
            "AroCareX-AI-App"

          }

      );



      List data =
      jsonDecode(response.body);



      if(data.isEmpty){

        throw Exception(
            "Location not found"
        );

      }



      double latitude =
      double.parse(
          data[0]["lat"]
      );



      double longitude =
      double.parse(
          data[0]["lon"]
      );



      String place =
      data[0]["display_name"];



      await getTemperature(

          latitude,

          longitude,

          place

      );



    }

    catch(e){


      setState((){

        loading=false;

      });


      showMessage(
          e.toString()
      );


    }


  }







  Future<void> useMyLocation() async{


    setState((){

      loading=true;

    });



    try{


      Position position =

      await Geolocator.getCurrentPosition();



      await getTemperature(

          position.latitude,

          position.longitude,

          "Current Location"

      );



    }

    catch(e){


      setState((){

        loading=false;

      });


      showMessage(
          e.toString()
      );


    }


  }







  Future<void> getTemperature(

      double latitude,

      double longitude,

      String place

      ) async {



    try{


      final url = Uri.parse(

          "https://api.open-meteo.com/v1/forecast?"
              "latitude=$latitude&"
              "longitude=$longitude&"
              "current=temperature_2m"

      );



      final response =
      await http.get(url);



      final data =
      jsonDecode(response.body);



      double temp =

      data["current"]["temperature_2m"]
          .toDouble();




      setState((){


        temperature=temp;


        locationName=place;


        predictHydration();


      });



    }

    catch(e){

      showMessage(
          e.toString()
      );

    }



    setState((){

      loading=false;

    });


  }









  void predictHydration(){



    if(temperature==null){

      return;

    }




    if(temperature! < 20){



      waterGoal="2 Liters / Day";


      riskPercentage=20;


      hydrationStatus="Excellent";


      advice=

      "Cool weather detected.\n"
          "Normal water intake is enough.";



    }



    else if(temperature! <25){



      waterGoal="2.5 Liters / Day";


      riskPercentage=40;


      hydrationStatus="Good";


      advice=

      "Pleasant weather.\n"
          "Drink water regularly.";



    }



    else if(temperature! <30){



      waterGoal="3 Liters / Day";


      riskPercentage=60;


      hydrationStatus="Moderate";


      advice=

      "Warm weather detected.\n"
          "Increase water intake.";



    }



    else if(temperature! <35){



      waterGoal="3.5 Liters / Day";


      riskPercentage=80;


      hydrationStatus="High Risk";


      advice=

      "Hot weather detected.\n"
          "Drink water frequently.";



    }



    else{



      waterGoal="4 Liters / Day";


      riskPercentage=90;


      hydrationStatus="Very High Risk";


      advice=

      "Extreme heat detected.\n"
          "Drink water every 30-45 minutes.\n"
          "Avoid dehydration.";



    }


  }









  void showMessage(String message){


    ScaffoldMessenger.of(context)
        .showSnackBar(

      SnackBar(

        content:
        Text(message),

      ),

    );


  }








  Widget buildCard(

      IconData icon,

      String title,

      String value,

      Color color

      ){



    return Card(


      elevation:5,


      margin:
      const EdgeInsets.symmetric(
          vertical:8
      ),



      shape:

      RoundedRectangleBorder(

        borderRadius:
        BorderRadius.circular(20),

      ),



      child:

      ListTile(



        leading:

        CircleAvatar(

          radius:25,


          backgroundColor:
          color,


          child:

          Icon(

            icon,

            color:
            Colors.white,

          ),

        ),



        title:

        Text(

          title,

          style:

          const TextStyle(

            fontWeight:
            FontWeight.bold,

          ),

        ),



        trailing:

        Text(

          value,


          style:

          const TextStyle(

            fontSize:17,

            fontWeight:
            FontWeight.bold,

          ),

        ),


      ),


    );


  }










  @override
  Widget build(BuildContext context){



    return Scaffold(



      backgroundColor:
      Colors.grey.shade100,



      appBar:

      AppBar(

        title:

        const Text(
            "AI Hydration"
        ),

        centerTitle:true,

      ),





      body:


      SingleChildScrollView(



        padding:

        const EdgeInsets.all(20),




        child:

        Column(


          children:[





            Container(


              width:
              double.infinity,


              padding:
              const EdgeInsets.all(25),



              decoration:

              BoxDecoration(

                gradient:

                const LinearGradient(

                  colors:[

                    Colors.blue,

                    Colors.cyan,

                  ],

                ),


                borderRadius:
                BorderRadius.circular(25),


              ),




              child:

              const Column(


                children:[


                  Icon(

                    Icons.water_drop,

                    size:70,

                    color:
                    Colors.white,

                  ),



                  SizedBox(height:10),




                  Text(

                    "AI Hydration Prediction",

                    style:

                    TextStyle(

                      color:
                      Colors.white,

                      fontSize:22,

                      fontWeight:
                      FontWeight.bold,

                    ),

                  ),


                ],


              ),



            ),





            const SizedBox(
              height:25
            ),






            TextField(

              controller:
              locationController,



              decoration:

              InputDecoration(

                labelText:
                "Enter Location",


                hintText:
                "Example: Chittoor",


                prefixIcon:
                const Icon(
                    Icons.location_on
                ),


                filled:true,


                fillColor:
                Colors.white,


                border:

                OutlineInputBorder(

                  borderRadius:
                  BorderRadius.circular(15),

                ),

              ),

            ),





            const SizedBox(
              height:15
            ),





            Row(


              children:[



                Expanded(

                  child:

                  ElevatedButton.icon(

                    onPressed:
                    searchLocation,


                    icon:
                    const Icon(
                        Icons.search
                    ),


                    label:
                    const Text(
                        "Search"
                    ),


                  ),

                ),



                const SizedBox(
                  width:10
                ),



                Expanded(

                  child:

                  ElevatedButton.icon(

                    onPressed:
                    useMyLocation,


                    icon:
                    const Icon(
                        Icons.my_location
                    ),


                    label:
                    const Text(
                        "current location"
                    ),


                  ),

                ),



              ],


            ),






            const SizedBox(
              height:25
            ),





            if(loading)

              const CircularProgressIndicator()




            else if(temperature!=null)


              Column(

                children:[



                  Text(

                    locationName,

                    textAlign:
                    TextAlign.center,


                    style:

                    const TextStyle(

                      fontSize:18,

                      fontWeight:
                      FontWeight.bold,

                    ),

                  ),




                  Text(

                    "${temperature!.toStringAsFixed(1)}°C",

                    style:

                    const TextStyle(

                      fontSize:45,

                      fontWeight:
                      FontWeight.bold,

                      color:
                      Colors.orange,

                    ),

                  ),





                  buildCard(

                      Icons.water_drop,

                      "Water Required",

                      waterGoal,

                      Colors.blue

                  ),





                  buildCard(

                      Icons.warning,

                      "Dehydration Risk",

                      "$riskPercentage%",

                      Colors.red

                  ),





                  buildCard(

                      Icons.health_and_safety,

                      "Hydration Status",

                      hydrationStatus,

                      Colors.green

                  ),





                  Container(


                    width:
                    double.infinity,


                    padding:
                    const EdgeInsets.all(20),



                    decoration:

                    BoxDecoration(

                      color:
                      Colors.white,

                      borderRadius:
                      BorderRadius.circular(20),

                    ),



                    child:

                    Text(

                      "🤖 AI Advice\n\n$advice",

                      textAlign:
                      TextAlign.center,


                      style:

                      const TextStyle(

                        fontSize:17,

                        fontWeight:
                        FontWeight.w500,

                      ),


                    ),


                  ),



                ],


              ),



          ],



        ),



      ),



    );


  }


}