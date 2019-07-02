import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'item.dart';

import '../store/bloc.dart';
import '../store/event.dart';
import '../store/state.dart';

class RunList extends StatefulWidget {

  @override
  State<StatefulWidget> createState() => _RunListState();
}

class _RunListState extends State<RunList> {
  RunBloc _bloc;

  @override
  void initState() {
    super.initState();
    _bloc = BlocProvider.of(context);
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder(
      bloc: _bloc,
      builder: (BuildContext context, RunState state) {
        final list = state.list;

        return NotificationListener<OverscrollNotification>(
          onNotification: onOverscrollNotification,
          child: RefreshIndicator(
            child: ListView.builder(
              padding: const EdgeInsets.all(4.0),
              physics: const ClampingScrollPhysics(),
              itemCount: list.length + 1,
              itemBuilder: (BuildContext context, int index) {
                if (index < list.length) {
                  return Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: RunItem(list[index])
                  );
                }
                if (state is RunsError) {
                  return getErrorFooter();
                }
                return getLoadingFooter();
              },
            ),
            onRefresh: onRefresh,
          ),
        );
      },
    );
  }

  Widget getLoadingFooter() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: Center(child: CircularProgressIndicator())
    );
  }

  Widget getErrorFooter() {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Center(
        child: IconButton(
          icon: Icon(Icons.error),
          color: theme.errorColor,
          onPressed: onErrorButtonPressed,
        ),
      ),
    );
  }

  void onErrorButtonPressed() {
    _bloc.dispatch(RetryRuns());
  }

  bool onOverscrollNotification(OverscrollNotification notification) {
    if (_bloc.currentState is RunsLoaded) {
      if (notification.overscroll > 0) {
        _bloc.dispatch(MoreRuns());
      }
    }
    return null;
  }

  Future<void> onRefresh() async {
    // TODO: listen to the refreshing end.
    _bloc.dispatch(RefreshRuns());
    await Future.doWhile(() async {
      await Future.delayed(Duration(milliseconds: 100));
      return _bloc.currentState is! RunsRefreshing;
    });
    await Future.doWhile(() async {
      await Future.delayed(Duration(milliseconds: 100));
      return _bloc.currentState is RunsRefreshing;
    });
  }
}
