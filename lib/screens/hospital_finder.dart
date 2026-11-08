import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../services/hospital_service.dart';
import '../services/doctor_ai_service.dart';


class HospitalFinderScreen extends StatefulWidget {

  const HospitalFinderScreen({super.key});


  @override
  State<HospitalFinderScreen> createState() =>
      _HospitalFinderScreenState();

}




class _HospitalFinderScreenState
    extends State<HospitalFinderScreen> {



  final TextEditingController diseaseController =
  TextEditingController();


  final TextEditingController locationController =
  TextEditingController();



  String precautions = "";


  List hospitals = [];


  bool loading = false;





  void analyzeDisease(){


    String disease =
    diseaseController.text.toLowerCase();



    if(disease.contains("diabetes")){


      precautions = """

Disease: Diabetes

Recommended:
Diabetologist / Endocrinology

Precautions:
✓ Reduce sugar
✓ Exercise regularly
✓ Check glucose

""";


    }


    else if(disease.contains("heart")){


      precautions = """

Disease: Heart Problem

Recommended:
Cardiology Hospital

Precautions:
✓ Avoid smoking
✓ Monitor BP
✓ Regular checkup

""";


    }


    else if(disease.contains("skin")){


      precautions = """

Disease: Skin Problem

Recommended:
Dermatology

Precautions:
✓ Maintain hygiene
✓ Avoid allergens

""";


    }


    else {


      precautions = """

General Medicine

Precautions:
✓ Healthy food
✓ Exercise
✓ Drink water

""";


    }



    setState(() {});


  }







  Future<void> findHospitals() async {



    if(locationController.text.isEmpty){

      return;

    }



    setState(() {

      loading = true;

      hospitals = [];

    });





    hospitals =
    await HospitalService.searchHospitals(
        locationController.text
    );





    setState(() {

      loading = false;

    });



  }








  Future<void> openMap(
      double lat,
      double lon) async {



    final url =
    "https://www.google.com/maps/dir/?api=1&destination=$lat,$lon";



    await launchUrl(
      Uri.parse(url),
      mode:
      LaunchMode.externalApplication,
    );


  }







  @override
  Widget build(BuildContext context) {


    return Scaffold(



      appBar: AppBar(

        title:
        const Text(
          "AI Disease Hospital Finder",
        ),

      ),





      body:

      SingleChildScrollView(


        padding:
        const EdgeInsets.all(16),



        child:

        Column(


          children: [




            TextField(

              controller:
              diseaseController,


              decoration:
              const InputDecoration(

                labelText:
                "Enter Disease",

                border:
                OutlineInputBorder(),

              ),

            ),





            const SizedBox(
              height:10,
            ),




            ElevatedButton(

              onPressed:
              analyzeDisease,


              child:
              const Text(
                "Analyze Disease",
              ),

            ),





            if(precautions.isNotEmpty)


              Card(

                child:
                Padding(

                  padding:
                  const EdgeInsets.all(12),

                  child:
                  Text(
                    precautions,
                  ),

                ),

              ),





            const SizedBox(
              height:20,
            ),





            TextField(

              controller:
              locationController,


              decoration:
              const InputDecoration(

                labelText:
                "Enter Location",

                prefixIcon:
                Icon(
                  Icons.location_on,
                ),

                border:
                OutlineInputBorder(),

              ),

            ),






            const SizedBox(
              height:10,
            ),





            ElevatedButton(

              onPressed:
              findHospitals,


              child:
              const Text(
                "Find Hospitals",
              ),

            ),





            if(loading)

              const CircularProgressIndicator(),






            ListView.builder(


              shrinkWrap:
              true,


              physics:
              const NeverScrollableScrollPhysics(),



              itemCount:
              hospitals.length,




              itemBuilder:
              (context,index){



                final hospital =
                hospitals[index];



                return Card(



                  child:

                  ListTile(



                    leading:
                    const Icon(
                      Icons.local_hospital,
                      color: Colors.red,
                    ),




                    title:
                    Text(
                      hospital["name"],
                    ),




                    trailing:

                    IconButton(

                      icon:
                      const Icon(
                        Icons.directions,
                      ),



                      onPressed:(){


                        openMap(

                          hospital["lat"],

                          hospital["lon"],

                        );


                      },

                    ),


                  ),


                );


              },

            )



          ],


        ),


      ),


    );


  }


}