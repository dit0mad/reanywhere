import 'package:coreapp/navigation/bloc/nav_bloc.dart';
import 'package:coreapp/navigation/bloc/nav_events.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wireviewer/blocs/interactive_bloc.dart';
import 'package:wireviewer/pages/mobile/detail_screen.dart';

class MobileMainScreen extends StatelessWidget {
  const MobileMainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<InteractiveBloc, BaseInteractiveState>(
      builder: (context, state) {
        if (state is InteractiveState) {
          final selectedChar = state.selectedCharacter;
          final interactiveBloc = BlocProvider.of<InteractiveBloc>(context);
          final navBloc = BlocProvider.of<NaavBloc>(context);
          final characters = state.dataState.characters.map((e) {
            final index = state.dataState.characters.indexOf(e);
            return TextButton(
              onPressed: () {
                interactiveBloc.add(SetCharacterDetail(index: index));
                navBloc.add(const PushPageRoute(
                    page: MaterialPage(
                      child: CharacterDetail(),
                    ),
                    target: Target.mainStackMobile));
              },
              child: Ink(
                  color: selectedChar == e ? Colors.red : null,
                  child: Text(e.title)),
            );
          });

          return Material(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Center(child: Text('WireViewer Characters')),
                ),
                Expanded(
                  child: Ink(
                    color: Colors.green,
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [...characters],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        }
        return const Center(child: CircularProgressIndicator());
      },
    );
  }
}
