import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:speedruns/store/model.dart';
import 'package:url_launcher/url_launcher.dart';

import '../store/model.dart';

class _MaxLinesText extends StatelessWidget {
  final String text;
  final int maxLines;
  final TextStyle style;

  _MaxLinesText(this.text, { Key key, this.maxLines = 1, this.style }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(text, maxLines: maxLines, overflow: TextOverflow.ellipsis, style: style);
  }
}

class RunItem extends StatelessWidget {
  RunItem(this.run, { Key key }) : super(key: key);

  final RunModel run;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(8.0),
      elevation: 2.0,
      clipBehavior: Clip.antiAlias,
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
    final theme = Theme.of(context);
    final content = Column(
      mainAxisAlignment: MainAxisAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        run.game != null ? _MaxLinesText(run.game, style: theme.textTheme.title) : null,
        run.level != null ? _MaxLinesText(run.level, style: theme.textTheme.subtitle) : null,
        run.category != null ? _MaxLinesText(run.category, style: theme.textTheme.subtitle) : null,
        run.comment != null ? const Divider(height: 20) : null,
        run.comment != null ? _MaxLinesText(run.comment, maxLines: 3, style: theme.textTheme.body1) : null,
      ].whereType<Widget>().toList(),
    );

    final paddedContent = Padding(
      padding: EdgeInsets.all(10.0),
      child: content,
    );

    if (run.cover != null) {
      return AspectRatio(
        aspectRatio: run.cover.size.aspectRatio,
        child: Ink.image(
          image: NetworkImage(run.cover.uri.toString()),
          fit: BoxFit.fill,
          child: Ink(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  theme.cardColor.withAlpha(0),
                  theme.cardColor,
                ]
              ),
            ),
            child: paddedContent,
          ),
        ),
      );
    } else {
      return paddedContent;
    }
  }
}
