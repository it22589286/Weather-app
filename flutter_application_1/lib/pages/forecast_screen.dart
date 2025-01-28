import 'package:flutter/material.dart';
import 'package:flutter_application_1/components/my_button.dart';

import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'dart:convert';

import 'package:flutter_application_1/auth/weather_details.dart';

class ForecastScreen extends StatefulWidget {
  final String city;

  ForecastScreen({required this.city});

  @override
  _ForecastScreenState createState() => _ForecastScreenState();
}

class _ForecastScreenState extends State<ForecastScreen> {
  Future<Map<String, dynamic>> _getForecast() async {
    return await WeatherService().fetchForecast(widget.city);
  }

  // Save forecast to SharedPreferences
  Future<void> _saveForecast(
      String date, String temp, String description, String city) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> savedForecasts = prefs.getStringList('savedForecasts') ?? [];

    // Create forecast data object
    Map<String, String> forecastData = {
      'city': city,
      'date': date,
      'temp': temp,
      'description': description,
    };

    savedForecasts.add(jsonEncode(forecastData));
    await prefs.setStringList('savedForecasts', savedForecasts);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Saved forecast for $date")),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          '5-Day Forecast for ${widget.city}',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: SizedBox(
        height: MediaQuery.of(context).size.height * 0.7,
        child: FutureBuilder<Map<String, dynamic>>(
          future: _getForecast(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            }

            if (snapshot.hasError) {
              return Center(
                child: Text('Error: ${snapshot.error}',
                    style: TextStyle(fontSize: 18, color: Colors.red)),
              );
            }

            final forecastData = snapshot.data!['list'];

            return Padding(
              padding: EdgeInsets.all(16.0),
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: forecastData.length,
                itemBuilder: (context, index) {
                  final dayData = forecastData[index];
                  final date =
                      DateTime.fromMillisecondsSinceEpoch(dayData['dt'] * 1000);
                  final formattedDate = DateFormat('EEE, MMM d').format(date);
                  final temp = dayData['main']['temp'].toString();
                  final description = dayData['weather'][0]['description'];
                  final iconCode = dayData['weather'][0]['icon'];

                  return Container(
                    width: 250,
                    margin: EdgeInsets.symmetric(horizontal: 8),
                    child: Card(
                      elevation: 6,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      color: Colors.grey.shade500,
                      child: Padding(
                        padding: EdgeInsets.all(12),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              formattedDate,
                              style: TextStyle(
                                  fontSize: 40,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
                            ),
                            SizedBox(height: 10),
                            Image.network(
                              'https://openweathermap.org/img/wn/$iconCode@2x.png',
                              width: 150,
                              height: 150,
                            ),
                            SizedBox(height: 10),
                            Text(
                              '$temp °C',
                              style: TextStyle(
                                  fontSize: 30,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
                            ),
                            SizedBox(height: 8),
                            Text(
                              description.toUpperCase(),
                              textAlign: TextAlign.center,
                              style:
                                  TextStyle(fontSize: 14, color: Colors.white),
                            ),
                            SizedBox(height: 40),
                            MyButton(
                              text: 'Save',
                              onTap: () {
                                _saveForecast(formattedDate, temp, description,
                                    widget.city);
                              },
                            )
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            );
          },
        ),
      ),
    );
  }
}
