import 'package:app_weather/services/weather_services.dart';
import 'package:app_weather/models/weather_model.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';


class WeatherPage extends StatefulWidget {
  const WeatherPage({super.key});

  @override
  State<WeatherPage> createState() => _WeatherPageState();
}

class _WeatherPageState extends State<WeatherPage> {

  // clé api
    final _weatherSerice = WeatherService('0f5cf2369285e55bac8c0f133ba69ea6');
    Weather? _weather;


  // fetcher la météo
  _fetchWeather() async {
    // Prendre la ville actuelle
    String cityName = await _weatherSerice.getCurrentCity();

    // Prendre la météo par ville
    try {
      final weather = await _weatherSerice.getWeather(cityName);
      setState(() {
        _weather = weather;
      });
    }
    // Si erreurs
    catch (e) {
      print(e);
    }
  }

    
    
  // animation du météo
  String getWeatherAnimation(String? mainCondition) {
    if (mainCondition == null) return 'assets/sunny.json'; // on met soleil par defaut

    switch (mainCondition.toLowerCase()){
      case 'clouds':
      case 'mist':
      case 'smoke':
      case 'haze':
      case 'dust':
      case 'fog':
        return 'assets/cloud.json';
      case 'rain':
      case 'drizzle':
      case 'shower rain':
        return 'assets/rain.json';
      case 'thunderstorm':
        return 'assets/thunder.json';
      case 'clear':
        return 'assets/sunny.json';
      default:
        return 'assets/sunny.json';
    }
  }

// init State
@override
  void initState() {
    // TODO: implement initState
    super.initState();

    // fetcher la météo dans startup
    _fetchWeather();

  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:Center ( 
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
        children: [
            // Nom de la ville
            Text(_weather?.cityName ?? "Loading city.."),

            // Animation
            Lottie.asset(getWeatherAnimation(_weather?.mainCondition)),

            // Temperature
            Text('${_weather?.temperature.round()}°C'),

            // Condition
            Text(_weather?.mainCondition ?? ""),
              ],
            ),
          ),
        );
  }
}