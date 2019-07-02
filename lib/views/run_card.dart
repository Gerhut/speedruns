import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../store/run.dart';

class _RunCardContent extends StatelessWidget {
  _RunCardContent(this.run, { Key key }) : super(key: key);

  final Run run;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Column(
      children: <Widget>[
        Row(
          children: <Widget>[
            Image.network(run.cover, width: 256),
            Expanded(
              child: Row(
                children: <Widget>[
                  Text(run.game, maxLines: 1, style: textTheme.title),
                  Text(run.level, maxLines: 1, style: textTheme.subtitle),
                  Text(run.category, maxLines: 1, style: textTheme.subtitle),
                ],
              ),
            ),
          ],
        ),
        Text(run.comment, style: textTheme.body1),
      ],
    );
  }
}

class RunCard extends StatelessWidget {
  RunCard(this.run, { Key key }) : super(key: key);

  final Run run;

  @override
  Widget build(BuildContext context) {
    final contentElement = _RunCardContent(run);
    final videoLength = run.videos.length;

    if (videoLength == 0) {
      return Card(child: contentElement);
    }

    if (videoLength == 1) {
      return Card(
        child: InkWell(
          child: contentElement,
          onTap: () { launch(run.videos[0]); },
        ),
      );
    }

    return Card(
      child: Column(
        children: <Widget>[
          contentElement,
          ButtonTheme.bar(
            child: ButtonBar(
              children: List.of(
                run.videos.asMap().entries.map((entry) {
                  return FlatButton(
                    child: Text("V${entry.key}"),
                    onPressed: () { launch(entry.value); },
                  );
                })
              ),
            ),
          ),
        ],
      ),
    );
  }
}
