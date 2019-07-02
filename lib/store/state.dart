import 'model.dart';

abstract class RunState {
  final List<RunModel> list;
  const RunState(this.list);

  int get length => list.length;
}

class RunsEmpty extends RunState {
  const RunsEmpty() : super(const []);
}

class RunsLoading extends RunState {
  RunsLoading(List<RunModel> list) : super(list);
}

class RunsLoaded extends RunState {
  RunsLoaded(List<RunModel> list) : super(list);
}

class RunsError extends RunState {
  RunsError(List<RunModel> list) : super(list);
}

class RunsRefreshing extends RunState {
  RunsRefreshing(List<RunModel> list) : super(list);
}
