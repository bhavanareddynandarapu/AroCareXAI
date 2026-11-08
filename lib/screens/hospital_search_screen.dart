import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';


class HospitalSearchScreen extends StatefulWidget {

  const HospitalSearchScreen({super.key});


  @override
  State<HospitalSearchScreen> createState() =>
      _HospitalSearchScreenState();

}



class _HospitalSearchScreenState
    extends State<HospitalSearchScreen> {


  final TextEditingController placeController =
      TextEditingController();



  List hospitals = [];


  bool loading = false;



  Future<void> searchHospitals() async {


    String place =
        placeController.text.trim();



    if(place.isEmpty){

      return;

    }



    setState((){

      loading=true;

      hospitals=[];

    });



    // Demo data (will connect API next)

    await Future.delayed(
        const Duration(seconds:2)
    );



    setState((){


      hospitals=[


        {

          "name":
          "Apollo Hospital",

          "address":
          "$place Main Road",

          "lat":
          "13.6288",

          "lng":
          "79.4192"

        },



        {

          "name":
          "Government General Hospital",

          "address":
          "$place City Center",

          "lat":
          "13.6300",

          "lng":
          "79.4200"

        }



      ];



      loading=false;


    });



  }






  Future<void> openDirections(
      String lat,
      String lng) async {



    final url = Uri.parse(

    "https://www.google.com/maps/dir/?api=1"
    "&destination=$lat,$lng"

    );



    await launchUrl(

      url,

      mode:
      LaunchMode.externalApplication,

    );


  }







  @override
  Widget build(BuildContext context){


    return Scaffold(



      appBar:

      AppBar(

        title:

        const Text(
          "Hospital Finder",
        ),

        backgroundColor:
        Colors.green,

      ),






      body:

      Padding(



        padding:
        const EdgeInsets.all(16),



        child:

        Column(


          children:[



            TextField(


              controller:
              placeController,


              decoration:

              const InputDecoration(


                hintText:
                "Enter city or place name",


                prefixIcon:
                Icon(Icons.location_on),


                border:
                OutlineInputBorder(),

              ),



            ),





            const SizedBox(height:15),





            ElevatedButton(


              onPressed:
              searchHospitals,


              child:
              const Text(
                "Search Hospitals",
              ),


            ),





            const SizedBox(height:20),





            if(loading)

              const CircularProgressIndicator(),





            Expanded(



              child:

              ListView.builder(


                itemCount:
                hospitals.length,



                itemBuilder:
                (context,index){



                  var hospital =
                  hospitals[index];



                  return Card(



                    child:

                    ListTile(


                      leading:

                      const Icon(

                        Icons.local_hospital,

                        color:
                        Colors.green,

                      ),



                      title:

                      Text(

                        hospital["name"],

                      ),



                      subtitle:

                      Text(

                        hospital["address"],

                      ),




                      trailing:

                      IconButton(



                        icon:

                        const Icon(

                          Icons.directions,

                        ),



                        onPressed:(){

                          openDirections(

                            hospital["lat"],

                            hospital["lng"],

                          );

                        },


                      ),



                    ),



                  );



                },


              ),


            )



          ],



        ),



      ),



    );

  }

}