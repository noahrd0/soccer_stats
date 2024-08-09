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
          icon: const Icon(Icons.arrow_left, color: Color(0xFFB9848C)),
          onPressed: _decrementYear,
        ),
        Text(
          year.toString(),
          style: const TextStyle(fontSize: 18, color: Color(0xFFB9848C), fontFamily: 'Numans'),
        ),
        IconButton(
          icon: const Icon(Icons.arrow_right, color: Color(0xFFB9848C)),
          onPressed: _incrementYear,
        ),
      ],
    );
  }
}