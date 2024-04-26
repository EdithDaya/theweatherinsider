import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:weatherinsider/profile_screen.dart';
import 'package:weatherinsider/radar_map_screen.dart';
import 'package:weatherinsider/settings_screen.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<StatefulWidget> {
  TextEditingController _locationController = TextEditingController();
  String _weatherData = '';
  String _weatherIcon = '';
  int _temperature = 0;
  List<int> _forecastTemperatures = [];
  List<String> _forecastDayNames = [];
  List<int> _hourlyTemperatures = [];
  List<String> _hourlyTimes = [];


Future<void> _fetchWeatherData(String location) async {
    // Replace 'YOUR_API_KEY' with your actual API key
    String apiKey = '55bb934e4002a29570a751cbef833e44';
    String apiUrl =
        'http://api.openweathermap.org/data/2.5/forecast?q=$location&appid=$apiKey';
    try {
      final response = await http.get(Uri.parse(apiUrl));
      final jsonData = json.decode(response.body);

      // Extracting current weather data
      final currentWeather = jsonData['list'][0]['main'];
      setState(() {
        _weatherData = jsonData['list'][0]['weather'][0]['description'];
        _weatherIcon =
            _getWeatherIcon(jsonData['list'][0]['weather'][0]['main']);
        _temperature = ((currentWeather['temp'] - 273.15) * 9 / 5 + 32)
            .round(); // Convert temperature to Fahrenheit
      });

      // Extracting forecast data for the next 24 hours (hourly forecast)
      List<int> hourlyTemperatures = [];
      List<String> hourlyTimes = [];

      for (int i = 0; i < jsonData['list'].length; i++) {
        var forecast = jsonData['list'][i];
        var forecastDateTime =
            DateTime.fromMillisecondsSinceEpoch(forecast['dt'] * 1000);
        if (forecastDateTime.hour > DateTime.now().hour &&
            forecastDateTime.hour <= DateTime.now().hour + 24) {
          var temperature = ((forecast['main']['temp'] - 273.15) * 9 / 5 + 32)
              .round(); // Convert temperature to Fahrenheit
          hourlyTemperatures.add(temperature.toInt());

          String time =
              '${forecastDateTime.hour.toString().padLeft(2, '0')}:00';
          hourlyTimes.add(time);
        }
      }

      setState(() {
        _hourlyTemperatures = hourlyTemperatures;
        _hourlyTimes = hourlyTimes;
      });
    } catch (error) {
      print('Error fetching weather data: $error');
      setState(() {
        _weatherData = 'Error fetching weather data';
      });
    }
  }




  String _getDayName(DateTime date) {
    switch (date.weekday) {
      case 1:
        return 'Monday';
      case 2:
        return 'Tuesday';
      case 3:
        return 'Wednesday';
      case 4:
        return 'Thursday';
      case 5:
        return 'Friday';
      case 6:
        return 'Saturday';
      case 7:
        return 'Sunday';
      default:
        return '';
    }
  }

  String _getWeatherIcon(String weatherMain) {
    switch (weatherMain.toLowerCase()) {
      case 'clear':
        return '🌞';
      case 'clouds':
        return '☁️';
      case 'rain':
        return '🌧️';
      case 'thunderstorm':
        return '⛈️';
      case 'snow':
        return '❄️';
      default:
        return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Weather App'),
        actions: [
          IconButton(
            icon: Icon(Icons.person),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ProfileScreen()),
              );
            },
          ),
          IconButton(
            icon: Icon(Icons.settings),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SettingsScreen()),
              );
            },
          ),
          IconButton(
            icon: Icon(Icons.map),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => RadarMapScreen()),
              );
            },
          ),
        ],
      ),
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(
                    'assets/images/background3.jpg'), // Change path to your image asset
                fit: BoxFit.cover,
              ),
            ),
          ),
          Column(
            children: [
              Expanded(
                child: Container(
                  margin: EdgeInsets.all(16.0),
                  padding: EdgeInsets.all(16.0),
                  decoration: BoxDecoration(
                    color: Color.fromARGB(255, 232, 97, 39).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(10.0),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 5,
                        blurRadius: 7,
                        offset: Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Container(
                        color: Colors.white.withOpacity(0.5),
                        padding: EdgeInsets.symmetric(horizontal: 16.0),
                        child: TextField(
                          controller: _locationController,
                          decoration: InputDecoration(
                            hintText: 'Enter location',
                            suffixIcon: IconButton(
                              icon: Icon(Icons.search),
                              onPressed: () {
                                _fetchWeatherData(_locationController.text);
                              },
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 20.0),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            _weatherIcon, // Use your weather icon here
                            style: TextStyle(fontSize: 70.0),
                          ),
                          SizedBox(height: 10.0),
                          Text(
                            '$_temperature°F',
                            style: TextStyle(fontSize: 20.0),
                          ),
                          SizedBox(height: 10.0),
                          Text(
                            _weatherData,
                            style: TextStyle(fontSize: 20.0),
                          ),
                          
                        ],
                      ),
                      SizedBox(height: 20.0),
                       Expanded(
                        child: ListView.builder(
                          // scrollDirection: Axis.horizontal,
                          itemCount: _hourlyTemperatures.length,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 8.0),
                              child: Column(
                                children: [
                                  Text(
                                    _hourlyTimes[index],
                                    style: TextStyle(
                                        fontSize: 16.0,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  SizedBox(height: 5.0),
                                  Text(
                                    '${_hourlyTemperatures[index]}°F',
                                    style: TextStyle(fontSize: 16.0),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                      SizedBox(height: 20.0),
                      // Forecast temperatures...
                      Expanded(
                        child: ListView.builder(
                          itemCount: _forecastTemperatures.length,
                          itemBuilder: (context, index) {
                            return ListTile(
                              title: Text(
                                  ' ${_forecastDayNames[index]}: ${_forecastTemperatures[index]}°F'),
                            );
                          },
                        ),
                      ),
                     
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: HomeScreen(),
  ));
//AIzaSyCaATVByr1YV5-kR1FdiCNEogdphHDOuUY
}
