import 'package:flutter/material.dart';

int year = DateTime.now().year;

class DateSelector extends StatefulWidget {
  const DateSelector({super.key});

  int get selectedYear => year;
  
  @override
  _DateSelectorState createState() => _DateSelectorState();
}

class _DateSelectorState extends State<DateSelector> {

  void _incrementYear() {
    setState(() {
      year++;
    });
  }

  void _decrementYear() {
    setState(() {
      year--;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(
          icon: const Icon(Icons.arrow_left),
          onPressed: _decrementYear,
        ),
        Text(
          year.toString(),
          style: const TextStyle(fontSize: 18),
        ),
        IconButton(
          icon: const Icon(Icons.arrow_right),
          onPressed: _incrementYear,
        ),
      ],
    );
  }
}