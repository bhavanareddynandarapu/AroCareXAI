import 'package:flutter/material.dart';
import '../services/ai_service.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;


class AIChatScreen extends StatefulWidget {

  const AIChatScreen({super.key});


  @override
  State<AIChatScreen> createState() =>
      _AIChatScreenState();

}




class _AIChatScreenState extends State<AIChatScreen> {


  final TextEditingController controller =
      TextEditingController();


  final ScrollController scrollController =
      ScrollController();


  final stt.SpeechToText speech =
      stt.SpeechToText();



  bool isListening = false;

  bool loading = false;



  List<Map<String,String>> messages = [


    {

      "sender":"ai",

      "text":

      """
Hello! 👋

I'm AroCareX AI Health Assistant.

I can help you with:

• Health information
• Symptoms
• Medicine guidance
• Wellness tips
• Emergency information

How can I help you today?
"""

    }


  ];





  @override
  void dispose(){

    controller.dispose();

    scrollController.dispose();

    speech.stop();

    super.dispose();

  }







  // AUTO SCROLL

  void scrollToBottom(){


    Future.delayed(

      const Duration(milliseconds:300),

      (){


        if(scrollController.hasClients){


          scrollController.animateTo(


            scrollController.position.maxScrollExtent,


            duration:

            const Duration(milliseconds:300),


            curve:

            Curves.easeOut,


          );


        }


      },


    );


  }







  // VOICE START


  Future<void> startListening() async {



    bool available =
    await speech.initialize(


      onStatus:(status){


        print("Speech Status: $status");


        if(status=="done"){


          setState((){


            isListening=false;


          });


        }


      },



      onError:(error){


        print("Speech Error: $error");


        setState((){


          isListening=false;


        });


      },


    );






    if(!available){


      ScaffoldMessenger.of(context)
          .showSnackBar(


        const SnackBar(

          content:

          Text(
              "Microphone permission denied"
          ),


        ),


      );


      return;


    }







    setState((){


      isListening=true;


    });






    speech.listen(



      listenFor:

      const Duration(minutes:1),




      pauseFor:

      const Duration(seconds:3),






      onResult:(result){



        setState((){


          controller.text =

              result.recognizedWords;



        });



      },



    );




  }






  void stopListening(){



    speech.stop();



    setState((){


      isListening=false;


    });


  }








  // LOCAL HEALTH ANSWERS


  String getLocalAnswer(String question){



    question =
        question.toLowerCase();





    if(question.contains("fever")){


      return """

Fever Health Tips:

• Drink plenty of water.
• Take proper rest.
• Monitor temperature.
• Eat healthy food.

Consult a doctor if fever continues.
""";


    }





    if(question.contains("headache")){


      return """

Headache Care:

• Drink enough water.
• Reduce screen time.
• Sleep properly.
• Relax in a quiet place.

""";


    }






    if(question.contains("cold") ||

        question.contains("cough")){


      return """

Cold and Cough Care:

• Drink warm fluids.
• Stay hydrated.
• Get enough sleep.
• Avoid dust and smoke.

""";


    }






    if(question.contains("diabetes") ||

        question.contains("sugar")){


      return """

Diabetes Information:

• Eat balanced food.
• Exercise regularly.
• Check sugar levels.
• Follow doctor advice.

""";


    }






    if(question.contains("bp") ||

        question.contains("blood pressure")){


      return """

Blood Pressure Tips:

• Reduce salt.
• Exercise regularly.
• Manage stress.
• Check BP regularly.

""";


    }





    if(question.contains("water") ||

        question.contains("hydration")){


      return """

Hydration Tips:

• Drink water regularly.
• Increase fluids during exercise.
• Stay hydrated in hot weather.

""";


    }





    return "";


  }
    // ASK QUESTION

  Future<void> askQuestion() async {


    String question =
        controller.text.trim();



    if(question.isEmpty || loading){

      return;

    }



    setState((){


      messages.add({

        "sender":"user",

        "text":question

      });


      loading=true;


    });



    controller.clear();


    scrollToBottom();




    try{


      String answer =
          getLocalAnswer(question);




      // Emergency detection

      if(question.contains("chest pain") ||

          question.contains("heart attack") ||

          question.contains("breathing problem") ||

          question.contains("cannot breathe") ||

          question.contains("stroke") ||

          question.contains("unconscious") ||

          question.contains("accident")){


        answer = """

⚠️ EMERGENCY ALERT

These symptoms may require immediate medical attention.

Please:

• Call emergency services.
• Do not ignore severe symptoms.
• Keep the person safe.

Emergency Numbers:

🚑 Ambulance: 108
🚓 Police: 100
🔥 Fire: 101


AroCareX AI is not a replacement for emergency care.

""";


      }





      // AI API CALL

      if(answer.isEmpty){


        answer =
        await AIService.askAI(question);


      }







      if(!mounted){

        return;

      }






      setState((){


        messages.add({


          "sender":"ai",


          "text":answer.isEmpty

          ? "Sorry, I couldn't generate a response."

          : answer


        });



        loading=false;



      });





      scrollToBottom();



    }

    catch(e){


      setState((){


        messages.add({


          "sender":"ai",


          "text":

          "Sorry, something went wrong."


        });



        loading=false;


      });



    }


  }








  // CLEAR CHAT


  void clearChat(){


    setState((){


      messages.clear();



      messages.add({


        "sender":"ai",


        "text":

        """
Hello! 👋

I'm AroCareX AI Health Assistant.

How can I help you today?
"""


      });


    });


  }







  // MESSAGE BUBBLE


  Widget buildBubble(
      Map<String,String> message){



    bool isUser =
        message["sender"]=="user";




    return Align(



      alignment:

      isUser

      ? Alignment.centerRight

      : Alignment.centerLeft,





      child:Container(




        margin:

        const EdgeInsets.symmetric(

          vertical:6,

          horizontal:10,

        ),






        padding:

        const EdgeInsets.all(14),





        constraints:

        BoxConstraints(


          maxWidth:

          MediaQuery.of(context)
              .size
              .width *

              0.75,


        ),






        decoration:

        BoxDecoration(



          color:

          isUser

          ? Colors.green

          : Colors.green.shade50,





          borderRadius:

          BorderRadius.circular(18),






          border:

          Border.all(

            color:

            Colors.green.shade200,

          ),



        ),







        child:Text(



          message["text"] ?? "",





          style:

          TextStyle(



            fontSize:16,





            color:

            isUser

            ? Colors.white

            : Colors.black87,



          ),



        ),




      ),



    );


  }
  @override
  Widget build(BuildContext context) {


    return Scaffold(


      appBar: AppBar(


        title:

        const Text(

          "AroCareX AI Assistant",

        ),



        centerTitle:true,



        backgroundColor:

        Colors.green,




        actions:[



          IconButton(



            icon:

            const Icon(

              Icons.delete,

            ),




            tooltip:

            "Clear Chat",




            onPressed:

            clearChat,



          )



        ],


      ),





      body:

      Column(


        children:[



          Expanded(



            child:

            ListView.builder(



              controller:

              scrollController,




              itemCount:

              messages.length +

                  (loading ? 1 : 0),





              itemBuilder:

                  (context,index){



                if(loading &&

                    index == messages.length){



                  return const Padding(



                    padding:

                    EdgeInsets.all(12),





                    child:

                    Row(



                      children:[



                        SizedBox(



                          height:20,

                          width:20,




                          child:

                          CircularProgressIndicator(),

                        ),




                        SizedBox(width:12),




                        Text(

                          "AroCareX AI is thinking..."

                        )



                      ],



                    ),



                  );



                }






                return buildBubble(

                    messages[index]

                );



              },



            ),



          ),






          const Divider(),







          Padding(



            padding:

            const EdgeInsets.all(10),






            child:

            Row(



              children:[



                Expanded(



                  child:

                  TextField(



                    controller:

                    controller,





                    decoration:

                    InputDecoration(




                      hintText:

                      "Ask your health question...",






                      prefixIcon:

                      const Icon(



                        Icons.health_and_safety,



                        color:

                        Colors.green,



                      ),








                      suffixIcon:

                      IconButton(




                        icon:

                        Icon(



                          isListening

                          ? Icons.mic

                          : Icons.mic_none,



                          color:

                          Colors.green,



                        ),





                        onPressed:



                        (){



                          if(isListening){



                            stopListening();



                          }

                          else{



                            startListening();



                          }



                        },




                      ),








                      border:

                      OutlineInputBorder(



                        borderRadius:

                        BorderRadius.circular(30),



                      ),



                    ),







                    onSubmitted:

                    (_) => askQuestion(),





                  ),



                ),






                const SizedBox(width:10),







                FloatingActionButton(



                  mini:true,




                  backgroundColor:

                  Colors.green,





                  onPressed:

                  loading

                  ? null

                  : askQuestion,





                  child:

                  const Icon(

                    Icons.send,

                  ),




                )



              ],



            ),



          )



        ],



      ),



    );


  }


}