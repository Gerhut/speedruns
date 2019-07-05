import 'package:flutter/material.dart';

import 'card.dart';

class App extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Speedruns',
      home: Scaffold(
        body: RunCard(),
      ),
    );
  }
}
