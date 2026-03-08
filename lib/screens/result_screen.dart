import 'package:flutter/material.dart';
import '../services/weather_service.dart';

class ResultScreen extends StatefulWidget {
  final String city;
  const ResultScreen({super.key, required this.city});

  @override
  State<ResultScreen> createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen> {
  late Future<Map<String, dynamic>> weatherData;

  @override
  void initState() {
    super.initState();
    weatherData = WeatherService.getWeather(widget.city);
  }

  // 🎨 Background based on weather
  LinearGradient getBackground(String weather) {
    weather = weather.toLowerCase();

    if (weather.contains("rain")) {
      return const LinearGradient(
        colors: [Colors.blueGrey, Colors.blue],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      );
    } else if (weather.contains("cloud")) {
      return const LinearGradient(
        colors: [Colors.grey, Colors.blueGrey],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      );
    } else {
      return const LinearGradient(
        colors: [Colors.orange, Colors.yellow],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      );
    }
  }

  // ☀️ Weather icon
  IconData getWeatherIcon(String weather) {
    weather = weather.toLowerCase();

    if (weather.contains("rain")) {
      return Icons.umbrella;
    } else if (weather.contains("cloud")) {
      return Icons.cloud;
    } else {
      return Icons.wb_sunny;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: weatherData,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return const Center(child: Text("City not found"));
          }

          final data = snapshot.data!;
          final weather = data['weather'][0]['description'];

          return Container(
            decoration: BoxDecoration(
              gradient: getBackground(weather),
            ),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // 🟦 Weather Card
                  Card(
                    elevation: 8,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    margin: const EdgeInsets.all(20),
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            getWeatherIcon(weather),
                            size: 60,
                          ),
                          const SizedBox(height: 10),
                          Text(
                            data['name'],
                            style: const TextStyle(
                              fontSize: 26,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            "${data['main']['temp']} °C",
                            style: const TextStyle(
                              fontSize: 40,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            weather.toUpperCase(),
                            style: const TextStyle(fontSize: 18),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            "Humidity: ${data['main']['humidity']}%",
                            style: const TextStyle(fontSize: 16),
                          ),
                        ],
                      ),
                    ),
                  ),

                  // 📘 Weather Legend (for unknown users)
                  const SizedBox(height: 10),
                  Card(
                    color: Colors.white70,
                    margin: const EdgeInsets.symmetric(horizontal: 20),
                    child: Padding(
                      padding: const EdgeInsets.all(10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: const [
                          Row(
                            children: [
                              Icon(Icons.wb_sunny, color: Colors.orange),
                              SizedBox(width: 4),
                              Text("Sunny"),
                            ],
                          ),
                          Row(
                            children: [
                              Icon(Icons.cloud, color: Colors.grey),
                              SizedBox(width: 4),
                              Text("Cloudy"),
                            ],
                          ),
                          Row(
                            children: [
                              Icon(Icons.umbrella, color: Colors.blue),
                              SizedBox(width: 4),
                              Text("Rainy"),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
