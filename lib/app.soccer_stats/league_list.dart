import 'package:flutter/material.dart';
import 'common_widgets/single_league.dart';

class LeagueList extends StatelessWidget {
  const LeagueList({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        SingleLeague(
          imagePath: 'images/worldcup.png',
          text: 'World Cup',
          value: '1',
        ),
        SingleLeague(
          imagePath: 'images/olympics.png',
          text: 'Olympics',
          value: '480',
        ),
        SingleLeague(
          imagePath: 'images/ligue1.png',
          text: 'Ligue 1',
          value: '61',
        ),
        SingleLeague(
          imagePath: 'images/premierleague.png',
          text: 'Premier League',
          value: '39',
        ),
        SingleLeague(
          imagePath: 'images/seriea.png',
          text: 'Serie A',
          value: '137',
        ),
        SingleLeague(
          imagePath: 'images/laliga.png',
          text: 'La Liga',
          value: '140',
        ),
        SingleLeague(
          imagePath: 'images/bundesliga.png',
          text: 'Bundesliga',
          value: '78',
        ),
      ],
    );
  }
}
