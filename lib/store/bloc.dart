import 'package:bloc/bloc.dart';

import 'client.dart';
import 'event.dart';
import 'state.dart';

class RunBloc extends Bloc<RunEvent, RunState> {
  final RunClient client;
  RunBloc() : client = RunClient();

  @override
  get initialState => RunState();

  @override
  Stream<RunState> mapEventToState(RunEvent event) async* {
    try {
      if (event is MoreRuns || event is RetryRuns) {
        final nextState = currentState.copyWith(loading: true);
        yield nextState;
        final runs = await client.fetch(offset: currentState.offset);
        if (nextState != currentState) return;
        yield currentState.copyWith(
          runs: currentState.runs.followedBy(runs),
          offset: currentState.offset + runs.length,
          loading: false,
        );
      }

      if (event is RefreshRuns) {
        final nextState = currentState.copyWith(loading: true);
        yield nextState;
        final runs = await client.fetch();
        if (nextState != currentState) return;
        yield currentState.copyWith(
          runs: runs,
          offset: runs.length,
          loading: false,
        );
      }
    } on Exception catch (exception) {
      print(exception);
      yield currentState.copyWith(
        loading: false,
        exception: exception
      );
    }
  }
}
