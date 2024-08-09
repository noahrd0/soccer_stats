import 'package:flutter/material.dart';
import 'app.soccer_stats/main_page.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Soccer Stats',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF2F70AF),
        title: Text(
            'Soccer Stats',
            style: GoogleFonts.firaSans(
              textStyle: const TextStyle(
                color: Colors.white,
              ),
            ),
          ),
        leading: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Image.asset(
            'images/logo.png',
            width: 30,
            height: 30,
          ),
        ),
        centerTitle: true,
      ),
      body: const MainPage()
    );
  }
}
