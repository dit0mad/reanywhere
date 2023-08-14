import 'dart:math';

import 'package:flutter/material.dart';
import 'package:hello/navigation/bloc/nav_bloc.dart';
import 'package:hello/navigation/bloc/nav_events.dart';

class MainStackState extends NavState {
  final List<MaterialPage> mainStackMobile;
  final List<MaterialPage> mainStackTablet;

  const MainStackState({
    required this.mainStackMobile,
    required this.mainStackTablet,
  });

  MainStackState copyWith({
    final List<MaterialPage>? mainStackMobile,
    final List<MaterialPage>? mainStackTablet,
  }) =>
      MainStackState(
        mainStackMobile: mainStackMobile ?? this.mainStackMobile,
        mainStackTablet: mainStackTablet ?? this.mainStackTablet,
      );
}

MainStackState navReducer(
  final NavigationEvent event,
  final Target target,
  final MainStackState state,
) {
  if (target == Target.mainStackMobile) {
    final nextStack = reduce(event, state.mainStackMobile);

    final nextState = state.copyWith(
      mainStackMobile: nextStack,
    );

    return nextState;
  }

  if (target == Target.mainStackTablet) {
    final nextStack = reduce(event, state.mainStackTablet);

    final nextState = state.copyWith(
      mainStackTablet: nextStack,
    );

    return nextState;
  }

  return state;
}

List<MaterialPage<dynamic>> reduce(
  final NavigationEvent event,
  final List<MaterialPage> stack,
) {
  if (event is MaybePopRoute) {
    final next = [...stack.sublist(0, max(1, stack.length - 1))];

    return next;
  }
  if (event is PopToRootPushPageRoute) {
    final next = [
      ...stack.sublist(0, 1),
      event.page,
    ];
    return next;
  }

  if (event is PushPageRoute) {
    final next = [
      ...stack,
      event.page,
    ];
    return next;
  }

  return stack;
}
