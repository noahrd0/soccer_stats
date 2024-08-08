import 'package:flutter/material.dart';
import 'package:soccer_stats/app.soccer_stats/selector.dart';

class MainPage extends StatelessWidget {
  const MainPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        Flexible(
          fit: FlexFit.loose,
          child: SelectorWidget(),
        ),
      ],
    );
  }
}

