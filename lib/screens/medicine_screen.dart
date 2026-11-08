import 'package:flutter/material.dart';
import '../services/notification_service.dart';
import 'medicine_scanner_screen.dart';

class MedicineScreen extends StatefulWidget {

  const MedicineScreen({super.key});

  @override
  State<MedicineScreen> createState() => _MedicineScreenState();

}



class _MedicineScreenState extends State<MedicineScreen> {


  List<Map<String, dynamic>> medicines = [];


  final medicineController =
  TextEditingController();


  final dosageController =
  TextEditingController();


  TimeOfDay? selectedTime;



  Future<void> pickTime() async {

    TimeOfDay? time =
    await showTimePicker(

      context: context,

      initialTime: TimeOfDay.now(),

    );


    if(time != null){

      setState(() {

        selectedTime = time;

      });

    }

  }






  void addMedicine(){


    if(
    medicineController.text.isEmpty ||
        dosageController.text.isEmpty ||
        selectedTime == null
    ){

      ScaffoldMessenger.of(context).showSnackBar(

        const SnackBar(

          content:
          Text(
              "Enter medicine name, dosage and time"
          ),

        ),

      );


      return;

    }



    String name =
        medicineController.text;


    String dosage =
        dosageController.text;


    String time =
    selectedTime!.format(context);




    DateTime now =
    DateTime.now();



    DateTime alarmTime =
    DateTime(

      now.year,

      now.month,

      now.day,

      selectedTime!.hour,

      selectedTime!.minute,

    );



    if(alarmTime.isBefore(now)){

      alarmTime =
          alarmTime.add(
              const Duration(days:1)
          );

    }






    setState(() {


      medicines.add({

        "name":name,

        "dosage":dosage,

        "time":time,

        "status":"Pending"


      });



      medicineController.clear();

      dosageController.clear();

      selectedTime = null;


    });





    NotificationService.scheduleNotification(

      medicine:name,

      dosage:dosage,

      time:alarmTime,

    );




    ScaffoldMessenger.of(context).showSnackBar(

      SnackBar(

        content:
        Text(
            "$name reminder added"
        ),

      ),

    );


  }







  void deleteMedicine(int index){


    setState(() {

      medicines.removeAt(index);

    });


  }






  void markTaken(int index){


    setState(() {

      medicines[index]["status"] =
      "Taken";

    });


  }






  void markMissed(int index){


    setState(() {

      medicines[index]["status"] =
      "Missed";

    });


  }







  int get takenCount =>

      medicines
          .where(
              (m)=>m["status"]=="Taken"
      )
          .length;





  int get missedCount =>

      medicines
          .where(
              (m)=>m["status"]=="Missed"
      )
          .length;





  double get score{


    if(medicines.isEmpty){

      return 0;

    }


    return
      (takenCount / medicines.length) * 100;


  }

void openMedicineScanner() {

  Navigator.push(

    context,

    MaterialPageRoute(

      builder: (context) =>
      const MedicineScannerScreen(),

    ),

  );

}







  @override
  Widget build(BuildContext context) {


    return Scaffold(


      appBar: AppBar(

        title:
        const Text(
            "Medicine Reminder"
        ),

      ),




      body: SingleChildScrollView(


        child: Padding(


          padding:
          const EdgeInsets.all(16),



          child: Column(


            children: [



              TextField(

                controller:
                medicineController,


                decoration:
                const InputDecoration(

                  labelText:
                  "Medicine Name",

                  border:
                  OutlineInputBorder(),

                  prefixIcon:
                  Icon(Icons.medication),

                ),

              ),





              const SizedBox(height:10),





              TextField(

                controller:
                dosageController,


                decoration:
                const InputDecoration(

                  labelText:
                  "Dosage",

                  border:
                  OutlineInputBorder(),

                  prefixIcon:
                  Icon(Icons.medication_liquid),

                ),

              ),





              const SizedBox(height:10),





              Row(


                children: [


                  Expanded(

                    child:
                    Text(

                      selectedTime == null

                          ?

                      "No time selected"

                          :

                      selectedTime!
                          .format(context),

                      style:
                      const TextStyle(
                          fontSize:18
                      ),

                    ),

                  ),




                  ElevatedButton(

                    onPressed:
                    pickTime,

                    child:
                    const Text(
                        "Select Time"
                    ),

                  )


                ],

              ),






              const SizedBox(height:10),






              SizedBox(

                width:
                double.infinity,


                child:
                ElevatedButton(

                  onPressed:
                  addMedicine,


                  child:
                  const Text(
                      "Add Alarm"
                  ),

                ),

              ),
const SizedBox(height:10),


SizedBox(

  width: double.infinity,

  child: ElevatedButton.icon(

    icon: const Icon(
      Icons.document_scanner,
    ),

    label: const Text(
      "Scan Medicine 💊",
    ),

    onPressed: openMedicineScanner,

  ),

),




              const SizedBox(height:10),






              Card(

                child:
                Padding(

                  padding:
                  const EdgeInsets.all(10),


                  child:
                  Column(

                    children: [


                      const Text(

                        "Medicine Adherence",

                        style:
                        TextStyle(

                          fontSize:18,

                          fontWeight:
                          FontWeight.bold,

                        ),

                      ),




                      Text(
                          "Taken : $takenCount"
                      ),



                      Text(
                          "Missed : $missedCount"
                      ),




                      Text(

                        "Score : ${score.toStringAsFixed(0)}%",

                        style:
                        const TextStyle(

                          color:
                          Colors.green,

                          fontWeight:
                          FontWeight.bold,

                        ),

                      ),


                    ],

                  ),

                ),

              ),





              const SizedBox(height:10),





              const Align(

                alignment:
                Alignment.centerLeft,


                child:
                Text(

                  "Today's Medicines",

                  style:
                  TextStyle(

                    fontSize:22,

                    fontWeight:
                    FontWeight.bold,

                  ),

                ),

              ),





              SizedBox(

                height:300,


                child:

                medicines.isEmpty


                    ?


                const Center(

                  child:
                  Text(
                      "No alarms added"
                  ),

                )



                    :


                ListView.builder(


                  itemCount:
                  medicines.length,


                  itemBuilder:
                      (context,index){



                    return Card(


                      child:
                      ListTile(



                        leading:
                        const CircleAvatar(

                          child:
                          Icon(
                              Icons.alarm
                          ),

                        ),




                        title:
                        Text(

                            medicines[index]["name"]

                        ),




                        subtitle:
                        Text(

                          "${medicines[index]["dosage"]} • ${medicines[index]["time"]}\nStatus: ${medicines[index]["status"]}",

                        ),





                        trailing:
                        Row(

                          mainAxisSize:
                          MainAxisSize.min,


                          children: [



                            IconButton(

                              icon:
                              const Icon(

                                Icons.check_circle,

                                color:
                                Colors.green,

                              ),


                              onPressed:(){

                                markTaken(index);

                              },

                            ),





                            IconButton(

                              icon:
                              const Icon(

                                Icons.cancel,

                                color:
                                Colors.orange,

                              ),


                              onPressed:(){

                                markMissed(index);

                              },

                            ),





                            IconButton(

                              icon:
                              const Icon(

                                Icons.delete,

                                color:
                                Colors.red,

                              ),


                              onPressed:(){

                                deleteMedicine(index);

                              },

                            ),


                          ],

                        ),


                      ),

                    );


                  },


                ),

              ),



            ],


          ),


        ),


      ),


    );


  }






  @override
  void dispose(){


    medicineController.dispose();

    dosageController.dispose();


    super.dispose();


  }



}