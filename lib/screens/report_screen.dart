import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:url_launcher/url_launcher.dart';

import '../models/medical_report.dart';


class ReportScreen extends StatefulWidget {
  const ReportScreen({super.key});

  @override
  State<ReportScreen> createState() => _ReportScreenState();
}


class _ReportScreenState extends State<ReportScreen> {

  List<MedicalReport> reports = [];


  Future<void> pickReport() async {

    FilePickerResult? result =
        await FilePicker.platform.pickFiles();

    if(result != null){

      PlatformFile file = result.files.first;


      String type = "Medical Report";

      String suggestion =
          "AI Analysis: Please consult your doctor for detailed interpretation.";


      MedicalReport report = MedicalReport(

        name: file.name,

        type: type,

        filePath: file.path ?? "",

        fileUrl: null,

        aiSuggestion: suggestion,

        date: DateTime.now().toString(),

      );


      setState(() {

        reports.add(report);

      });

    }

  }



  Future<void> openFile(String url) async {

    final Uri uri = Uri.parse(url);

    if(await canLaunchUrl(uri)){

      await launchUrl(uri);

    }

  }



  void deleteReport(int index){

    setState(() {

      reports.removeAt(index);

    });

  }



  @override
  Widget build(BuildContext context) {

    return Scaffold(

      appBar: AppBar(

        title: const Text(
          "Medical Reports",
        ),

        backgroundColor: Colors.blue,

      ),


      body: reports.isEmpty

          ? const Center(

              child: Text(
                "No reports uploaded",
                style: TextStyle(
                  fontSize:18,
                ),
              ),

            )


          : ListView.builder(

              itemCount: reports.length,

              itemBuilder:(context,index){


                MedicalReport report =
                    reports[index];


                return Card(

                  margin: const EdgeInsets.all(10),


                  child: ListTile(


                    leading: const Icon(
                      Icons.description,
                      color: Colors.blue,
                    ),


                    title: Text(
                      report.name,
                    ),


                    subtitle: Column(

                      crossAxisAlignment:
                          CrossAxisAlignment.start,


                      children: [


                        Text(
                          "Type: ${report.type}",
                        ),


                        Text(
                          "Date: ${report.date}",
                        ),


                        const SizedBox(
                          height:5,
                        ),


                        Text(
                          report.aiSuggestion,
                        ),

                      ],

                    ),



                    trailing: PopupMenuButton(


                      itemBuilder:(context)=>[


                        const PopupMenuItem(

                          value:"open",

                          child:Text(
                            "Open File",
                          ),

                        ),



                        const PopupMenuItem(

                          value:"delete",

                          child:Text(
                            "Delete",
                          ),

                        ),


                      ],


                      onSelected:(value){


                        if(value=="open"){


                          if(report.fileUrl != null){

                            openFile(
                              report.fileUrl!,
                            );

                          }


                        }


                        if(value=="delete"){

                          deleteReport(index);

                        }


                      },


                    ),


                  ),

                );


              },

            ),




      floatingActionButton: FloatingActionButton(

        onPressed: pickReport,

        child: const Icon(
          Icons.upload_file,
        ),

      ),


    );

  }

}