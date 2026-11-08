```dart
import 'dart:convert';
import 'package:http/http.dart' as http;

class HydrationData {
  final String location;
  final double temperature;

  HydrationData({
    required this.location,
    required this.temperature,
  });
}

class HydrationService {
  // Search city/location
  static Future<Map<String, dynamic>?> searchLocation(
      String location) async {
    try {
      final url = Uri.parse(
        'https://geocoding-api.open-meteo.com/v1/search'
        '?name=${Uri.encodeComponent(location)}'
        '&count=1'
        '&language=en'
        '&format=json',
      );

      final response = await http.get(url);

      if (response.statusCode != 200) {
        return null;
      }

      final data = jsonDecode(response.body);

      if (data['results'] == null ||
          data['results'].isEmpty) {
        return null;
      }

      return data['results'][0];
    } catch (e) {
      return null;
    }
  }

  // Get current temperature
  static Future<HydrationData?> getHydrationData(
      String location) async {
    try {
      final place = await searchLocation(location);

      if (place == null) {
        return null;
      }

      final latitude =
          (place['latitude'] as num).toDouble();

      final longitude =
          (place['longitude'] as num).toDouble();

      final cityName =
          place['name']?.toString() ?? location;

      final url = Uri.parse(
        'https://api.open-meteo.com/v1/forecast'
        '?latitude=$latitude'
        '&longitude=$longitude'
        '&current=temperature_2m'
        '&temperature_unit=celsius'
        '&timezone=auto',
      );

      final response = await http.get(url);

      if (response.statusCode != 200) {
        return null;
      }

      final data = jsonDecode(response.body);

      final temperature =
          (data['current']['temperature_2m'] as num)
              .toDouble();

      return HydrationData(
        location: cityName,
        temperature: temperature,
      );
    } catch (e) {
      return null;
    }
  }

  // Calculate recommended water.
  //
  // This is a general estimate, not a medical prescription.
  static int calculateWater({
    required double weight,
    required double temperature,
  }) {
    // Base: 35 ml per kg.
    double water = weight * 35;

    // Heat adjustment.
    if (temperature >= 35) {
      water += 600;
    } else if (temperature >= 30) {
      water += 400;
    } else if (temperature >= 25) {
      water += 200;
    }

    return water.round();
  }

  static String temperatureAdvice(double temperature) {
    if (temperature >= 35) {
      return "Very hot weather. Pay extra attention to hydration and avoid prolonged heat exposure.";
    }

    if (temperature >= 30) {
      return "Hot weather. Increase fluids, especially if you are outdoors or sweating.";
    }

    if (temperature >= 25) {
      return "Warm weather. Drink fluids regularly throughout the day.";
    }

    return "Temperature is relatively comfortable. Maintain regular fluid intake.";
  }

  static List<String> getPrecautions(
      double temperature) {
    if (temperature >= 35) {
      return [
        "Drink fluids regularly throughout the day.",
        "Avoid prolonged exposure to extreme heat.",
        "Take breaks in a cool or shaded place.",
        "Increase fluids when sweating heavily.",
        "Do not wait until severe thirst develops.",
        "Seek medical help for confusion, fainting, or severe heat symptoms.",
      ];
    }

    if (temperature >= 30) {
      return [
        "Drink water regularly.",
        "Increase fluids during exercise or heavy sweating.",
        "Avoid prolonged outdoor activity during the hottest part of the day.",
        "Take breaks in shade or a cool environment.",
        "Keep a water bottle with you.",
      ];
    }

    if (temperature >= 25) {
      return [
        "Drink water regularly throughout the day.",
        "Increase fluids during exercise.",
        "Carry a water bottle when going outside.",
        "Monitor thirst and urine color as general hydration indicators.",
      ];
    }

    return [
      "Drink fluids regularly throughout the day.",
      "Drink extra fluids during exercise.",
      "Keep a water bottle nearby.",
      "Maintain a balanced diet containing water-rich foods.",
    ];
  }
}
```
