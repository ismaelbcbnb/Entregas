import 'package:flutter/material.dart';
import 'screens/home_screen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) => MaterialApp(
    title: 'Entregas',
    theme: ThemeData(primarySwatch: Colors.blue),
    home: HomeScreen(),
  );
}
