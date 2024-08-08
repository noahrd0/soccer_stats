import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:soccer_stats/app.soccer_stats/common_widgets/single_league.dart';

class LeagueList extends StatefulWidget {
  const LeagueList({Key? key}) : super(key: key);

  @override
  LeagueListState createState() => LeagueListState();
}

class LeagueListState extends State<LeagueList> {
  List<dynamic>? leagueData;

  @override
  void initState() {
    print('LeagueListState initState');
    super.initState();
    // loadLeagueData();
    fetchLeagueData("2024", "world");
  }

Future<void> fetchLeagueData(String year, String country) async {
    await dotenv.load();
    var headers = {
      'x-rapidapi-key': dotenv.env['API_KEY'] ?? '',
    };

    String url;
    if (country == "world") {
      url = 'https://v3.football.api-sports.io/leagues?season=$year&country=World';
    } else {
      url = 'https://v3.football.api-sports.io/leagues?season=$year&code=$country';
    }

    print('URL: $url');
    var request = http.Request(
      'GET',
      Uri.parse(url),
    );
    request.headers.addAll(headers);

    try {
      http.StreamedResponse response = await request.send();

      if (response.statusCode == 200) {
        String responseBody = await response.stream.bytesToString();
        setState(() {
          leagueData = jsonDecode(responseBody)['response'];
        });
      } else {
        print('Error: ${response.reasonPhrase}');
      }
    } catch (e) {
      print('Exception: $e');
    }
  }

  void reload(String year, String country) {
    fetchLeagueData(year, country);
  }


  @override
  Widget build(BuildContext context) {
    print('LeagueListState build, leagueData: $leagueData');
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
