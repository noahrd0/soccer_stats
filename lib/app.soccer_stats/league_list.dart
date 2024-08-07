import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'common_widgets/single_league.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class LeagueList extends StatefulWidget {
  const LeagueList({super.key});

  @override
  _LeagueListState createState() => _LeagueListState();
}

class _LeagueListState extends State<LeagueList> {
  List<dynamic>? leagueData;

  @override
  void initState() {
    super.initState();
    fetchLeagueData();
  }

  Future<void> fetchLeagueData() async {
    await dotenv.load();
    var headers = {
      'x-rapidapi-key': dotenv.env['API_KEY'] ?? '',
      'x-rapidapi-host': 'v3.football.api-sports.io',
    };

    var request = http.Request(
      'GET',
      Uri.parse('https://v3.football.api-sports.io/leagues?season=2023&country=France'),
    );
    request.headers.addAll(headers);

    try {
      http.StreamedResponse response = await request.send();

      if (response.statusCode == 200) {
        String responseBody = await response.stream.bytesToString();
        setState(() {
          leagueData = jsonDecode(responseBody)['response'];
          print("leagueData: $leagueData");
        });
      } else {
        print('Error: ${response.reasonPhrase}');
      }
    } catch (e) {
      print('Exception: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return leagueData == null
        ? const Center(child: CircularProgressIndicator())
        : Column(
            children: leagueData!.map<Widget>((league) {
              return SingleLeague(
                imagePath: league['league']['logo'] ?? '',
                text: league['league']['name'],
                value: league['league']['id'].toString(),
                championshipId: league['league']['id'], 
              );
            }).toList(),
          );
  }
}
