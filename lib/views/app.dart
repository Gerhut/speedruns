import 'package:flutter/material.dart';

import 'list.dart';

class App extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Speedruns',
      home: Scaffold(
        appBar: AppBar(title: Text('Speedruns')),
        body: RunList(),
      ),
    );
  }
}
