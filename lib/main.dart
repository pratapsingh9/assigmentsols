import 'package:flutter/material.dart';
import 'screens/homeScreen.dart';
import 'screens/scanScreen.dart';
import 'screens/settingsScreen.dart';

void main() {
  // runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Beacon Scanner',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        brightness: Brightness.light,
        scaffoldBackgroundColor: Colors.white,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          elevation: 0,
        ),
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => HomeScreen(),
        '/scan': (context) => ScanScreen(),
        '/settings': (context) => SettingsScreen(),
      },
    );
  }
}
