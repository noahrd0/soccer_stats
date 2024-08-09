import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class ChampionshipDetailsPage extends StatefulWidget {
  final int championshipId;
  final int season;

  const ChampionshipDetailsPage({super.key, required this.championshipId, required this.season});

  @override
  _ChampionshipDetailsPageState createState() => _ChampionshipDetailsPageState();
}

class _ChampionshipDetailsPageState extends State<ChampionshipDetailsPage> {
  Map<String, dynamic>? championshipDetails;

  String selectedStatType = 'topscorers';

  @override
  void initState() {
    super.initState();
    fetchChampionshipDetails();
  }

  Future<void> fetchChampionshipDetails() async {
    await dotenv.load();
    var headers = {
      'x-rapidapi-key': dotenv.env['API_KEY'] ?? '',
      'x-rapidapi-host': 'v3.football.api-sports.io'
    };

    var leagueRequest = http.Request(
      'GET',
      Uri.parse('https://v3.football.api-sports.io/leagues?id=${widget.championshipId}'),
    );
    var statRequest = http.Request(
      'GET',
      Uri.parse('https://v3.football.api-sports.io/players/$selectedStatType?league=${widget.championshipId}&season=${widget.season}'),
    );

    leagueRequest.headers.addAll(headers);
    statRequest.headers.addAll(headers);

    http.StreamedResponse leagueResponse = await leagueRequest.send();
    http.StreamedResponse statResponse = await statRequest.send();

    if (leagueResponse.statusCode == 200 && statResponse.statusCode == 200) {
      String leagueResponseBody = await leagueResponse.stream.bytesToString();
      String statResponseBody = await statResponse.stream.bytesToString();
      
      var leagueJson = jsonDecode(leagueResponseBody);
      var statJson = jsonDecode(statResponseBody);

      if (leagueJson != null && leagueJson['response'] != null && leagueJson['response'].isNotEmpty &&
          statJson != null && statJson['response'] != null) {
        setState(() {
          championshipDetails = leagueJson['response'][0];
          if (championshipDetails != null) {
            championshipDetails![selectedStatType] = statJson['response'];
          } else {
            print('championshipDetails is null');
          }
        });
      } else {
        print('Invalid JSON structure');
      }
    } else {
      print(leagueResponse.reasonPhrase);
      print(statResponse.reasonPhrase);
    }
  }

@override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(
      title: Text(
        'Championship Details',
        style: GoogleFonts.firaSans(
          textStyle: const TextStyle(color: Colors.white),
        ),
      ),
      backgroundColor: const Color(0xFF2F70AF),
    ),
    body: championshipDetails == null
        ? const Center(child: CircularProgressIndicator())
        : Column(
            children: [
              // Ajout de la barre de boutons
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildStatButton('Scorers', 'topscorers'),
                    _buildStatButton('Assists', 'topassists'),
                    _buildStatButton('Yellow Cards', 'topyellowcards'),
                    _buildStatButton('Red Cards', 'topredcards'),
                  ],
                ),
              ),
              Expanded(
                child: championshipDetails![selectedStatType] == null || championshipDetails![selectedStatType].isEmpty
                    ? const Center(child: Text('No data available for the selected stat type.'))
                    : SingleChildScrollView(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ...championshipDetails![selectedStatType].map<Widget>((stat) {
                              final statResult = _getStatValue(stat);
                              String statLabel = statResult['StatLabel'] ?? 'Stat';
                              String statValue = statResult['StatValue'] ?? '0';

                              return Card(
                                margin: const EdgeInsets.symmetric(vertical: 10),
                                elevation: 5,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: [
                                          CircleAvatar(
                                            backgroundImage: NetworkImage(stat['player']['photo']),
                                            radius: 30,
                                          ),
                                          const SizedBox(width: 15),
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  stat['player']['name'],
                                                  style: GoogleFonts.firaSans(
                                                    textStyle: const TextStyle(
                                                      fontSize: 18,
                                                      fontWeight: FontWeight.bold,
                                                    ),
                                                  ),
                                                ),
                                                const SizedBox(height: 5),
                                                Row(
                                                  crossAxisAlignment: CrossAxisAlignment.center,
                                                  children: [
                                                    Expanded(
                                                      child: Text(
                                                        '$statLabel: $statValue',
                                                        style: GoogleFonts.numans(
                                                          textStyle: const TextStyle(
                                                            fontSize: 16,
                                                            color: Color(0xFF2F70AF),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                    Expanded(
                                                      child: Center(
                                                        child: Text(
                                                          stat['statistics'][0]['team']['name'],
                                                          style: GoogleFonts.numans(
                                                            textStyle: const TextStyle(
                                                              fontSize: 16,
                                                              color: Color(0xFF2F70AF),
                                                            ),
                                                          ),
                                                          overflow: TextOverflow.ellipsis,
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                const SizedBox(height: 10),
                                                Row(
                                                  children: [
                                                    Expanded(
                                                      child: Text(
                                                        'Matches Played: ${stat['statistics'][0]['games']['appearences']}',
                                                        style: GoogleFonts.numans(
                                                          textStyle: const TextStyle(
                                                            fontSize: 16,
                                                            color: Color(0xFF2F70AF),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                    Expanded(
                                                      child: Center(
                                                        child: Image.network(
                                                          stat['statistics'][0]['team']['logo'],
                                                          width: 50,
                                                          height: 50,
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            }).toList(),
                          ],
                        ),
                      ),
              ),
            ],
          ),
  );
}


  Map<String, String> _getStatValue(Map<String, dynamic> stat) {
    String statValue = '';
    String statLabel = '';

    if (stat['statistics'] != null && stat['statistics'][0] != null) {
      switch (selectedStatType) {
        case 'topassists':
          statValue = stat['statistics'][0]['goals']['assists']?.toString() ?? '0';
          statLabel = 'Assists';
          break;
        case 'topredcards':
          statValue = stat['statistics'][0]['cards']['red']?.toString() ?? '0';
          statLabel = 'Red Cards';
          break;
        case 'topyellowcards':
          statValue = stat['statistics'][0]['cards']['yellow']?.toString() ?? '0';
          statLabel = 'Yellow Cards';
          break;
        case 'topscorers':
        default:
          statValue = stat['statistics'][0]['goals']['total']?.toString() ?? '0';
          statLabel = 'Goals';
          break;
      }
    }

    return {
      'StatLabel': statLabel,
      'StatValue': statValue,
    };
  }

  // Méthode pour créer chaque bouton de statistique
  Widget _buildStatButton(String label, String statType) {
    return TextButton(
      onPressed: () {
        setState(() {
          selectedStatType = statType;
          fetchChampionshipDetails(); // Recharger les données en fonction du type de stat
        });
      },
      child: Text(
        label,
        style: GoogleFonts.firaSans(
          textStyle: TextStyle(
            fontSize: 16,
            color: selectedStatType == statType ? const Color(0xFF806491) : Colors.black,
            fontWeight: selectedStatType == statType ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }
}
