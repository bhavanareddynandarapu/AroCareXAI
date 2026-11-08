import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';


class NearbyHospitalScreen extends StatefulWidget {

  const NearbyHospitalScreen({super.key});


  @override
  State<NearbyHospitalScreen> createState() =>
      _NearbyHospitalScreenState();

}




class _NearbyHospitalScreenState
    extends State<NearbyHospitalScreen> {


  GoogleMapController? mapController;


  LatLng currentLocation =
      const LatLng(
        13.6288,
        79.4192,
      );



  bool loading = true;



  @override
  void initState(){

    super.initState();

    getLocation();

  }




  Future<void> getLocation() async {


    bool serviceEnabled =
        await Geolocator.isLocationServiceEnabled();



    if(!serviceEnabled){

      return;

    }



    LocationPermission permission =
        await Geolocator.checkPermission();



    if(permission ==
        LocationPermission.denied){


      permission =
          await Geolocator.requestPermission();


    }



    Position position =
        await Geolocator.getCurrentPosition();



    setState((){


      currentLocation =
          LatLng(
            position.latitude,
            position.longitude,
          );


      loading=false;


    });



  }






  @override
  Widget build(BuildContext context){


    return Scaffold(


      appBar: AppBar(


        title:

        const Text(
          "Nearby Hospitals",
        ),


        backgroundColor:
        Colors.green,


      ),



      body:


      loading

      ?

      const Center(

        child:

        CircularProgressIndicator(),

      )

      :

      GoogleMap(


        initialCameraPosition:

        CameraPosition(


          target:
          currentLocation,


          zoom:14,


        ),





        myLocationEnabled:true,


        myLocationButtonEnabled:true,



        markers:{


          Marker(

            markerId:

            const MarkerId(
              "user",
            ),


            position:
            currentLocation,


            infoWindow:

            const InfoWindow(

              title:
              "Your Location",

            ),


          )

        },



      ),



    );


  }


}