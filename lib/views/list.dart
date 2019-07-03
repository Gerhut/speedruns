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
        final list = state.list;

        return NotificationListener<OverscrollNotification>(
          onNotification: onOverscrollNotification,
          child: RefreshIndicator(
            child: ListView.builder(
              padding: const EdgeInsets.all(8.0),
              physics: const ClampingScrollPhysics(),
              itemCount: list.length + 1,
              itemBuilder: (BuildContext context, int index) {
                if (index < list.length) {
                  return RunItem(list[index]);
                } else if (state is RunsError) {
                  return getErrorFooter(context);
                } else {
                  return getLoadingFooter();
                }
              },
            ),
            onRefresh: () => onRefresh(context),
          ),
        );
      },
    );
  }

  Widget getLoadingFooter() {
    return const Padding(
      padding: EdgeInsets.symmetric(vertical: 16.0),
      child: Center(child: CircularProgressIndicator())
    );
  }

  Widget getErrorFooter(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: Center(
        child: IconButton(
          icon: const Icon(Icons.error),
          color: theme.errorColor,
          onPressed: () => onErrorButtonPressed(context),
        ),
      ),
    );
  }

  void onErrorButtonPressed(BuildContext context) {
    final bloc = BlocProvider.of<RunBloc>(context);
    bloc.dispatch(RetryRuns());
  }

  bool onOverscrollNotification(OverscrollNotification notification) {
    final bloc = BlocProvider.of<RunBloc>(notification.context);
    if (bloc.currentState is RunsLoaded) {
      if (notification.overscroll > 0) {
        bloc.dispatch(MoreRuns());
      }
    }
    return null;
  }

  Future<void> onRefresh(BuildContext context) async {
    final bloc = BlocProvider.of<RunBloc>(context);
    bloc.dispatch(RefreshRuns());
    await bloc.state.firstWhere((state) => state is RunsRefreshing);
    await bloc.state.firstWhere((state) => state is! RunsRefreshing);
  }
}
