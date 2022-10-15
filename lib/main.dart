import 'package:firedart/firedart.dart';
import 'package:flutter/material.dart';
import 'package:ganpatistore_desktop/Global/fluent_theme_data.dart';
import 'package:ganpatistore_desktop/Screens/splash_screen.dart';

const apiKey = 'Your API Key';
const projectId = 'Your Project ID';

void main() {
  Firestore.initialize(projectId);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Ganpati Store',
      theme: FluentThemeData.light(),
      home: const SplashScreen(),
    );
  }
}
