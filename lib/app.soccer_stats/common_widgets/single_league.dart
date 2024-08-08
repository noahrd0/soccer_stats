import 'package:flutter/material.dart';
import 'package:soccer_stats/app.soccer_stats/common_widgets/date_selector.dart';
import 'package:soccer_stats/championship_details.dart';


class SingleLeague extends StatelessWidget {
  final String imagePath;
  final String text;
  final String value;
  final int championshipId;

  const SingleLeague({
    super.key,
    required this.imagePath,
    required this.text,
    required this.value,
    required this.championshipId,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Row(
        children: [
            Image.network(
            imagePath,
            width: 48,
            height: 48,
            errorBuilder: (BuildContext context, Object exception, StackTrace? stackTrace) {
                return const Icon(Icons.stadium_outlined, size: 48);
            },
            ),
          const SizedBox(width: 10),
            Text(
            text,
            style: const TextStyle(
              color: Color(0xFF806491),
            ),
            ),
        ],
      ),
      trailing: const Icon(Icons.arrow_forward, color: Color(0xFF806491)),
      onTap: () {
        const DateSelector dateSelector = DateSelector();
        int year = dateSelector.selectedYear;
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ChampionshipDetailsPage(
              championshipId: championshipId,
              season: year,
            ),
          ),
        );
      },
      
    );
  }
}