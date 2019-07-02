import 'package:bloc/bloc.dart';

import 'client.dart';
import 'event.dart';
import 'state.dart';

class RunBloc extends Bloc<RunEvent, RunState> {
  final RunClient client;
  RunBloc() : client = RunClient();

  @override
  get initialState => RunsEmpty();

  @override
  Stream<RunState> mapEventToState(RunEvent event) async* {
    try {
      if (event is MoreRuns || event is RetryRuns) {
        final loadingState = RunsLoading(currentState.list);
        yield loadingState;
        final runs = await client.fetch(offset: currentState.length);
        if (currentState == loadingState) { dispatch(AppendRuns(runs)); }
      } else if (event is RefreshRuns) {
        final refreshingState = RunsRefreshing(currentState.list);
        yield refreshingState;
        final runs = await client.fetch();
        if (currentState == refreshingState) { dispatch(SetRuns(runs)); }
      } else if (event is SetRuns) {
        yield RunsLoaded(event.runs);
      } else if (event is AppendRuns) {
        yield RunsLoaded(currentState.list.followedBy(event.runs).toList());
      }
    } catch (error) {
      print(error.message);
      print(error.stackTrace);
      yield RunsError(currentState.list);
    }
  }
}
