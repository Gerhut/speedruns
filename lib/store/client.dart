import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart';

import 'model.dart';

class RunClient {
  Client _client = Client();

  Future<List<RunModel>> fetch({int offset = 0}) async {
    final uri = Uri.https('www.speedrun.com', '/api/v1/runs', {
      "status": "verified",
      "orderby": "verify-date",
      "direction": "desc",
      "embed": "game,level,category",
      "offset": offset.toString(),
    });

    final body = await _client.read(uri);
    final Map<String, dynamic> json = jsonDecode(body);

    final List<dynamic> runsJson = json['data'];
    return runsJson.map((runJson) => RunModel.fromJson(runJson)).toList(growable: false);
  }
}
