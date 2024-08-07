import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'common_widgets/single_league.dart';

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
    var headers = {
      'x-rapidapi-key': '953bef4957246aa80190f16a405714d9',
      'x-rapidapi-host': 'v3.football.api-sports.io',
    };

    var request = http.Request(
      'GET',
      Uri.parse('https://v1.rugby.api-sports.io/leagues?season=2024&country=World'),
    );
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      print(response.reasonPhrase);
      String responseBody = await response.stream.bytesToString();
      setState(() {
        leagueData = jsonDecode(responseBody)['response'];
        print("leagueData : $leagueData");
      });
    } else {
      print(response.reasonPhrase);
    }
  }

  @override
  Widget build(BuildContext context) {
    return leagueData == null
        ? const Center(child: CircularProgressIndicator())
        : Column(
              children: leagueData!.map<Widget>((league) {
                return SingleLeague(
                  // imagePath: league['league']['logo']??'',
                  // text: league['league']['name'],
                  // value: league['league']['id'].toString(),
                  imagePath: league['logo'],
                  text: league['name'],
                  value: league['id'].toString(),
                );
              }).toList(),
            );
  }
}
