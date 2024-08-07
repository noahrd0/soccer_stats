import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:google_fonts/google_fonts.dart';

class ChampionshipDetailsPage extends StatefulWidget {
  final int championshipId;
  final int season;

  ChampionshipDetailsPage({required this.championshipId, required this.season});

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
    var headers = {
      'x-rapidapi-key': '4eaaa12e25815b320db3722f5818f36d', // Remplacez par votre clé API
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
        title: Text('Championship Details', style: GoogleFonts.firaSans()),
        backgroundColor: Color(0xFF2F70AF),
      ),
      body: championshipDetails == null
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    championshipDetails!['league']['name'],
                    style: GoogleFonts.firaSans(
                      textStyle: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Color(0xFF2F70AF)),
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Season: ${widget.season}',
                    style: GoogleFonts.numans(
                      textStyle: TextStyle(fontSize: 18, color: Color(0xFF806491)),
                    ),
                  ),
                  SizedBox(height: 20),
                  Text(
                    'Top Scorers:',
                    style: GoogleFonts.firaSans(
                      textStyle: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF2F70AF)),
                    ),
                  ),
                  SizedBox(height: 10),
                  ...championshipDetails!['topScorers'].map<Widget>((scorer) {
                    return Card(
                      margin: EdgeInsets.symmetric(vertical: 10),
                      elevation: 5,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CircleAvatar(
                              backgroundImage: NetworkImage(scorer['player']['photo']),
                              radius: 30,
                            ),
                            SizedBox(width: 15),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    scorer['player']['name'],
                                    style: GoogleFonts.firaSans(
                                      textStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  SizedBox(height: 5),
                                  Text(
                                    'Goals: ${scorer['statistics'][0]['goals']['total']}',
                                    style: GoogleFonts.numans(),
                                  ),
                                  SizedBox(height: 5),
                                  Text(
                                    'Club: ${scorer['statistics'][0]['team']['name']}',
                                    style: GoogleFonts.numans(
                                    ),
                                  ),
                                  SizedBox(height: 5),
                                  Text(
                                    'Matches Played: ${scorer['statistics'][0]['games']['appearences']}',
                                    style: GoogleFonts.numans(
                                    ),
                                  ),
                                ],
                              ),
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