import 'package:flutter/material.dart';

String? selectedCountry;

class CountrySelector extends StatefulWidget {
  const CountrySelector({Key? key}) : super(key: key);

  String? get country => selectedCountry;

  @override
  _CountrySelectorState createState() => _CountrySelectorState();
}

class _CountrySelectorState extends State<CountrySelector> {
  final List<Map<String, String>> countries = [
    {'name': 'Brazil', 'code': 'br'},
    {'name': 'Argentina', 'code': 'ar'},
    {'name': 'Germany', 'code': 'de'},
    {'name': 'Spain', 'code': 'es'},
    {'name': 'France', 'code': 'fr'},
    {'name': 'Italy', 'code': 'it'},
    {'name': 'Netherlands', 'code': 'nl'},
    {'name': 'Portugal', 'code': 'pt'},
    {'name': 'England', 'code': 'gb'},
    {'name': 'Belgium', 'code': 'be'},
    {'name': 'United States', 'code': 'us'},
    {'name': 'World', 'image': 'https://cdn.iconscout.com/icon/free/png-256/free-earth-global-globe-international-map-planet-world-2-12510.png'},
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: DropdownButton<String>(
        value: selectedCountry,
        icon: const Icon(
          Icons.arrow_drop_down,
          color: Color(0xFFB9848C),
        ),
        onChanged: (String? newValue) {
          setState(() {
            selectedCountry = newValue;
          });
        },
        items: countries.map<DropdownMenuItem<String>>((Map<String, String> country) {
          if (country['name'] == 'World') {
            return DropdownMenuItem<String>(
              value: country['code'],
              child: Row(
                children: [
                  const SizedBox(width: 15),
                    const Icon(
                    Icons.language,
                    color: Color(0xFFB9848C),
                    size: 30,
                    ),
                  const SizedBox(width: 15),
                  Text(
                    country['name']!,
                    style: const TextStyle(
                      color: Color(0xFFB9848C),
                      fontFamily: 'Numans',
                      fontSize: 18,
                    ),
                  ),
                ],
              ),
            );
          } else {
            return DropdownMenuItem<String>(
              value: country['code'],
              child: Row(
                children: [
                  const SizedBox(width: 10),
                  Image.network(
                    'https://flagcdn.com/w40/${country['code']}.png',
                  ),
                  const SizedBox(width: 10),
                  Text(
                    country['name']!,
                    style: const TextStyle(
                      color: Color(0xFFB9848C),
                      fontFamily: 'Numans',
                      fontSize: 18,
                    ),
                  ),
                ],
              ),
            );
          }
        }).toList(),
      ),
    );
  }
}