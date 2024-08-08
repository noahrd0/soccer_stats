import 'package:flutter/material.dart';
import 'package:soccer_stats/app.soccer_stats/common_widgets/date_selector.dart';
import 'package:soccer_stats/app.soccer_stats/common_widgets/country_selector.dart';
import 'package:soccer_stats/app.soccer_stats/league_list.dart';

class SelectorWidget extends StatefulWidget {
  const SelectorWidget({Key? key}) : super(key: key);

  @override
  _SelectorWidgetState createState() => _SelectorWidgetState();
}

class _SelectorWidgetState extends State<SelectorWidget> {
  final GlobalKey<LeagueListState> leagueListKey = GlobalKey<LeagueListState>();
  late DateSelector dateSelector;
  late CountrySelector countrySelector;

  @override
  void initState() {
    super.initState();
    dateSelector = const DateSelector();
    countrySelector = const CountrySelector();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min, // Set mainAxisSize to min
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            dateSelector,
            const SizedBox(width: 10),
            countrySelector,
            const SizedBox(width: 10),
            ElevatedButton(
              onPressed: () {
                int selectedYear = dateSelector.selectedYear;
                String? selectedCountry = countrySelector.country;
                selectedCountry ??= 'world';

                // Accéder à l'état de LeagueList et appeler reload
                leagueListKey.currentState?.reload(selectedYear.toString(), selectedCountry);
              },
              child: const Text('Submit'),
            ),
          ],
        ),
        Expanded(
          child: SingleChildScrollView(
            child: LeagueList(key: leagueListKey),
          ),
        ),
      ],
    );
  }
}
