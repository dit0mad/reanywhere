import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:simpsonsviewer/pages/mobile/detail_screen.dart';
import 'package:simpsonsviewer/pages/search_bar.dart';

import '../../blocs/interactive_bloc.dart';

class TabletMainScreen extends StatelessWidget {
  const TabletMainScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Stack(children: [
      Column(
        children: [
          GlobalSearchBar(),
          SearchItems(),
          Expanded(
            child: Row(
              children: [
                Expanded(child: LeftPanel()),
                Expanded(child: RightPanel()),
              ],
            ),
          ),
        ],
      ),
    ]);
  }
}

class LeftPanel extends StatelessWidget {
  const LeftPanel({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<InteractiveBloc, BaseInteractiveState>(
      builder: (context, state) {
        final interactiveBloc = BlocProvider.of<InteractiveBloc>(context);

        if (state is InteractiveState) {
          final selectedChar = state.selectedCharacter;
          final characters = state.dataState.characters.map((e) {
            final index = state.dataState.characters.indexOf(e);
            return TextButton(
              onPressed: () {
                interactiveBloc.add(SetCharacterDetail(index: index));
              },
              child: Ink(
                  color: selectedChar == e ? Colors.amber[100] : null,
                  child: Text(e.title)),
            );
          });

          return Material(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Expanded(
                  child: Ink(
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

        return Ink();
      },
    );
  }
}

class RightPanel extends StatelessWidget {
  const RightPanel({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<InteractiveBloc, BaseInteractiveState>(
      builder: (context, state) {
        if (state is InteractiveState) {
          final selectedCharacter = state.selectedCharacter!;

          return Material(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Expanded(
                  child: Ink(
                    padding: const EdgeInsets.all(12),
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          const ResolveImage(),
                          Center(child: Text(selectedCharacter.title)),
                          Center(child: Text(selectedCharacter.description))
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        }

        return Ink();
      },
    );
  }
}
