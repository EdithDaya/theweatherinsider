import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ViewWeatherScreen extends StatefulWidget {
  final LatLng selectedLocation;

  const ViewWeatherScreen({Key? key, required this.selectedLocation})
      : super(key: key);

  @override
  _ViewWeatherScreenState createState() => _ViewWeatherScreenState();
}

class _ViewWeatherScreenState extends State<ViewWeatherScreen> {
  Map<String, dynamic>? _weatherData;

  @override
  void initState() {
    super.initState();
    fetchWeatherData();
  }

  Future<void> fetchWeatherData() async {
    final apiKey = 'fe997b29b5bc50ecac5123f2d088e592';
    final url =
        'https://api.openweathermap.org/data/2.5/weather?lat=${widget.selectedLocation.latitude}&lon=${widget.selectedLocation.longitude}&appid=$apiKey';

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      setState(() {
        _weatherData = jsonDecode(response.body);
      });
    } else {
      // Handle error
      print('Failed to load weather data: ${response.reasonPhrase}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Weather Forecast'),
      ),
      body: Center(
        child: _weatherData == null
            ? CircularProgressIndicator()
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Weather for ${_weatherData!['name']}:',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Temperature: ${(_weatherData!['main']['temp'] - 273.15).toStringAsFixed(2)} °C',
                    style: TextStyle(fontSize: 18),
                  ),
                  Text(
                    'Description: ${_weatherData!['weather'][0]['description']}',
                    style: TextStyle(fontSize: 18),
                  ),
                ],
              ),
      ),
    );
  }
}
