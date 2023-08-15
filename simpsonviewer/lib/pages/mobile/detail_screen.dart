import 'package:coreapp/navigation/bloc/nav_bloc.dart';
import 'package:coreapp/navigation/bloc/nav_events.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:simpsonsviewer/pages/tablet/tablet_main.dart';

import '../../blocs/interactive_bloc.dart';

class CharacterDetail extends StatelessWidget {
  const CharacterDetail({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<InteractiveBloc, BaseInteractiveState>(
      builder: (context, state) {
        if (state is InteractiveState) {
          final selectedCharacter = state.selectedCharacter;
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
                  Expanded(
                    child: Ink(
                      color: Colors.green,
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            const ResolveImage(),
                            Center(child: Text(selectedCharacter!.title)),
                            Center(child: Text(selectedCharacter!.description))
                          ],
                        ),
                      ),
                    ),
                  ),
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

class ResolveImage extends StatelessWidget {
  const ResolveImage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<InteractiveBloc, BaseInteractiveState>(
      builder: (context, state) {
        if (state is InteractiveState) {
          final selectedCharacter = state.selectedCharacter;

          final image = selectedCharacter!.image;

          final Widget wid = image.isNotEmpty
              ? Image.network(selectedCharacter.image)
              : SizedBox(
                  height: 100,
                  width: 100,
                  child: Image.asset('../core_app/assets/noimage.png'),
                );

          return wid;
        }

        return Ink();
      },
    );
  }
}
