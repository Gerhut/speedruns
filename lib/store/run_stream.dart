import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart';

import 'run.dart';

final _defaultUrl = Uri.https('www.speedrun.com', '/api/v1/runs', const {
  "status": "verified",
  "orderby": "verify-date",
  "direction": "desc",
  "embed": "game,level,category",
}).toString();

Stream<Run> runStream([String url]) async* {
  if (url == null) url = _defaultUrl;

  while(true) {
    var body = await read(url);
    var data = json.decode(body);

    var rawRuns = data['data'] as List;
    var runs = rawRuns.map((rawRun) => Run.fromRaw(rawRun));
    yield* Stream.fromIterable(runs);

    var rawPagination = data['pagination'];
    var rawLinks = rawPagination['links'] as List;
    url = rawLinks.firstWhere((link) => link['rel'] == 'next');
  }
}
