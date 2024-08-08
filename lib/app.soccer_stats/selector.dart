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
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
            SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Container(
              width: 482,
              margin: const EdgeInsets.symmetric(vertical: 10),
              decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: 2,
                blurRadius: 5,
                offset: const Offset(0, 3),
                ),
              ],
              borderRadius: BorderRadius.circular(10),
              ),
              padding: const EdgeInsets.all(10),
              child: Row(
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

                  leagueListKey.currentState?.reload(selectedYear.toString(), selectedCountry);
                },
                style: ElevatedButton.styleFrom(
                  shadowColor: Colors.grey.withOpacity(0.5),
                  backgroundColor: Colors.white,
                  elevation: 5,
                ),
                child: const Text(
                  'Submit',
                  style: TextStyle(color: Color(0xFFB9848C)),
                ),
                ),
                const SizedBox(width: 10),
              ],
              ),
            ),
            ),
          Expanded(
            child: SingleChildScrollView(
              child: LeagueList(key: leagueListKey),
            ),
          ),
        ],
      ),
    );
  }
}
