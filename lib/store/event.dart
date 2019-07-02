import 'model.dart';

abstract class RunEvent {}

abstract class RunListEvent extends RunEvent {
  final List<RunModel> runs;

  RunListEvent(this.runs);
}

class MoreRuns extends RunEvent {}

class RetryRuns extends RunEvent {}

class RefreshRuns extends RunEvent {}

class SetRuns extends RunListEvent {
  SetRuns(final List<RunModel> runs) : super(runs);
}

class AppendRuns extends RunListEvent {
  AppendRuns(final List<RunModel> runs) : super(runs);
}
