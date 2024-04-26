import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class RadarMapScreen extends StatefulWidget {
  @override
  _RadarMapScreenState createState() => _RadarMapScreenState();
}

class _RadarMapScreenState extends State<RadarMapScreen> {
  String apiKey = 'AIzaSyCaATVByr1YV5-kR1FdiCNEogdphHDOuUY';

  Future<void> fetchRadarData() async {
    final response = await http.get(
      Uri.parse(
          'https://api.openweathermap.org/data/2.5/weather?q=London&appid=$apiKey'),
    );

    if (response.statusCode == 200) {
      // Parse the JSON response
      Map<String, dynamic> data = jsonDecode(response.body);
      // Extract radar data from the response and display it
      // You can use a map library or a widget like WebView to display the radar map
    } else {
      // Handle error
      throw Exception('Failed to load radar data');
    }
  }

  @override
  void initState() {
    super.initState();
    fetchRadarData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Live Radar'),
      ),
      body: Center(
        child:
            CircularProgressIndicator(), // Placeholder until radar data is fetched
      ),
    );
  }
}
void main() {
  runApp(MaterialApp(
    home:RadarMapScreen(),
  ));
  //AIzaSyCaATVByr1YV5-kR1FdiCNEogdphHDOuUY
}
