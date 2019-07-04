import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:speedruns/store/model.dart';
import 'package:url_launcher/url_launcher.dart';

import '../store/model.dart';

class _SingleLinedText extends StatelessWidget {
  final String text;
  final TextStyle style;

  _SingleLinedText(this.text, { Key key, this.style }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(text, maxLines: 1, overflow: TextOverflow.ellipsis, style: style);
  }
}

class RunItem extends StatelessWidget {
  RunItem(this.run, { Key key }) : super(key: key);

  final RunModel run;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(8.0),
      elevation: 4.0,
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
      children: <Widget>[],
    );
    if (run.game != null) {
      content.children.add(
        _SingleLinedText(run.game, style: theme.textTheme.title)
      );
    };
    if (run.level != null) {
      content.children.add(
        _SingleLinedText(run.level, style: theme.textTheme.subtitle)
      );
    }
    if (run.category != null) {
      content.children.add(
        _SingleLinedText(run.category, style: theme.textTheme.subtitle)
      );
    }
    if (run.comment != null) {
      content.children.addAll([
        const Divider(height: 20),
        Text(run.comment, maxLines: 3, overflow: TextOverflow.ellipsis, style: theme.textTheme.body1),
      ]);
    }

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
