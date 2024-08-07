import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Soccer Stats',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
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
      body: const Center(
        child: Text(
          'Welcome to Soccer Stats!',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}