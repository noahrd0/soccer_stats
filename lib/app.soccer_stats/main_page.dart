import 'package:flutter/material.dart';
import 'package:soccer_stats/app.soccer_stats/common_widgets/date_selector.dart';
import 'package:soccer_stats/app.soccer_stats/league_list.dart';

class MainPage extends StatelessWidget {
  const MainPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        DateSelector(),
        LeagueList(),
      ],
    );
  }
}