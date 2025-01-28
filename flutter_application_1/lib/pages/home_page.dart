import 'package:flutter/material.dart';
import 'package:flutter_application_1/auth/weather_details.dart';
import 'package:flutter_application_1/components/my_button.dart';
import 'package:flutter_application_1/components/my_drawer.dart';
import 'package:flutter_application_1/components/my_textField.dart';

import 'forecast_screen.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _cityController = TextEditingController();
  Map<String, dynamic>? weatherData;
  bool isLoading = false;
  String errorMessage = '';
  bool isCelsius = true;

  // Get weather data
  Future<void> _getWeatherData() async {
    final city = _cityController.text.trim();
    if (city.isEmpty) return;

    setState(() {
      isLoading = true;
      errorMessage = '';
    });

    try {
      final weather = await WeatherService().fetchWeather(city);
      setState(() {
        weatherData = weather;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
        errorMessage =
            'Failed to load weather data. Please check the city name.';
      });
    }
  }

  // Function to convert temperature
  double _convertTemperature(double temp) {
    return isCelsius ? temp : (temp * 9 / 5) + 32;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
          title: Text(
            'Weather App',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          centerTitle: true),
      drawer: MyDrawer(),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            children: [
              Container(
                height: MediaQuery.of(context).size.height * 0.3,
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Theme.of(context).colorScheme.primary,
                  image: DecorationImage(
                    image: AssetImage('assets/weather.png'),
                    fit: BoxFit.contain,
                  ),
                ),
              ),
              SizedBox(height: 20),
              MyTextField(
                controller: _cityController,
                hintText: 'Enter city name',
                obscureText: false,
                maxLines: 1,
              ),
              SizedBox(height: 10),
              MyButton(
                onTap: _getWeatherData,
                text: 'Get Weather',
              ),
              if (isLoading) CircularProgressIndicator(),
              if (errorMessage.isNotEmpty)
                Text(errorMessage, style: TextStyle(color: Colors.red)),
              // Check if city is empty and show a message
              if (_cityController.text.isEmpty)
                Padding(
                  padding: EdgeInsets.only(top: 20),
                  child: Text(
                    'Please enter a city to get the weather',
                    style: TextStyle(fontSize: 20, color: Colors.grey),
                  ),
                ),
              // Display weather data if available
              if (weatherData != null && _cityController.text.isNotEmpty) ...[
                SizedBox(height: 20),
                Container(
                  width: MediaQuery.of(context).size.width,
                  child: Card(
                    color: Theme.of(context).colorScheme.secondary,
                    elevation: 4, // Adds a subtle shadow effect
                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(15), // Rounded corners
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(16),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            ' ${weatherData!['name']} weather',
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                          SizedBox(height: 10),
                          Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: Colors.blueAccent.withOpacity(0.8)),
                            height: MediaQuery.of(context).size.height * 0.2,
                            width: MediaQuery.of(context).size.width,
                            child: Image.network(
                              'https://openweathermap.org/img/wn/${weatherData!['weather'][0]['icon']}@2x.png',
                              fit: BoxFit.contain,
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Temperature: ${_convertTemperature(weatherData!['main']['temp']).toStringAsFixed(1)} ${isCelsius ? '°C' : '°F'}',
                                style: TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(width: 20),
                              Text(
                                '°C',
                                style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color:
                                        isCelsius ? Colors.blue : Colors.grey),
                              ),
                              Switch(
                                value: isCelsius,
                                onChanged: (value) {
                                  setState(() {
                                    isCelsius = value;
                                  });
                                },
                              ),
                              Text(
                                '°F',
                                style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color:
                                        !isCelsius ? Colors.blue : Colors.grey),
                              ),
                            ],
                          ),
                          SizedBox(height: 10),
                          Row(
                            children: [
                              Text(
                                'Condition: ${weatherData!['weather'][0]['description']}',
                                style: TextStyle(fontSize: 18),
                              ),
                            ],
                          ),
                          SizedBox(height: 10),
                          SizedBox(height: 20),
                          MyButton(
                            text: "Get 5 day Forecast",
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ForecastScreen(
                                      city: _cityController.text),
                                ),
                              );
                            },
                          )
                        ],
                      ),
                    ),
                  ),
                )
              ]
            ],
          ),
        ),
      ),
    );
  }
}
