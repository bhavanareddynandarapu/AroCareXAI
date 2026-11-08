import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';


class CameraScreen extends StatefulWidget {

const CameraScreen({super.key});


@override
State<CameraScreen> createState()
=> _CameraScreenState();

}



class _CameraScreenState extends State<CameraScreen>{


CameraController? controller;


List<CameraDescription> cameras=[];



@override
void initState(){

super.initState();

initializeCamera();

}



Future<void> initializeCamera() async{


cameras = await availableCameras();


controller = CameraController(
cameras.first,
ResolutionPreset.high,
);


await controller!.initialize();


if(mounted){

setState((){});

}

}



Future<void> takePhoto() async{


final image =
await controller!.takePicture();


Navigator.pop(
context,
File(image.path)
);


}



@override
Widget build(BuildContext context){


if(controller == null ||
!controller!.value.isInitialized){

return const Scaffold(

body:
Center(
child:
CircularProgressIndicator(),
),

);

}



return Scaffold(

appBar:
AppBar(
title:
const Text(
"Take Medicine Photo"
),
),


body:
CameraPreview(controller!),



floatingActionButton:

FloatingActionButton(

child:
const Icon(
Icons.camera
),

onPressed:
takePhoto,

),


);


}



}