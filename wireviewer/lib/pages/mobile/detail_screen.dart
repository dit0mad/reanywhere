import 'package:coreapp/navigation/bloc/nav_bloc.dart';
import 'package:coreapp/navigation/bloc/nav_events.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../blocs/interactive_bloc.dart';

class CharacterDetail extends StatelessWidget {
  const CharacterDetail({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<InteractiveBloc, BaseInteractiveState>(
      builder: (context, state) {
        if (state is InteractiveState) {
          final character = state.selectedCharacter;
          return Scaffold(
            appBar: AppBar(
              automaticallyImplyLeading: true,
              leading: BackButton(
                  color: Colors.amber,
                  onPressed: () {
                    BlocProvider.of<NavigationBloc>(context).add(MaybePopRoute(
                        target: Target.mainStackMobile,
                        page: MaterialPage(child: Container())));
                  }),
            ),
            body: Material(
              child: Column(
                children: [
                  Text(character!.title),
                ],
              ),
            ),
          );
        }
        return Ink();
      },
    );
  }
}

class Details extends StatelessWidget {
  const Details({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
