import 'package:flutter/material.dart';
import 'package:speedruns/store/model.dart';
import 'package:url_launcher/url_launcher.dart';

import '../store/model.dart';

class _Content extends StatelessWidget {
  _Content(this.run, { Key key }) : super(key: key);

  final RunModel run;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              run.cover != null ?
                Image.network(
                  run.cover.uri.toString(),
                  width: 64,
                  height: 64 / run.cover.size.width * run.cover.size.height,
                ) : null,
              const SizedBox(width: 8.0),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    run.game != null ? Text(run.game, maxLines: 1, style: textTheme.title) : null,
                    run.level != null ? Text(run.level, maxLines: 1, style: textTheme.subtitle) : null,
                    run.category != null ? Text(run.category, maxLines: 1, style: textTheme.subtitle) : null,
                  ].whereType<Widget>().toList(),
                ),
              ),
            ].whereType<Widget>().toList(),
          ),
        ),
        run.comment != null ? const Divider(height: 0) : null,
        run.comment != null ? Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(run.comment, style: textTheme.body1),
        ) : null,
      ].whereType<Widget>().toList(),
    );
  }
}

class RunItem extends StatelessWidget {
  RunItem(this.run, { Key key }) : super(key: key);

  final RunModel run;

  @override
  Widget build(BuildContext context) {
    final contentElement = _Content(run);
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          contentElement,
          ButtonTheme.bar(
            child: ButtonBar(
              children: run.videos.asMap().entries.map((entry) {
                return FlatButton(
                  child: Text("V${entry.key}"),
                  onPressed: () { launch(entry.value); },
                );
              }).toList(growable: false),
            ),
          ),
        ],
      ),
    );
  }
}
