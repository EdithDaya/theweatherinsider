import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:weatherinsider/home_screen.dart';
//import 'package:flutter/material.dart';
import 'package:weatherinsider/welcome_screen.dart';
//import 'register_screen.dart'; // Import the RegisterScreen widget

void main() async {
  // Initialize Firebase
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  // Run the app with the RegisterScreen as the home
  runApp(MaterialApp(
    home: HomeScreen(),
  ));
}
