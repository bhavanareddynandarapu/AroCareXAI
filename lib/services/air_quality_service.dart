import 'dart:convert';
import 'package:http/http.dart' as http;

class AirQualityData {
  final String location;
  final int aqi;
  final double temperature;

  AirQualityData({
    required this.location,
    required this.aqi,
    required this.temperature,
  });
}

class HydrationData {
  final double waterMl;
  final double litres;

  HydrationData({
    required this.waterMl,
    required this.litres,
  });
}

class AirQualityService {
  static Future<AirQualityData?> getAirQuality(
    String location,
  ) async {
    try {
      // Find location coordinates
      final geoUrl = Uri.parse(
        'https://nominatim.openstreetmap.org/search'
        '?q=${Uri.encodeComponent(location)}'
        '&format=json'
        '&limit=1',
      );

      final geoResponse = await http.get(
        geoUrl,
        headers: {
          'User-Agent': 'AroCareX-AI/1.0',
        },
      );

      if (geoResponse.statusCode != 200) {
        return null;
      }

      final List<dynamic> geoData =
          jsonDecode(geoResponse.body);

      if (geoData.isEmpty) {
        return null;
      }

      final latitude = double.tryParse(
        geoData[0]['lat'].toString(),
      );

      final longitude = double.tryParse(
        geoData[0]['lon'].toString(),
      );

      if (latitude == null || longitude == null) {
        return null;
      }

      // Get temperature
      final weatherUrl = Uri.parse(
        'https://api.open-meteo.com/v1/forecast'
        '?latitude=$latitude'
        '&longitude=$longitude'
        '&current=temperature_2m',
      );

      final weatherResponse =
          await http.get(weatherUrl);

      double temperature = 25.0;

      if (weatherResponse.statusCode == 200) {
        final weatherJson =
            jsonDecode(weatherResponse.body);

        temperature = double.tryParse(
              weatherJson['current']
                      ['temperature_2m']
                  .toString(),
            ) ??
            25.0;
      }

      // Get air quality
      final airUrl = Uri.parse(
        'https://air-quality-api.open-meteo.com/v1/air-quality'
        '?latitude=$latitude'
        '&longitude=$longitude'
        '&current=pm10,pm2_5',
      );

      final airResponse =
          await http.get(airUrl);

      int aqi = 50;

      if (airResponse.statusCode == 200) {
        final airJson =
            jsonDecode(airResponse.body);

        final current = airJson['current'];

        final pm25 = double.tryParse(
              current['pm2_5'].toString(),
            ) ??
            0.0;

        // Simple AQI approximation
        if (pm25 <= 12) {
          aqi = 50;
        } else if (pm25 <= 35.4) {
          aqi = 100;
        } else if (pm25 <= 55.4) {
          aqi = 150;
        } else if (pm25 <= 150.4) {
          aqi = 200;
        } else if (pm25 <= 250.4) {
          aqi = 300;
        } else {
          aqi = 400;
        }
      }

      return AirQualityData(
        location: location,
        aqi: aqi,
        temperature: temperature,
      );
    } catch (e) {
      return null;
    }
  }
}

