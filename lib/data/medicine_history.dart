import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';


class MedicineHistory {


static Future<void> save(String data) async {


final prefs =
await SharedPreferences.getInstance();


List<String> history =
prefs.getStringList("medicine_history") ?? [];


history.add(data);


await prefs.setStringList(
"medicine_history",
history
);


}


static Future<List<String>> getHistory() async{


final prefs =
await SharedPreferences.getInstance();


return prefs.getStringList(
"medicine_history"
) ?? [];


}


}