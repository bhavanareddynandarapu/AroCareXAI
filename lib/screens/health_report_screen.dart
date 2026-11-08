import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fl_chart/fl_chart.dart';


class HealthReportScreen extends StatefulWidget{

const HealthReportScreen({super.key});


@override
State<HealthReportScreen> createState()
=>_HealthReportScreenState();

}



class _HealthReportScreenState
extends State<HealthReportScreen>{


List reports=[];


@override
void initState(){

super.initState();

loadReports();

}



Future loadReports() async{


final prefs=
await SharedPreferences.getInstance();


List<String> data =
prefs.getStringList(
"health_history"
) ?? [];


setState((){


reports=
data.map(
(e)=>jsonDecode(e)
).toList();


});


}




@override
Widget build(BuildContext context){


return Scaffold(

appBar:
AppBar(
title:
const Text(
"AI Health Reports"
),
),


body:
reports.isEmpty

?

const Center(
child:
Text(
"No Reports Found"
)
)


:

Column(

children:[


Card(

margin:
const EdgeInsets.all(15),

child:
Padding(

padding:
const EdgeInsets.all(20),

child:
Text(

"""
Latest Report

BMI:
${reports.last["bmi"]}

Score:
${reports.last["score"]}/100

Status:
${reports.last["status"]}
"""

),

),

),



Expanded(

child:
LineChart(

LineChartData(

lineBarsData:[

LineChartBarData(

spots:

List.generate(
reports.length,
(index){

return FlSpot(

index.toDouble(),

reports[index]["score"]
.toDouble()

);

}

),

)

]


)

),

)


],

),


);


}

}