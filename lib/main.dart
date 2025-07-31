import 'package:flutter/material.dart';
import 'screens/home_screen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) => MaterialApp(
    title: 'Meu App CRUD',
    theme: ThemeData(primarySwatch: Colors.blue),
    home: HomeScreen(),
  );
}
