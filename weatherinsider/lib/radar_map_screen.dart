import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class RadarMapScreen extends StatefulWidget {
  @override
  _RadarMapScreenState createState() => _RadarMapScreenState();
}

class _RadarMapScreenState extends State<RadarMapScreen> {
  GoogleMapController? _controller;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Weather Radar Map'),
      ),
      body: GoogleMap(
        onMapCreated: (controller) {
          setState(() {
            _controller = controller;
          });
        },
        initialCameraPosition: const CameraPosition(
          target: LatLng(0, 0), // Center the map at (0, 0) initially
          zoom: 2, // Zoom level
        ),
      ),
    );
  }
}


//1ce2eb8a279fd676bab7caa5f9937ad0