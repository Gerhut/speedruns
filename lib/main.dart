import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:speedruns/store/bloc.dart';

import 'store/bloc.dart';
import 'store/event.dart';
import 'views/app.dart';

void main() => runApp(
  BlocProvider(
    builder: (context) => RunBloc()..dispatch(MoreRuns()),
    child: App(),
  ),
);
