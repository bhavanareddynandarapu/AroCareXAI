import 'package:flutter/material.dart';

import '../models/medical_report.dart';



class ReportViewScreen extends StatelessWidget {


final MedicalReport report;



const ReportViewScreen({

super.key,

required this.report,

});




@override
Widget build(BuildContext context){


return Scaffold(



appBar:

AppBar(

title:

const Text(
"View Report"
),

),




body:

Center(


child:

Column(

mainAxisAlignment:
MainAxisAlignment.center,


children:[



const Icon(

Icons.picture_as_pdf,

size:100,

color:Colors.red,

),




Text(

report.name,

style:

const TextStyle(

fontSize:20,

fontWeight:
FontWeight.bold

),

),




const SizedBox(height:20),




Text(

"File Location:\n${report.path}",

textAlign:
TextAlign.center,

),



],

),



),



);



}


}