import 'package:coreapp/http_service/http_service.dart';
import 'package:coreapp/navigation/bloc/nav_bloc.dart';
import 'package:coreapp/navigation/bloc/nav_events.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../blocs/interactive_bloc.dart';
import 'detail_screen.dart';

class MobileMainScreen extends StatefulWidget {
  const MobileMainScreen({super.key});

  @override
  State<MobileMainScreen> createState() => _MobileMainScreenState();
}

class _MobileMainScreenState extends State<MobileMainScreen> {
  late InteractiveBloc interactiveBloc;
  late NavigationBloc navBloc;

  final List<String> _searchedCharacters = [];

  @override
  void didChangeDependencies() {
    interactiveBloc = BlocProvider.of<InteractiveBloc>(context);
    navBloc = BlocProvider.of<NavigationBloc>(context);
    super.didChangeDependencies();

    // if (interactiveBloc.state is InteractiveState) {
    //   final state = interactiveBloc.state as InteractiveState;

    //   final characters = state.dataState.characters.map((e) => e.title);
    //   final searchTerm = state.searchTerm;

    //   _searchedCharacters.addAll(
    //       characters.where((element) => element.contains('$searchTerm')));
    // }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<InteractiveBloc, BaseInteractiveState>(
      builder: (context, state) {
        if (state is InteractiveState) {
          _searchedCharacters.clear();
          final selectedChar = state.selectedCharacter;

          final characterss = state.dataState.characters.map((e) => e.title);
          final searchTerm = state.searchTerm;

          if (searchTerm != null) {
            _searchedCharacters.clear();
            _searchedCharacters.addAll(characterss
                .where((element) => element.contains('$searchTerm')));
          }

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
            child: Stack(
              children: [
                Column(
                  children: [
                    const SearchBar(),
                    if (_searchedCharacters.isNotEmpty)
                      Expanded(
                          child: SingleChildScrollView(
                        child: Column(
                          children: [
                            ..._searchedCharacters.map((e) => Text(e)),
                          ],
                        ),
                      )),
                    Expanded(
                      child: Ink(
                        color: Colors.green,
                        child: SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              ...characters,
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
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

class SearchBar extends StatefulWidget {
  const SearchBar({super.key});

  @override
  State<SearchBar> createState() => _SearchBarState();
}

class _SearchBarState extends State<SearchBar> {
  final TextEditingController controller = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    controller.dispose();
  }

  void _handleSearchInput(final String newStr) {
    BlocProvider.of<InteractiveBloc>(context).add(
      SearchValue(searchTerm: controller.text),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
          child: SizedBox(
            height: 30,
            child: TextFormField(
                onChanged: _handleSearchInput,
                textAlignVertical: TextAlignVertical.center,
                controller: controller,
                textInputAction: TextInputAction.search,
                decoration: InputDecoration(
                  prefixIcon: IconButton(
                    icon: const Icon(Icons.search),
                    iconSize: 20,
                    onPressed: () {
                      BlocProvider.of<InteractiveBloc>(context).add(
                        SearchValue(searchTerm: controller.text),
                      );
                    },
                    constraints:
                        const BoxConstraints(minHeight: 36, minWidth: 36),
                  ),
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.clear),
                    iconSize: 20,
                    onPressed: () {
                      controller.clear();
                      BlocProvider.of<InteractiveBloc>(context).add(
                        SearchValue(searchTerm: controller.text),
                      );
                    },
                    constraints:
                        const BoxConstraints(minHeight: 36, minWidth: 36),
                  ),
                  contentPadding: EdgeInsets.zero,
                  isDense: true,
                  filled: true,
                  fillColor: Colors.amber,
                  hintText: 'The Simpson Characters',
                  enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: BorderSide.none),
                )),
          )),
    );
  }
}
