import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';


class HealthPredictionScreen extends StatefulWidget {

  const HealthPredictionScreen({super.key});


  @override
  State<HealthPredictionScreen> createState()
      => _HealthPredictionScreenState();

}



class _HealthPredictionScreenState
    extends State<HealthPredictionScreen>{


final ageController = TextEditingController();
final heightController = TextEditingController();
final weightController = TextEditingController();


String exercise="Yes";
String sleep="5-8 Hours";
String water="Normal";
String food="Healthy";
String disease="None";


String result="";
String suggestion="";



Future<void> saveReport(
double bmi,
int score,
String status) async {


final prefs =
await SharedPreferences.getInstance();


List<String> history =
prefs.getStringList("health_history") ?? [];


history.add(

jsonEncode({

"date":
DateTime.now().toString(),

"bmi":
bmi,

"score":
score,

"status":
status,

})

);


await prefs.setStringList(
"health_history",
history
);


}



void predictHealth(){


double height =
double.tryParse(heightController.text) ?? 0;


double weight =
double.tryParse(weightController.text) ?? 0;



if(height==0 || weight==0){

setState((){

result="Enter height and weight";

});

return;

}



double heightMeter =
height/100;


double bmi =
weight/(heightMeter*heightMeter);



int score=100;



if(exercise=="No"){
score-=15;
}


if(sleep=="Less than 5 Hours"){
score-=15;
}


if(water=="Low"){
score-=10;
}


if(food=="Unhealthy"){
score-=20;
}


if(disease!="None"){
score-=15;
}



String status;



if(score>=80){

status="Healthy 🟢";

suggestion=
"Maintain your lifestyle.";

}

else if(score>=60){

status="Moderate Risk 🟡";

suggestion=
"Improve food and exercise.";

}

else{

status="Needs Attention 🔴";

suggestion=
"Follow healthy habits.";

}



setState((){


result=
"""
Status : $status

BMI : ${bmi.toStringAsFixed(1)}

Score : $score/100
""";


});



// SAVE REPORT HERE

saveReport(
bmi,
score,
status,
);


}





Widget dropdown(
String title,
String value,
List<String> items,
Function(String?) change){


return DropdownButtonFormField(

value:value,

decoration:
InputDecoration(
labelText:title,
border:
const OutlineInputBorder()
),


items:
items.map((e){

return DropdownMenuItem(
value:e,
child:Text(e),
);

}).toList(),


onChanged:change,

);


}



@override
Widget build(BuildContext context){


return Scaffold(

appBar:
AppBar(
title:
const Text(
"AI Health Prediction"
),
),


body:
SingleChildScrollView(

padding:
const EdgeInsets.all(20),


child:
Column(

children:[


TextField(
controller:ageController,
decoration:
const InputDecoration(
labelText:"Age",
border:
OutlineInputBorder()
),
),


const SizedBox(height:15),


TextField(
controller:heightController,
decoration:
const InputDecoration(
labelText:"Height cm",
border:
OutlineInputBorder()
),
),


const SizedBox(height:15),


TextField(
controller:weightController,
decoration:
const InputDecoration(
labelText:"Weight kg",
border:
OutlineInputBorder()
),
),


const SizedBox(height:15),


dropdown(
"Exercise",
exercise,
["Yes","No"],
(v){
setState((){
exercise=v!;
});
}),


const SizedBox(height:15),


dropdown(
"Sleep",
sleep,
[
"Less than 5 Hours",
"5-8 Hours",
"More than 8 Hours"
],
(v){
setState((){
sleep=v!;
});
}),


const SizedBox(height:15),


dropdown(
"Water",
water,
["Low","Normal","Good"],
(v){
setState((){
water=v!;
});
}),


const SizedBox(height:15),


dropdown(
"Food",
food,
["Healthy","Average","Unhealthy"],
(v){
setState((){
food=v!;
});
}),


const SizedBox(height:15),


dropdown(
"Disease",
disease,
[
"None",
"Diabetes",
"Heart Problem",
"BP Problem"
],
(v){
setState((){
disease=v!;
});
}),



const SizedBox(height:25),


ElevatedButton(

onPressed:
predictHealth,

child:
const Text(
"Predict Health"
),

),


const SizedBox(height:25),


Text(
result,
style:
const TextStyle(
fontSize:20,
fontWeight:
FontWeight.bold
),
),


Text(
suggestion
)


],

),

),

);


}

}