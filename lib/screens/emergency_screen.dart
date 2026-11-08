import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';


class EmergencyScreen extends StatefulWidget {

  const EmergencyScreen({super.key});

  @override
  State<EmergencyScreen> createState() =>
      _EmergencyScreenState();

}



class _EmergencyScreenState
    extends State<EmergencyScreen> {


  final family1 =
  TextEditingController();

  final family2 =
  TextEditingController();

  final family3 =
  TextEditingController();



  List<Map<String,String>> familyContacts = [];



  @override
  void initState(){

    super.initState();

    loadContacts();

  }




  Future<void> loadContacts() async {


    final prefs =
    await SharedPreferences.getInstance();


    setState((){


      familyContacts = [

        if(prefs.getString("family1") != null &&
            prefs.getString("family1")!.isNotEmpty)

          {
            "name":"Family Member 1",
            "number":prefs.getString("family1")!
          },


        if(prefs.getString("family2") != null &&
            prefs.getString("family2")!.isNotEmpty)

          {
            "name":"Family Member 2",
            "number":prefs.getString("family2")!
          },


        if(prefs.getString("family3") != null &&
            prefs.getString("family3")!.isNotEmpty)

          {
            "name":"Family Member 3",
            "number":prefs.getString("family3")!
          },

      ];


    });


  }







  Future<void> saveContacts() async {


    final prefs =
    await SharedPreferences.getInstance();


    await prefs.setString(

        "family1",

        family1.text

    );


    await prefs.setString(

        "family2",

        family2.text

    );


    await prefs.setString(

        "family3",

        family3.text

    );


    loadContacts();


  }







  Future<void> deleteContact(int index) async {


    final prefs =
    await SharedPreferences.getInstance();


    if(index == 0){

      await prefs.remove("family1");

    }

    else if(index == 1){

      await prefs.remove("family2");

    }

    else if(index == 2){

      await prefs.remove("family3");

    }


    loadContacts();


  }






  Future<void> callNumber(String number) async {


    Uri url =
    Uri.parse(
        "tel:$number"
    );


    await launchUrl(url);


  }







  Future<void> sendSMS(String number) async {


    Uri url =
    Uri.parse(

      "sms:$number?body=Emergency! I need help."

    );


    await launchUrl(url);


  }






  Widget contactCard(
      String name,
      String number,
      int index,
      bool delete
      ){

    return Card(

      child:

      ListTile(


        leading:

        const Icon(

          Icons.person,

          color:Colors.red,

        ),



        title:

        Text(name),



        subtitle:

        Text(number),




        trailing:

        Row(

          mainAxisSize:
          MainAxisSize.min,


          children: [


            IconButton(

              icon:
              const Icon(
                Icons.call,
                color:Colors.green,
              ),


              onPressed: (){

                callNumber(number);

              },

            ),



            IconButton(

              icon:
              const Icon(
                Icons.sms,
                color:Colors.blue,
              ),


              onPressed: (){

                sendSMS(number);

              },

            ),



            if(delete)

              IconButton(

                icon:
                const Icon(
                  Icons.delete,
                  color:Colors.red,
                ),


                onPressed: (){

                  deleteContact(index);

                },

              ),


          ],

        ),


      ),

    );


  }







  @override
  Widget build(BuildContext context){


    return Scaffold(


      appBar:

      AppBar(

        title:
        const Text(
            "Emergency Contacts"
        ),

      ),




      body:


      SingleChildScrollView(


        padding:
        const EdgeInsets.all(16),


        child:


        Column(

          crossAxisAlignment:
          CrossAxisAlignment.start,


          children: [



            const Text(

              "Emergency Services",

              style:
              TextStyle(

                fontSize:20,

                fontWeight:
                FontWeight.bold,

              ),

            ),




            contactCard(
                "Ambulance",
                "108",
                0,
                false
            ),


            contactCard(
                "Police",
                "100",
                0,
                false
            ),


            contactCard(
                "Hospital Emergency",
                "1066",
                0,
                false
            ),




            const SizedBox(
              height:20,
            ),




            const Text(

              "Add Family Contacts",

              style:
              TextStyle(

                fontSize:20,

                fontWeight:
                FontWeight.bold,

              ),

            ),




            TextField(

              controller:
              family1,

              keyboardType:
              TextInputType.phone,

              decoration:
              const InputDecoration(

                labelText:
                "Family Member 1",

              ),

            ),



            TextField(

              controller:
              family2,

              keyboardType:
              TextInputType.phone,

              decoration:
              const InputDecoration(

                labelText:
                "Family Member 2",

              ),

            ),




            TextField(

              controller:
              family3,

              keyboardType:
              TextInputType.phone,

              decoration:
              const InputDecoration(

                labelText:
                "Family Member 3",

              ),

            ),




            ElevatedButton(

              onPressed:
              saveContacts,


              child:

              const Text(
                  "Save Family Contacts"
              ),

            ),





            const SizedBox(
              height:20,
            ),




            const Text(

              "Saved Family Members",

              style:
              TextStyle(

                fontSize:20,

                fontWeight:
                FontWeight.bold,

              ),

            ),





            ListView.builder(

              shrinkWrap:true,

              physics:
              const NeverScrollableScrollPhysics(),


              itemCount:
              familyContacts.length,


              itemBuilder:
                  (context,index){


                return contactCard(

                  familyContacts[index]["name"]!,

                  familyContacts[index]["number"]!,

                  index,

                  true,

                );


              },


            )


          ],

        ),


      ),


    );


  }


}