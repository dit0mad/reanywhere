library simsonlayout;

import 'package:coreapp/navigation/bloc/nav_bloc.dart';
import 'package:coreapp/navigation/bloc/stack_states.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BaseLayout extends StatelessWidget {
  const BaseLayout({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const SafeArea(
      child: Entry(),
    );
  }
}

class Mediator extends StatelessWidget {
  final Widget child;
  const Mediator({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(child: child),
        ],
      ),
    );
  }
}

class Entry extends StatelessWidget {
  const Entry({super.key});

  @override
  Widget build(BuildContext context) {
    return Mediator(
      child: LayoutBuilder(
          builder: (context, constraints) =>
              constraints.maxWidth < 840 && constraints.maxHeight < 840
                  ? const MobileScreen()
                  : const Tablet()),
    );
  }
}

class MobileScreen extends StatelessWidget {
  const MobileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NaavBloc, NavState>(builder: (
      context,
      state,
    ) {
      if (state is MainStackState) {
        return Navigator(
          key: mainNavigatorKey,
          onPopPage: (final Route<dynamic> route, final dynamic result) {
            return route.didPop(result);
          },
          pages: [
            ...state.mainStackMobile,
          ],
        );
      }
      return const Center(
        child: Text('Initializing'),
      );
    });
  }
}

class Tablet extends StatelessWidget {
  const Tablet({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NaavBloc, NavState>(builder: (
      context,
      state,
    ) {
      if (state is MainStackState) {
        return Navigator(
          key: mainNavigatorKey,
          onPopPage: (final Route<dynamic> route, final dynamic result) {
            return route.didPop(result);
          },
          pages: [
            ...state.mainStackTablet,
          ],
        );
      }
      return const Center(
        child: Text('Initializing'),
      );
    });
  }
}

final GlobalKey<NavigatorState> mainNavigatorKey = GlobalKey<NavigatorState>();
