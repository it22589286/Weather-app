# Weather app

This is a Flutter-based weather application that allows users to search for weather data, view a 5-day forecast, and save the forecast data using SharedPreferences. The app allows users to toggle between Celsius and Fahrenheit temperatures.



Setting up the App

First, clone the repository to your local machine: 

Once inside the project directory, run the following command to fetch the required dependencies: flutter pub get

In your lib/auth/weather_details.dart, update the API key in the WeatherService class:

static const String _apiKey = 'YOUR_API_KEY';

Once the setup is complete, you can run the app either on an emulator or a real device:flutter run

##App Features
Weather Search: Users can search for weather data by entering a city name.
5-Day Forecast: Displays a 5-day weather forecast with temperatures, weather descriptions, and icons.
Save Forecasts: Users can save their favorite forecasts (city, date, temperature, and description) using SharedPreferences.
View Saved Forecasts: Saved forecasts are displayed in a separate screen.
Toggle between Celsius and Fahrenheit: Allows users to toggle between temperature units (Celsius/Fahrenheit).
toggle between dark and light modes.



Localization:

The app only supports English for displaying weather descriptions and data.
It doesn't handle localization for different languages at the moment.

For the reusability  components like textfileds,buttons have implemented seperatly













 
