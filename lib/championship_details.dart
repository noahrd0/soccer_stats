import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
// import 'package:flutter/services.dart' show rootBundle;
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
    var scorersRequest = http.Request(
      'GET',
      Uri.parse('https://v3.football.api-sports.io/players/topscorers?league=${widget.championshipId}&season=${widget.season}'),
    );

    leagueRequest.headers.addAll(headers);
    scorersRequest.headers.addAll(headers);

    http.StreamedResponse leagueResponse = await leagueRequest.send();
    http.StreamedResponse scorersResponse = await scorersRequest.send();

    if (leagueResponse.statusCode == 200 && scorersResponse.statusCode == 200) {
      String leagueResponseBody = await leagueResponse.stream.bytesToString();
      String scorersResponseBody = await scorersResponse.stream.bytesToString();
      setState(() {
        championshipDetails = jsonDecode(leagueResponseBody)['response'][0];
        championshipDetails!['topScorers'] = jsonDecode(scorersResponseBody)['response'];
      });
    } else {
      print(leagueResponse.reasonPhrase);
      print(scorersResponse.reasonPhrase);
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
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    championshipDetails!['league']['name'],
                    style: GoogleFonts.firaSans(
                      textStyle: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF2F70AF),
                      ),
                    ),
                  ),
                  const SizedBox(height: 15),
                  Text(
                    'Top buteurs de la saison ${widget.season}',
                    style: GoogleFonts.firaSans(
                      textStyle: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF806491),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  ...championshipDetails!['topScorers'].map<Widget>((scorer) {
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
                                // Image du joueur
                                CircleAvatar(
                                  backgroundImage: NetworkImage(scorer['player']['photo']),
                                  radius: 30,
                                ),
                                const SizedBox(width: 15),
                                // Nom du joueur et club + buts
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        scorer['player']['name'],
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
                                              'Buts: ${scorer['statistics'][0]['goals']['total']}',
                                              style: GoogleFonts.numans(
                                                textStyle: const TextStyle(
                                                  fontSize: 16,
                                                  color: Color(0xFFB9848C),
                                                ),
                                              ),
                                            ),
                                          ),
                                          Expanded(
                                            child: Center(
                                              child: Text(
                                                scorer['statistics'][0]['team']['name'],
                                                style: GoogleFonts.numans(
                                                  textStyle: const TextStyle(
                                                    fontSize: 16,
                                                    color: Color(0xFFB9848C),
                                                  ),
                                                ),
                                                overflow: TextOverflow.ellipsis,
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
                            const SizedBox(height: 10),
                            Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    'Matchs joués: ${scorer['statistics'][0]['games']['appearences']}',
                                    style: GoogleFonts.numans(
                                      textStyle: const TextStyle(
                                        fontSize: 16,
                                        color: Color(0xFFB9848C),
                                      ),
                                    ),
                                  ),
                                ),
                                // Logo du club centré
                                Expanded(
                                  child: Center(
                                    child: Image.network(
                                      scorer['statistics'][0]['team']['logo'],
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
                    );
                  }).toList(),
                ],
              ),
            ),
    );
  }
}

// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';

// class ChampionshipDetailsPage extends StatelessWidget {
//   final int championshipId;
//   final int season;

//   const ChampionshipDetailsPage({super.key, required this.championshipId, required this.season});

//   @override
//   Widget build(BuildContext context) {
//     // Données en dur pour un joueur
//     final Map<String, dynamic> playerData = {
//       "player": {
//         "id": 1100,
//         "name": "E. Haaland",
//         "firstname": "Erling",
//         "lastname": "Braut Haaland",
//         "age": 24,
//         "birth": {
//           "date": "2000-07-21",
//           "place": "Leeds",
//           "country": "England"
//         },
//         "nationality": "Norway",
//         "height": "194 cm",
//         "weight": "88 kg",
//         "injured": false,
//         "photo": "https://media.api-sports.io/football/players/1100.png"
//       },
//       "statistics": [
//         {
//           "team": {
//             "id": 50,
//             "name": "Manchester City",
//             "logo": "https://media.api-sports.io/football/teams/50.png"
//           },
//           "league": {
//             "id": 39,
//             "name": "Premier League",
//             "country": "England",
//             "logo": "https://media.api-sports.io/football/leagues/39.png",
//             "flag": "https://media.api-sports.io/flags/gb.svg",
//             "season": 2023
//           },
//           "games": {
//             "appearences": 31,
//             "lineups": 29,
//             "minutes": 2559,
//             "number": null,
//             "position": "Attacker",
//             "rating": "7.361290",
//             "captain": false
//           },
//           "substitutes": {
//             "in": 2,
//             "out": 9,
//             "bench": 3
//           },
//           "shots": {
//             "total": 98,
//             "on": 59
//           },
//           "goals": {
//             "total": 27,
//             "conceded": 0,
//             "assists": 5,
//             "saves": null
//           },
//           "passes": {
//             "total": 381,
//             "key": 29,
//             "accuracy": 9
//           },
//           "tackles": {
//             "total": 6,
//             "blocks": 1,
//             "interceptions": 2
//           },
//           "duels": {
//             "total": 184,
//             "won": 88
//           },
//           "dribbles": {
//             "attempts": 28,
//             "success": 12,
//             "past": null
//           },
//           "fouls": {
//             "drawn": 31,
//             "committed": 18
//           },
//           "cards": {
//             "yellow": 1,
//             "yellowred": 0,
//             "red": 0
//           },
//           "penalty": {
//             "won": null,
//             "commited": null,
//             "scored": 7,
//             "missed": 1,
//             "saved": null
//           }
//         }
//       ]
//     };

//     // Typage explicite
//     final Map<String, dynamic> player = playerData['player'] as Map<String, dynamic>;
//     final Map<String, dynamic> stats = (playerData['statistics'] as List<dynamic>)[0] as Map<String, dynamic>;

//     return Scaffold(
//       appBar: AppBar(
//         title: Text(
//           'Championship Details',
//           style: GoogleFonts.firaSans(
//             textStyle: const TextStyle(color: Colors.white),
//           ),
//         ),
//         backgroundColor: const Color(0xFF2F70AF),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text(
//               'Top Scorer for the Season $season',
//               style: GoogleFonts.firaSans(
//                 textStyle: const TextStyle(
//                   fontSize: 24,
//                   fontWeight: FontWeight.bold,
//                   color: Color(0xFF2F70AF),
//                 ),
//               ),
//             ),
//             const SizedBox(height: 15),
//             Card(
//               margin: const EdgeInsets.symmetric(vertical: 10),
//               elevation: 5,
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(15),
//               ),
//               child: Padding(
//                 padding: const EdgeInsets.all(16.0),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Row(
//                       crossAxisAlignment: CrossAxisAlignment.center,
//                       children: [
//                         // Image du joueur
//                         CircleAvatar(
//                           backgroundImage: NetworkImage(player['photo'] as String),
//                           radius: 30,
//                         ),
//                         const SizedBox(width: 15),
//                         // Nom du joueur et club + buts
//                         Expanded(
//                           child: Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               Text(
//                                 player['name'] as String,
//                                 style: GoogleFonts.firaSans(
//                                   textStyle: const TextStyle(
//                                     fontSize: 18,
//                                     fontWeight: FontWeight.bold,
//                                   ),
//                                 ),
//                               ),
//                               const SizedBox(height: 5),
//                               Row(
//                                 crossAxisAlignment: CrossAxisAlignment.center,
//                                 children: [
//                                   Expanded(
//                                     child: Text(
//                                       'Goals: ${(stats['goals'] as Map<String, dynamic>)['total']}',
//                                       style: GoogleFonts.numans(
//                                         textStyle: const TextStyle(
//                                           fontSize: 16,
//                                           color: Color(0xFFB9848C),
//                                         ),
//                                       ),
//                                     ),
//                                   ),
//                                   Expanded(
//                                     child: Center(
//                                       child: Text(
//                                         stats['team']['name'] as String,
//                                         style: GoogleFonts.numans(
//                                           textStyle: const TextStyle(
//                                             fontSize: 16,
//                                             color: Color(0xFFB9848C),
//                                           ),
//                                         ),
//                                         overflow: TextOverflow.ellipsis,
//                                       ),
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                               const SizedBox(height: 10),
//                               Row(
//                                 children: [
//                                   Expanded(
//                                     child: Text(
//                                       'Matches Played: ${(stats['games'] as Map<String, dynamic>)['appearences']}',
//                                       style: GoogleFonts.numans(
//                                         textStyle: const TextStyle(
//                                           fontSize: 16,
//                                           color: Color(0xFFB9848C),
//                                         ),
//                                       ),
//                                     ),
//                                   ),
//                                   // Logo du club centré
//                                   Expanded(
//                                     child: Center(
//                                       child: Image.network(
//                                         stats['team']['logo'] as String,
//                                         width: 50,
//                                         height: 50,
//                                       ),
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             ],
//                           ),
//                         ),
//                       ],
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }