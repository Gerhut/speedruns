import 'package:flutter/material.dart';

import 'run_list.dart';

class Home extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Speedruns'),
      ),
      body: RunList(),
    );
  }
}
