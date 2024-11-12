import 'package:flutter/material.dart';
import 'package:cosmique/screens/menu.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Cosmique',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
      colorScheme: ColorScheme.fromSwatch().copyWith(
        primary: Colors.black,
        secondary: Colors.grey[900],
      ),
        useMaterial3: true,
      ),
      home: MyHomePage(),
    );
  }
}