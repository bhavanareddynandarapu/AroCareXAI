import 'package:shared_preferences/shared_preferences.dart';


class EmergencyContacts {

  static List<String> contacts = [];


  static Future<void> loadContacts() async {

    final prefs = await SharedPreferences.getInstance();

    contacts = prefs.getStringList("contacts") ?? [];

  }


  static Future<void> saveContact(String number) async {

    contacts.add(number);

    final prefs = await SharedPreferences.getInstance();

    await prefs.setStringList(
      "contacts",
      contacts,
    );

  }


  static Future<void> deleteContact(int index) async {

    contacts.removeAt(index);

    final prefs = await SharedPreferences.getInstance();

    await prefs.setStringList(
      "contacts",
      contacts,
    );

  }

}