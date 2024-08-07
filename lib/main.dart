import 'package:flutter/material.dart';
import 'app.soccer_stats/main_page.dart';

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
        title: const Text(
          'Soccer Stats',
          style: TextStyle(
            color: Colors.white,
            fontFamily: 'Fira Sans',
          ),
        ),
        leading: const Icon(
          color: Colors.white,
          Icons.sports_soccer,
        ),
        centerTitle: true,
      ),
      body: const MainPage()
    );
  }
}
