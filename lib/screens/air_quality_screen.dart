import 'package:flutter/material.dart';
import '../services/air_quality_service.dart';

class AirQualityScreen extends StatefulWidget {
  const AirQualityScreen({super.key});

  @override
  State<AirQualityScreen> createState() => _AirQualityScreenState();
}

class _AirQualityScreenState extends State<AirQualityScreen> {
  final TextEditingController locationController =
      TextEditingController();

  AirQualityData? airData;
  HydrationData? hydrationData;

  bool isLoading = false;
  String errorMessage = '';

  @override
  void dispose() {
    locationController.dispose();
    super.dispose();
  }

  Future<void> checkAirQuality() async {
    final location = locationController.text.trim();

    if (location.isEmpty) {
      setState(() {
        errorMessage = 'Please enter your location.';
      });
      return;
    }

    setState(() {
      isLoading = true;
      errorMessage = '';
      airData = null;
      hydrationData = null;
    });

    try {
      final result =
          await AirQualityService.getAirQuality(location);

      if (result == null) {
        setState(() {
          errorMessage =
              'Could not find air quality data for this location.';
          isLoading = false;
        });
        return;
      }

      final temperature = result.temperature;

      // Hydration is now calculated using temperature only.
      final hydration = calculateHydration(
        temperature: temperature,
      );

      setState(() {
        airData = result;
        hydrationData = hydration;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        errorMessage =
            'Unable to get data. Please check your internet connection.';
        isLoading = false;
      });
    }
  }

  HydrationData calculateHydration({
    required double temperature,
  }) {
    double waterMl;

    // General hydration recommendation based on temperature.
    if (temperature >= 35) {
      waterMl = 3500;
    } else if (temperature >= 30) {
      waterMl = 3000;
    } else if (temperature >= 25) {
      waterMl = 2500;
    } else {
      waterMl = 2000;
    }

    final litres = waterMl / 1000;

    return HydrationData(
      waterMl: waterMl,
      litres: litres,
    );
  }

  String getAqiStatus(int aqi) {
    if (aqi <= 50) {
      return 'Good';
    } else if (aqi <= 100) {
      return 'Moderate';
    } else if (aqi <= 150) {
      return 'Unhealthy for Sensitive Groups';
    } else if (aqi <= 200) {
      return 'Unhealthy';
    } else if (aqi <= 300) {
      return 'Very Unhealthy';
    } else {
      return 'Hazardous';
    }
  }

  IconData getAqiIcon(int aqi) {
    if (aqi <= 50) {
      return Icons.sentiment_very_satisfied;
    } else if (aqi <= 100) {
      return Icons.sentiment_satisfied;
    } else if (aqi <= 150) {
      return Icons.sentiment_neutral;
    } else {
      return Icons.warning_amber_rounded;
    }
  }

  List<String> getPrecautions(int aqi) {
    if (aqi <= 50) {
      return [
        'Air quality is good.',
        'Outdoor activities are generally safe.',
        'Keep yourself hydrated.',
      ];
    }

    if (aqi <= 100) {
      return [
        'Air quality is acceptable.',
        'Sensitive people should monitor symptoms.',
        'Stay hydrated.',
        'Avoid prolonged exposure if you feel uncomfortable.',
      ];
    }

    if (aqi <= 150) {
      return [
        'Sensitive people should reduce prolonged outdoor activity.',
        'Children and elderly people should take extra care.',
        'Consider wearing a suitable mask in polluted areas.',
        'Keep windows closed during pollution peaks.',
      ];
    }

    if (aqi <= 200) {
      return [
        'Avoid prolonged outdoor activities.',
        'Wear a suitable pollution mask outdoors.',
        'Keep doors and windows closed.',
        'Sensitive people should remain indoors when possible.',
      ];
    }

    if (aqi <= 300) {
      return [
        'Avoid outdoor activities.',
        'Stay indoors as much as possible.',
        'Keep windows and doors closed.',
        'Use an air purifier if available.',
      ];
    }

    return [
      'Avoid going outdoors.',
      'Stay indoors and keep windows closed.',
      'Use an air purifier if available.',
      'People with breathing problems should take extra precautions.',
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Air Quality & Hydration',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Icon(
                Icons.air,
                size: 70,
              ),

              const SizedBox(height: 12),

              const Text(
                'Check Air Quality',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 8),

              const Text(
                'Enter your location to get air quality, temperature, hydration and precautions.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 15,
                  color: Colors.grey,
                ),
              ),

              const SizedBox(height: 25),

              // LOCATION
              TextField(
                controller: locationController,
                textInputAction: TextInputAction.done,
                decoration: InputDecoration(
                  labelText: 'Location',
                  hintText: 'Example: Bengaluru',
                  prefixIcon: const Icon(Icons.location_on),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // CHECK BUTTON
              SizedBox(
                height: 52,
                child: ElevatedButton.icon(
                  onPressed:
                      isLoading ? null : checkAirQuality,
                  icon: isLoading
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                          ),
                        )
                      : const Icon(Icons.search),
                  label: Text(
                    isLoading
                        ? 'Checking...'
                        : 'Check',
                  ),
                ),
              ),

              // ERROR MESSAGE
              if (errorMessage.isNotEmpty) ...[
                const SizedBox(height: 20),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(15),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.error_outline,
                          color: Colors.red,
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            errorMessage,
                            style: const TextStyle(
                              color: Colors.red,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],

              // AIR QUALITY RESULT
              if (airData != null) ...[
                const SizedBox(height: 25),

                _buildSectionTitle(
                  'Air Quality',
                  Icons.air,
                ),

                const SizedBox(height: 10),

                Card(
                  elevation: 4,
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      children: [
                        Icon(
                          getAqiIcon(airData!.aqi),
                          size: 65,
                        ),

                        const SizedBox(height: 10),

                        Text(
                          'AQI ${airData!.aqi}',
                          style: const TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        const SizedBox(height: 5),

                        Text(
                          getAqiStatus(airData!.aqi),
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 19,
                            fontWeight: FontWeight.w600,
                          ),
                        ),

                        const SizedBox(height: 20),

                        const Divider(),

                        const SizedBox(height: 10),

                        _infoRow(
                          Icons.location_on,
                          'Location',
                          airData!.location,
                        ),

                        _infoRow(
                          Icons.thermostat,
                          'Temperature',
                          '${airData!.temperature.toStringAsFixed(1)} °C',
                        ),

                        _infoRow(
                          Icons.cloud,
                          'Pollution Level',
                          getAqiStatus(airData!.aqi),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 25),

                // PRECAUTIONS
                _buildSectionTitle(
                  'Precautions',
                  Icons.health_and_safety,
                ),

                const SizedBox(height: 10),

                Card(
                  elevation: 3,
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: getPrecautions(airData!.aqi)
                          .map(
                            (precaution) => ListTile(
                              contentPadding: EdgeInsets.zero,
                              leading: const Icon(
                                Icons.check_circle_outline,
                              ),
                              title: Text(precaution),
                            ),
                          )
                          .toList(),
                    ),
                  ),
                ),
              ],

              // HYDRATION
              if (hydrationData != null) ...[
                const SizedBox(height: 25),

                _buildSectionTitle(
                  'Hydration Assistant',
                  Icons.water_drop,
                ),

                const SizedBox(height: 10),

                Card(
                  elevation: 4,
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      children: [
                        const Icon(
                          Icons.water_drop,
                          size: 65,
                        ),

                        const SizedBox(height: 10),

                        const Text(
                          'Recommended Daily Water',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),

                        const SizedBox(height: 10),

                        Text(
                          '${hydrationData!.litres.toStringAsFixed(1)} L',
                          style: const TextStyle(
                            fontSize: 35,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        const SizedBox(height: 5),

                        Text(
                          '${hydrationData!.waterMl.toStringAsFixed(0)} ml per day',
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.grey,
                          ),
                        ),

                        const SizedBox(height: 15),

                        const Divider(),

                        const SizedBox(height: 10),

                        const Text(
                          'Hydration Tips',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        const SizedBox(height: 10),

                        const ListTile(
                          contentPadding: EdgeInsets.zero,
                          leading: Icon(Icons.water),
                          title: Text(
                            'Drink water regularly throughout the day.',
                          ),
                        ),

                        const ListTile(
                          contentPadding: EdgeInsets.zero,
                          leading: Icon(Icons.wb_sunny),
                          title: Text(
                            'Drink more water in hot weather.',
                          ),
                        ),

                        const ListTile(
                          contentPadding: EdgeInsets.zero,
                          leading: Icon(Icons.directions_walk),
                          title: Text(
                            'Increase fluids during physical activity.',
                          ),
                        ),

                        const ListTile(
                          contentPadding: EdgeInsets.zero,
                          leading: Icon(Icons.local_drink),
                          title: Text(
                            'Do not wait until you are very thirsty.',
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],

              const SizedBox(height: 30),

              const Text(
                'Note: Hydration recommendations are general estimates. Individual needs can vary depending on activity, health and climate.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey,
                ),
              ),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(
    String title,
    IconData icon,
  ) {
    return Row(
      children: [
        Icon(icon),
        const SizedBox(width: 8),
        Text(
          title,
          style: const TextStyle(
            fontSize: 21,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _infoRow(
    IconData icon,
    String title,
    String value,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(icon),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              title,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Flexible(
            child: Text(
              value,
              textAlign: TextAlign.right,
            ),
          ),
        ],
      ),
    );
  }
}