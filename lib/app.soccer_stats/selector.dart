import 'package:flutter/material.dart';
import 'package:soccer_stats/app.soccer_stats/common_widgets/date_selector.dart';
import 'package:soccer_stats/app.soccer_stats/common_widgets/country_selector.dart';

class SelectorWidget extends StatelessWidget {
  const SelectorWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Form(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const DateSelector(),
                const SizedBox(width: 10),
                const CountrySelector(),
                const SizedBox(width: 10),
                ElevatedButton(
                  onPressed: () {
                    const DateSelector dateSelector = DateSelector();
                    int year = dateSelector.selectedYear;
                    const CountrySelector countrySelector = CountrySelector();
                    String? country = countrySelector.country;
                    print('Appel API avec l\'année : $year et le pays : $country');
                  },
                  child: const Text('Submit'),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
        ],
      ),
    );
  }
}