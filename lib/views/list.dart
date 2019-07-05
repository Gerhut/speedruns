import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'item.dart';

import '../store/bloc.dart';
import '../store/event.dart';
import '../store/state.dart';

class RunList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder(
      bloc: BlocProvider.of<RunBloc>(context),
      builder: (BuildContext context, RunState state) {
        final runs = state.runs;

        return NotificationListener<OverscrollNotification>(
          onNotification: onOverscrollNotification,
          child: RefreshIndicator(
            child: ListView.builder(
              padding: const EdgeInsets.all(8.0),
              physics: const ClampingScrollPhysics(),
              itemCount: runs.length + 1,
              itemBuilder: (BuildContext context, int index) {
                if (index < runs.length) {
                  return RunItem(runs[index], key: ValueKey(runs[index]));
                } else {
                  return getFooter(context, state);
                }
              },
            ),
            onRefresh: () => onRefresh(context),
          ),
        );
      }
    );
  }

  Widget getFooter(BuildContext context, RunState state) {
    if (state.exception != null) {
      final theme = Theme.of(context);return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
        child: Center(
          child: IconButton(
            icon: const Icon(Icons.error),
            color: theme.errorColor,
            onPressed: () => onErrorButtonPressed(context),
          ),
        ),
      );
    } else {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 16.0),
        child: Center(child: CircularProgressIndicator()),
      );
    }
  }

  void onErrorButtonPressed(BuildContext context) {
    final bloc = BlocProvider.of<RunBloc>(context);
    bloc.dispatch(RetryRuns());
  }

  bool onOverscrollNotification(OverscrollNotification notification) {
    final bloc = BlocProvider.of<RunBloc>(notification.context);
    if (!bloc.currentState.loading) {
      if (notification.overscroll > 0) {
        bloc.dispatch(MoreRuns());
      }
    }
    return null;
  }

  Future<void> onRefresh(BuildContext context) async {
    final bloc = BlocProvider.of<RunBloc>(context);
    bloc.dispatch(RefreshRuns());
    await bloc.state.firstWhere((state) => state.loading);
    await bloc.state.firstWhere((state) => !state.loading);
  }
}
