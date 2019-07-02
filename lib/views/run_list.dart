import 'package:flutter/material.dart';

import 'run_card.dart';

import '../store/run.dart';
import '../store/run_stream.dart';

class RunList extends StatefulWidget {

  @override
  State<StatefulWidget> createState() {
    return _RunListState();
  }
}

class _RunListState extends State<RunList> {
  Stream<Run> _runStream;
  List<Run> _runs;

  @override
  Stream<void> initState() async* {
    _runStream = runStream();
    _runs = [];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return NotificationListener<OverscrollNotification>(
      child: ListView.builder(
        itemCount: _runs.length,
        itemBuilder: (BuildContext context, int index) {
          return RunCard(_runs[index]);
        },
      ),
      onNotification: onOverscrollNotification,
    );
  }

  void onOverscrollNotification(OverscrollNotification notification) {
    if (notification.overscroll > 0) {
      _runStream.drain();
    }
  }
}
