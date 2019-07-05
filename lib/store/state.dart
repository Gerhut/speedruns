import 'model.dart';

class RunState {
  final List<RunModel> runs;
  final int offset;
  final bool loading;
  final Exception exception;

  RunState({
    Iterable<RunModel> runs = const Iterable.empty(),
    this.offset = 0,
    this.loading = false,
    this.exception,
  }) : this.runs = List.unmodifiable(Set.of(runs));

  RunState copyWith({
    Iterable<RunModel> runs,
    int offset,
    bool loading,
    Exception exception,
  }) => RunState(
    runs: runs ?? this.runs,
    offset: offset ?? this.offset,
    loading: loading ?? this.loading,
    exception: exception,
  );
}
