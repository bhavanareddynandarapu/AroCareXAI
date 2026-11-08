import 'package:shared_preferences/shared_preferences.dart';


class HealthProfileService {


static Future<void> saveProfile({

required String age,
required String height,
required String weight,
required String gender,
required String bloodGroup,
required String medicalHistory,
required String emergency,

}) async {


final prefs =
await SharedPreferences.getInstance();


await prefs.setString("age", age);

await prefs.setString("height", height);

await prefs.setString("weight", weight);

await prefs.setString("gender", gender);

await prefs.setString("bloodGroup", bloodGroup);

await prefs.setString(
"medicalHistory",
medicalHistory
);

await prefs.setString(
"emergency",
emergency
);


}




static Future<Map<String,String>> getProfile()
async{


final prefs =
await SharedPreferences.getInstance();


return {


"age":
prefs.getString("age") ?? "",


"height":
prefs.getString("height") ?? "",


"weight":
prefs.getString("weight") ?? "",


"gender":
prefs.getString("gender") ?? "",


"bloodGroup":
prefs.getString("bloodGroup") ?? "",


"medicalHistory":
prefs.getString("medicalHistory") ?? "",


"emergency":
prefs.getString("emergency") ?? "",


};


}


}