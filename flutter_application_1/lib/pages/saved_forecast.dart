import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class SavedWeatherScreen extends StatefulWidget {
  @override
  _SavedWeatherScreenState createState() => _SavedWeatherScreenState();
}

class _SavedWeatherScreenState extends State<SavedWeatherScreen> {
  List<Map<String, String>> savedForecasts = [];

  @override
  void initState() {
    super.initState();
    _loadSavedForecasts();
  }

  Future<void> _loadSavedForecasts() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> savedData = prefs.getStringList('savedForecasts') ?? [];

    setState(() {
      savedForecasts = savedData
          .map((item) => Map<String, String>.from(jsonDecode(item)))
          .toList();
    });
  }

  Future<void> _clearSavedForecasts() async {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text("Clear saved forecasts?"),
            content: Text("This action cannot be undone."),
            actions: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text("Cancel",
                        style: TextStyle(
                            color:
                                Theme.of(context).colorScheme.inversePrimary)),
                  ),
                  TextButton(
                    onPressed: () async {
                      SharedPreferences prefs =
                          await SharedPreferences.getInstance();

                      await prefs.remove('savedForecasts');
                      setState(() {
                        savedForecasts.clear();
                      });
                      Navigator.pop(context);
                    },
                    child: Text("Clear",
                        style: TextStyle(
                            color:
                                Theme.of(context).colorScheme.inversePrimary)),
                  ),
                ],
              ),
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Saved Forecasts",
            style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.delete),
            onPressed: _clearSavedForecasts,
          ),
        ],
      ),
      body: savedForecasts.isEmpty
          ? Center(child: Text("No saved forecasts"))
          : ListView.builder(
              itemCount: savedForecasts.length,
              itemBuilder: (context, index) {
                final forecast = savedForecasts[index];
                return Card(
                  color: Theme.of(context).colorScheme.secondary,
                  margin: EdgeInsets.all(10),
                  child: ListTile(
                    title: Text('${forecast['city']} - ${forecast['date']}'),
                    subtitle: Text(
                        "${forecast['temp']} °C - ${forecast['description']}"),
                  ),
                );
              },
            ),
    );
  }
}
