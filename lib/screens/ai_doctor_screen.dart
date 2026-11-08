import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:flutter_tts/flutter_tts.dart';
import '../services/health_profile_service.dart';

class AIDoctorScreen extends StatefulWidget {

  const AIDoctorScreen({super.key});


  @override
  State<AIDoctorScreen> createState() =>
      _AIDoctorScreenState();

}



class _AIDoctorScreenState 
extends State<AIDoctorScreen> {
Map<String, String> userProfile = {};

Future<void> loadProfile() async {
  userProfile = await HealthProfileService.getProfile();

  setState(() {});
}

@override
void initState() {
  super.initState();
  loadProfile();
}

final TextEditingController controller =
TextEditingController();


final stt.SpeechToText speech =
stt.SpeechToText();


final FlutterTts tts =
FlutterTts();



bool listening=false;


List<Map<String,String>> messages=[];



Future<void> startListening() async{


bool available =
await speech.initialize();



if(available){


setState((){

listening=true;

});



speech.listen(

onResult:(result){


setState((){

controller.text =
result.recognizedWords;


});


},

);


}



}



void stopListening(){


speech.stop();


setState((){

listening=false;

});


}




void sendMessage(){


String text =
controller.text.trim();



if(text.isEmpty)
return;



setState((){


messages.add({

"sender":"User",

"text":text

});


});



controller.clear();



String reply =
generateAIResponse(text);



setState((){


messages.add({

"sender":"AI Doctor",

"text":reply

});


});



speak(reply);


}





String generateAIResponse(String text){


text=text.toLowerCase();



if(
text.contains("chest pain") ||
text.contains("breathing") ||
text.contains("unconscious")
){


return
"⚠️ This may be an emergency. Please contact emergency services immediately or visit the nearest hospital.";


}



if(text.contains("fever")){


return
"Fever can have many causes. Drink enough water, take rest, monitor temperature and consult a doctor if it continues.";


}



if(text.contains("headache")){


return
"Rest in a quiet place, stay hydrated and monitor your symptoms. If headache is severe, seek medical advice.";


}



return
"Please tell me more details: your age, symptoms duration, and any existing health conditions.";


}




Future<void> speak(String text) async{


await tts.speak(text);


}




@override
Widget build(BuildContext context){


return Scaffold(


appBar: AppBar(

title:
const Text(
"AI Doctor Assistant 🤖"
),

),



body:
Column(

children:[



Expanded(

child:
ListView.builder(

itemCount:
messages.length,


itemBuilder:(context,index){


return Align(

alignment:
messages[index]["sender"]=="User"

?
Alignment.centerRight

:
Alignment.centerLeft,


child:
Card(

child:
Padding(

padding:
const EdgeInsets.all(12),

child:
Text(

messages[index]["text"]!

),

),

),

);


},

),

),




Row(

children:[


Expanded(

child:
TextField(

controller:
controller,


decoration:
const InputDecoration(

hintText:
"Describe your symptoms"

),

),

),



IconButton(

icon:
Icon(

listening

?
Icons.mic

:
Icons.mic_none

),


onPressed:

listening

?
stopListening

:
startListening,


),



IconButton(

icon:
const Icon(
Icons.send
),


onPressed:
sendMessage,


),



],

)



],

),


);


}



}