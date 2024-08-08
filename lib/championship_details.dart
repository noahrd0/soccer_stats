// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';
// // import 'package:flutter/services.dart' show rootBundle;
// import 'package:google_fonts/google_fonts.dart';
// import 'package:flutter_dotenv/flutter_dotenv.dart';

// class ChampionshipDetailsPage extends StatefulWidget {
//   final int championshipId;
//   final int season;

//   const ChampionshipDetailsPage({super.key, required this.championshipId, required this.season});

//   @override
//   _ChampionshipDetailsPageState createState() => _ChampionshipDetailsPageState();
// }

// class _ChampionshipDetailsPageState extends State<ChampionshipDetailsPage> {
//   Map<String, dynamic>? championshipDetails;

//   String selectedStatType = 'topscorers';

//   @override
//   void initState() {
//     super.initState();
//     fetchChampionshipDetails();
//   }

//   Future<void> fetchChampionshipDetails() async {
//     await dotenv.load();
//     var headers = {
//       'x-rapidapi-key': dotenv.env['API_KEY'] ?? '',
//       'x-rapidapi-host': 'v3.football.api-sports.io'
//     };

//     var leagueRequest = http.Request(
//       'GET',
//       Uri.parse('https://v3.football.api-sports.io/leagues?id=${widget.championshipId}'),
//     );
//     var statRequest = http.Request(
//       'GET',
//       Uri.parse('https://v3.football.api-sports.io/players/$selectedStatType?league=${widget.championshipId}&season=${widget.season}'),
//     );

//     leagueRequest.headers.addAll(headers);
//     statRequest.headers.addAll(headers);

//     http.StreamedResponse leagueResponse = await leagueRequest.send();
//     http.StreamedResponse statResponse = await statRequest.send();

//     if (leagueResponse.statusCode == 200 && statResponse.statusCode == 200) {
//       String leagueResponseBody = await leagueResponse.stream.bytesToString();
//       String statResponseBody = await statResponse.stream.bytesToString();
//       setState(() {
//         championshipDetails = jsonDecode(leagueResponseBody)['response'][0];
//         championshipDetails![selectedStatType] = jsonDecode(statResponseBody)['response'];
//       });
//     } else {
//       print(leagueResponse.reasonPhrase);
//       print(statResponse.reasonPhrase);
//     }
//   }

//   @override
// Widget build(BuildContext context) {
//   return Scaffold(
//     appBar: AppBar(
//       title: Text(
//         'Championship Details',
//         style: GoogleFonts.firaSans(
//           textStyle: const TextStyle(color: Colors.white),
//         ),
//       ),
//       backgroundColor: const Color(0xFF2F70AF),
//     ),
//     body: championshipDetails == null
//         ? const Center(child: CircularProgressIndicator())
//         : SingleChildScrollView(
//             padding: const EdgeInsets.all(16.0),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   championshipDetails!['league']['name'],
//                   style: GoogleFonts.firaSans(
//                     textStyle: const TextStyle(
//                       fontSize: 24,
//                       fontWeight: FontWeight.bold,
//                       color: Color(0xFF2F70AF),
//                     ),
//                   ),
//                 ),
//                 const SizedBox(height: 15),
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                   children: [
//                     _buildStatButton('Scorers', 'topscorers'),
//                     _buildStatButton('Assists', 'topassists'),
//                     _buildStatButton('Yellow Cards', 'topyellowcards'),
//                     _buildStatButton('Red Cards', 'topredcards'),
//                   ],
//                 ),
//                 const SizedBox(height: 15),
//                 Text(
//                   'Top $selectedStatType for the Season ${widget.season}',
//                   style: GoogleFonts.firaSans(
//                     textStyle: const TextStyle(
//                       fontSize: 20,
//                       fontWeight: FontWeight.bold,
//                       color: Color(0xFF806491),
//                     ),
//                   ),
//                 ),
//                 const SizedBox(height: 10),
//                 ...championshipDetails![selectedStatType].map<Widget>((stat) {
//                   return Card(
//                     margin: const EdgeInsets.symmetric(vertical: 10),
//                     elevation: 5,
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(15),
//                     ),
//                     child: Padding(
//                       padding: const EdgeInsets.all(16.0),
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Row(
//                             crossAxisAlignment: CrossAxisAlignment.center,
//                             children: [
//                               CircleAvatar(
//                                 backgroundImage: NetworkImage(stat['player']['photo']),
//                                 radius: 30,
//                               ),
//                               const SizedBox(width: 15),
//                               Expanded(
//                                 child: Column(
//                                   crossAxisAlignment: CrossAxisAlignment.start,
//                                   children: [
//                                     Text(
//                                       stat['player']['name'],
//                                       style: GoogleFonts.firaSans(
//                                         textStyle: const TextStyle(
//                                           fontSize: 18,
//                                           fontWeight: FontWeight.bold,
//                                         ),
//                                       ),
//                                     ),
//                                     const SizedBox(height: 5),
//                                     Row(
//                                       crossAxisAlignment: CrossAxisAlignment.center,
//                                       children: [
//                                         Expanded(
//                                           child: Text(
//                                             '$selectedStatType: ${_getStatValue(stat)}',
//                                             style: GoogleFonts.numans(
//                                               textStyle: const TextStyle(
//                                                 fontSize: 16,
//                                                 color: Color(0xFF2F70AF),
//                                               ),
//                                             ),
//                                           ),
//                                         ),
//                                         Expanded(
//                                           child: Center(
//                                             child: Text(
//                                               stat['statistics'][0]['team']['name'],
//                                               style: GoogleFonts.numans(
//                                                 textStyle: const TextStyle(
//                                                   fontSize: 16,
//                                                   color: Color(0xFF2F70AF),
//                                                 ),
//                                               ),
//                                               overflow: TextOverflow.ellipsis,
//                                             ),
//                                           ),
//                                         ),
//                                       ],
//                                     ),
//                                     const SizedBox(height: 10),
//                                     Row(
//                                       children: [
//                                         Expanded(
//                                           child: Text(
//                                             'Matches Played: ${stat['statistics'][0]['games']['appearences']}',
//                                             style: GoogleFonts.numans(
//                                               textStyle: const TextStyle(
//                                                 fontSize: 16,
//                                                 color: Color(0xFF2F70AF),
//                                               ),
//                                             ),
//                                           ),
//                                         ),
//                                         Expanded(
//                                           child: Center(
//                                             child: Image.network(
//                                               stat['statistics'][0]['team']['logo'],
//                                               width: 50,
//                                               height: 50,
//                                             ),
//                                           ),
//                                         ),
//                                       ],
//                                     ),
//                                   ],
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ],
//                       ),
//                     ),
//                   );
//                 }).toList(),
//               ],
//             ),
//           ),
//   );
// }

//   // Méthode pour obtenir la valeur de la statistique en fonction du type
//   String _getStatValue(Map<String, dynamic> stat) {
//     switch (selectedStatType) {
//       case 'topassists':
//         return stat['statistics'][0]['goals']['assists'].toString();
//       case 'topredcards':
//         return stat['statistics'][0]['cards']['red'].toString();
//       case 'topyellowcards':
//         return stat['statistics'][0]['cards']['yellow'].toString();
//       case 'topscorers':
//       default:
//         return stat['statistics'][0]['goals']['total'].toString();
//     }
//   }

//   // Méthode pour créer chaque bouton de statistique
//   Widget _buildStatButton(String label, String statType) {
//     return TextButton(
//       onPressed: () {
//         setState(() {
//           selectedStatType = statType;
//           fetchChampionshipDetails(); // Recharger les données en fonction du type de stat
//         });
//       },
//       child: Text(
//         label,
//         style: GoogleFonts.firaSans(
//           textStyle: TextStyle(
//             fontSize: 16,
//             color: selectedStatType == statType ? Color(0xFF806491) : Colors.black,
//             fontWeight: selectedStatType == statType ? FontWeight.bold : FontWeight.normal,
//           ),
//         ),
//       ),
//     );
//   }
// }


import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ChampionshipDetailsPage extends StatefulWidget {
  final int championshipId;
  final int season;

  const ChampionshipDetailsPage({super.key, required this.championshipId, required this.season});

  @override
  _ChampionshipDetailsPageState createState() => _ChampionshipDetailsPageState();
}

class _ChampionshipDetailsPageState extends State<ChampionshipDetailsPage> {
  // Données en dur pour un joueur
  final Map<String, dynamic> playerData = {
    "player": {
      "id": 1100,
      "name": "E. Haaland",
      "firstname": "Erling",
      "lastname": "Braut Haaland",
      "age": 24,
      "birth": {
        "date": "2000-07-21",
        "place": "Leeds",
        "country": "England"
      },
      "nationality": "Norway",
      "height": "194 cm",
      "weight": "88 kg",
      "injured": false,
      "photo": "https://media.api-sports.io/football/players/1100.png"
    },
    "statistics": [
      {
        "team": {
          "id": 50,
          "name": "Manchester City",
          "logo": "https://media.api-sports.io/football/teams/50.png"
        },
        "league": {
          "id": 39,
          "name": "Premier League",
          "country": "England",
          "logo": "https://media.api-sports.io/football/leagues/39.png",
          "flag": "https://media.api-sports.io/flags/gb.svg",
          "season": 2023
        },
        "games": {
          "appearences": 31,
          "lineups": 29,
          "minutes": 2559,
          "number": null,
          "position": "Attacker",
          "rating": "7.361290",
          "captain": false
        },
        "substitutes": {
          "in": 2,
          "out": 9,
          "bench": 3
        },
        "shots": {
          "total": 98,
          "on": 59
        },
        "goals": {
          "total": 27,
          "conceded": 0,
          "assists": 5,
          "saves": null
        },
        "passes": {
          "total": 381,
          "key": 29,
          "accuracy": 9
        },
        "tackles": {
          "total": 6,
          "blocks": 1,
          "interceptions": 2
        },
        "duels": {
          "total": 184,
          "won": 88
        },
        "dribbles": {
          "attempts": 28,
          "success": 12,
          "past": null
        },
        "fouls": {
          "drawn": 31,
          "committed": 18
        },
        "cards": {
          "yellow": 1,
          "yellowred": 0,
          "red": 0
        },
        "penalty": {
          "won": null,
          "commited": null,
          "scored": 7,
          "missed": 1,
          "saved": null
        }
      }
    ]
  };

  String selectedStatType = 'topscorers';

  @override
  Widget build(BuildContext context) {
    // Typage explicite
    final Map<String, dynamic> player = playerData['player'] as Map<String, dynamic>;
    final Map<String, dynamic> stats = (playerData['statistics'] as List<dynamic>)[0] as Map<String, dynamic>;

    String statValue;
    String statLabel;

    switch (selectedStatType) {
      case 'topassists':
        statValue = (stats['goals'] as Map<String, dynamic>)['assists'].toString();
        statLabel = 'Assists';
        break;
      case 'topredcards':
        statValue = (stats['cards'] as Map<String, dynamic>)['red'].toString();
        statLabel = 'Red Cards';
        break;
      case 'topyellowcards':
        statValue = (stats['cards'] as Map<String, dynamic>)['yellow'].toString();
        statLabel = 'Yellow Cards';
        break;
      case 'topscorers':
      default:
        statValue = (stats['goals'] as Map<String, dynamic>)['total'].toString();
        statLabel = 'Goals';
        break;
    }

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
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Top $statLabel for the Season ${widget.season}',
              style: GoogleFonts.firaSans(
                textStyle: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF2F70AF),
                ),
              ),
            ),
            const SizedBox(height: 15),
            // Menu horizontal avec des boutons
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildStatButton('Scorers', 'topscorers'),
                _buildStatButton('Assists', 'topassists'),
                _buildStatButton('Yellow Cards', 'topyellowcards'),
                _buildStatButton('Red Cards', 'topredcards'),
              ],
            ),
            const SizedBox(height: 15),
            Card(
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
                        // Image du joueur
                        CircleAvatar(
                          backgroundImage: NetworkImage(player['photo'] as String),
                          radius: 30,
                        ),
                        const SizedBox(width: 15),
                        // Nom du joueur et club + statistiques
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                player['name'] as String,
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
                                        stats['team']['name'] as String,
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
                                      'Matches Played: ${(stats['games'] as Map<String, dynamic>)['appearences']}',
                                      style: GoogleFonts.numans(
                                        textStyle: const TextStyle(
                                          fontSize: 16,
                                          color: Color(0xFF2F70AF),
                                        ),
                                      ),
                                    ),
                                  ),
                                  // Logo du club centré
                                  Expanded(
                                    child: Center(
                                      child: Image.network(
                                        stats['team']['logo'] as String,
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
            ),
          ],
        ),
      ),
    );
  }

  // Méthode pour créer chaque bouton de statistique
  Widget _buildStatButton(String label, String statType) {
    return TextButton(
      onPressed: () {
        setState(() {
          selectedStatType = statType;
        });
      },
      child: Text(
        label,
        style: GoogleFonts.firaSans(
          textStyle: TextStyle(
            fontSize: 16,
            color: selectedStatType == statType ? Color(0xFF806491) : Colors.black,
            fontWeight: selectedStatType == statType ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }
}