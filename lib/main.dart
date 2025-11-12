import 'package:flutter/material.dart';

import 'package:roadsafe_estimator/screens/splash_screen.dart';

void main() {
  runApp(const RoadSafetyApp());
}

class RoadSafetyApp extends StatelessWidget {
  const RoadSafetyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'RoadSafe Estimator',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        primaryColor: const Color(0xFF1976D2),
        scaffoldBackgroundColor: Colors.white,
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF1976D2),
          elevation: 0,
        ),
      ),
      home: const SplashScreen(),
    );
  }
}
