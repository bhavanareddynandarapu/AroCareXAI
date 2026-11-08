import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../services/medicine_ai_service.dart';


class MedicineScannerScreen extends StatefulWidget {

  const MedicineScannerScreen({super.key});

  @override
  State<MedicineScannerScreen> createState() =>
      _MedicineScannerScreenState();

}


class _MedicineScannerScreenState 
extends State<MedicineScannerScreen> {


File? selectedImage;

String result = "";

bool scanning = false;


final ImagePicker picker = ImagePicker();



Future<void> openCamera() async {

  final XFile? photo =
  await picker.pickImage(
    source: ImageSource.camera,
    imageQuality: 80,
  );


  if(photo != null){

    setState((){

      selectedImage = File(photo.path);
      result = "";

    });

  }

}



Future<void> openGallery() async {

  final XFile? image =
  await picker.pickImage(
    source: ImageSource.gallery,
    imageQuality: 80,
  );


  if(image != null){

    setState((){

      selectedImage = File(image.path);
      result = "";

    });

  }

}



Future<void> scanMedicine() async {


if(selectedImage == null){

 ScaffoldMessenger.of(context).showSnackBar(
 const SnackBar(
 content: Text(
 "Please capture medicine image first"
 ),
 ),
 );

 return;

}



setState((){

scanning=true;

});



String response =
await MedicineAIService.analyzeMedicine(
selectedImage!.path
);



setState((){

result=response;
scanning=false;

});


}





@override
Widget build(BuildContext context) {


return Scaffold(


appBar: AppBar(

title:
const Text(
"AI Medicine Scanner 💊"
),

),



body:
SingleChildScrollView(

padding:
const EdgeInsets.all(20),


child:
Column(

children: [



Row(

mainAxisAlignment:
MainAxisAlignment.spaceEvenly,

children: [


ElevatedButton.icon(

onPressed:
openCamera,

icon:
const Icon(
Icons.camera_alt
),

label:
const Text(
"Camera"
),

),



ElevatedButton.icon(

onPressed:
openGallery,

icon:
const Icon(
Icons.photo
),

label:
const Text(
"Gallery"
),

),


],

),



const SizedBox(height:25),



if(selectedImage != null)

ClipRRect(

borderRadius:
BorderRadius.circular(15),

child:
Image.file(

selectedImage!,

height:220,

width:
double.infinity,

fit:
BoxFit.cover,

),

),



const SizedBox(height:20),



ElevatedButton(

onPressed:
scanMedicine,

child:
const Text(
"🔍 Scan Medicine"
),

),



const SizedBox(height:20),



if(scanning)

const CircularProgressIndicator(),



if(result.isNotEmpty)

Card(

elevation:5,

child:

Padding(

padding:
const EdgeInsets.all(15),

child:
Text(

result,

style:
const TextStyle(
fontSize:16,
),

),

),

),



],

),

),


);


}


}