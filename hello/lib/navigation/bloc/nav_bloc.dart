import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hello/data/data_bloc/data_bloc.dart';
import 'package:hello/data/events/data_events.dart';
import 'package:hello/navigation/bloc/nav_events.dart';
import 'package:hello/navigation/bloc/stack_states.dart';

class NaavBloc extends Bloc<NavigationEvent, NavState> {
  final List<MaterialPage<dynamic>> mobileStack;
  final List<MaterialPage<dynamic>> tabletStack;

  NaavBloc({
    required this.mobileStack,
    required this.tabletStack,
  }) : super(
          MainStackState(
            mainStackMobile: mobileStack,
            mainStackTablet: tabletStack,
          ),
        ) {
    on<MaybePopRoute>((event, emit) {
      final target = event.target;

      final nextState = navReducer(event, target, state as MainStackState);

      emit(nextState);
    });

    on<PushPageRoute>((event, emit) {
      final target = event.target;

      final nextState = navReducer(event, target, state as MainStackState);

      emit(nextState);
    });

    on<PopToRootPushPageRoute>((event, emit) {
      final target = event.target;

      final nextState = navReducer(event, target, state as MainStackState);

      emit(nextState);
    });
  }
}

abstract class NavState {
  const NavState();
}

class EmptyPage extends StatelessWidget {
  const EmptyPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final userProvider = context.read<DataBloc>();
    return Container(
      color: Colors.green,
      child: Center(
        child: TextButton(
            onPressed: () {
              userProvider.add(const GetData());
            },
            child: const Text('Getdata')),
      ),
    );
  }
}
