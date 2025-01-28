import 'dart:convert';
import 'package:http/http.dart' as http;

class WeatherService {
  final String apiKey =
      '0aef281af281703a7f3aef6e06768d87'; // Replace with your actual API key

  // Fetch current weather by city name
  Future<Map<String, dynamic>> fetchWeather(String city) async {
    final url = Uri.parse(
      'https://api.openweathermap.org/data/2.5/weather?q=$city&appid=$apiKey&units=metric',
    );

    final response = await http.get(url);

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      print('Error: ${response.statusCode}');
      print('Response body: ${response.body}');
      throw Exception('Failed to load weather data');
    }
  }

  // Fetch 5-day weather forecast by city name
  Future<Map<String, dynamic>> fetchForecast(String city) async {
    final url = Uri.parse(
      'https://api.openweathermap.org/data/2.5/forecast?q=$city&appid=$apiKey&units=metric',
    );

    final response = await http.get(url);

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      print('Error: ${response.statusCode}');
      print('Response body: ${response.body}');
      throw Exception('Failed to load forecast data');
    }
  }
}
