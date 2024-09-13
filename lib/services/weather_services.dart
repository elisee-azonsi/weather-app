import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'dart:convert';

import '../models/weather_model.dart';
import 'package:http/http.dart' as http;

class WeatherService{
  static const BASE_URL = 'http://api.openweathermap.org/data/2.5/weather';
  final String apiKey;

  WeatherService(this.apiKey);

  Future<Weather> getWeather(String cityName) async{
    final response = await http
    .get(Uri.parse('$BASE_URL?q=$cityName&appid=$apiKey&units=metric'));
    
    if(response.statusCode == 200) {
      return Weather.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load weather data');
    }
  }

// Prendre la permission de l'utilisateur
  Future<String> getCurrentCity() async {
    LocationPermission permission = await Geolocator.checkPermission();
    if(permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

// Fetcher la position actuel
  Position position = await Geolocator.getCurrentPosition(
    desiredAccuracy: LocationAccuracy.high
  );

  // Convertir la position dans une liste des objets
    List<Placemark> placemarks = 
        await placemarkFromCoordinates(position.latitude, position.longitude);
      
  // Prendre la ville depuis la première list
    String? city = placemarks[0].locality;
    
    return city ?? "";
  }
}