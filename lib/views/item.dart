import 'package:flutter/material.dart';
import 'package:speedruns/store/model.dart';
import 'package:url_launcher/url_launcher.dart';

import '../store/model.dart';

class RunItem extends StatelessWidget {
  RunItem(this.run, { Key key }) : super(key: key);

  final RunModel run;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(8.0),
      elevation: 4.0,
      child: getContent(context)
    );
  }

  Widget getContent(BuildContext context) {
    final body = getBody(context);

    switch (run.videos.length) {
      case 0: return body;
      case 1: return InkWell(
        child: body,
        onTap: () { launch(run.videos[0]); },
      );
      default: return Column(
        children: <Widget>[
          body,
          const Divider(height: 0),
          getButtonBar(),
        ],
      );
    }
  }

  Widget getButtonBar() {
    return ButtonTheme.bar(
      layoutBehavior: ButtonBarLayoutBehavior.constrained,
      child: ButtonBar(
        children: run.videos.asMap().entries.map((entry) {
          return FlatButton(
            child: Text("Video ${entry.key + 1}"),
            onPressed: () { launch(entry.value); },
          );
        }).toList(),
      ),
    );
  }

  Widget getBody(BuildContext context) {
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
                    run.game != null
                      ? Text(
                        run.game,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: textTheme.title
                      ) : null,
                    run.level != null
                      ? Text(
                        run.level,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: textTheme.subtitle
                      ) : null,
                    run.category != null
                      ? Text(
                        run.category,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: textTheme.subtitle
                      ) : null,
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
