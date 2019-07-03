import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
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
    final textTheme = Theme.of(context).textTheme;
    final cover = run.cover != null ?
      AspectRatio(
        aspectRatio: run.cover.size.aspectRatio,
        child: Ink.image(
          image: NetworkImage(run.cover.uri.toString()),
          fit: BoxFit.fill,
          child: Container(),
        ),
      ): null;
    final content = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[],
    );
    if (run.game != null) content.children.add(
      Text(run.game, maxLines: 1, overflow: TextOverflow.ellipsis, style: textTheme.title)
    );
    if (run.level != null) content.children.add(
      Text(run.level, maxLines: 1, overflow: TextOverflow.ellipsis, style: textTheme.subtitle)
    );
    if (run.category != null) content.children.add(
      Text(run.category, maxLines: 1, overflow: TextOverflow.ellipsis, style: textTheme.subtitle)
    );
    if (run.comment != null) content.children.addAll([
      const Divider(height: 20),
      Text(run.comment, style: textTheme.body1),
    ]);

    return Stack(
      alignment: Alignment.bottomCenter,
      children: <Widget>[
        ConstrainedBox(
          constraints: const BoxConstraints(minWidth: double.infinity),
          child: cover,
        ),
        Container(
          color: Colors.white70,
          padding: EdgeInsets.all(10.0),
          width: double.infinity,
          child: content
        ),
      ],
    );
  }
}
