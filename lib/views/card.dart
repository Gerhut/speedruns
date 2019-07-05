import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'list.dart';

class RunCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Stack(
        children: <Widget>[
          LayoutBuilder(
            builder: (BuildContext context, BoxConstraints constraints) {
              return ConstrainedBox(
                key: UniqueKey(),
                constraints: constraints,
                child: Card(
                  margin: EdgeInsets.all(0),
                  child: RunList(),
                ),
              );
            },
          )
        ],
      ),
    );
  }
}
