import 'package:flutter/material.dart';
import 'package:cosmique/menu.dart';

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
        colorScheme: ColorScheme.fromSwatch(
       primarySwatch: Colors.grey,
 ).copyWith(secondary: Colors.grey[900]),
        useMaterial3: true,
      ),
      home: MyHomePage(),
    );
  }
}