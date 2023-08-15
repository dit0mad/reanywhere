import 'package:coreapp/app_config.dart';
import 'package:coreapp/http_service/http_service.dart';
import 'package:coreapp/navigation/bloc/nav_bloc.dart';
import 'package:coreapp/navigation/bloc/nav_events.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:wireviewer/blocs/interactive_bloc.dart';
import 'package:wireviewer/main.dart';
import 'package:wireviewer/pages/mobile/detail_screen.dart';

class GlobalSearchBar extends StatefulWidget {
  const GlobalSearchBar({super.key});

  @override
  State<GlobalSearchBar> createState() => _GlobalSearchBarState();
}

class _GlobalSearchBarState extends State<GlobalSearchBar> {
  final TextEditingController controller = TextEditingController();
  String result = getStringFromCase(appConfig.flavor);

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
                        const SearchValue(searchTerm: null),
                      );
                    },
                    constraints:
                        const BoxConstraints(minHeight: 36, minWidth: 36),
                  ),
                  contentPadding: EdgeInsets.zero,
                  isDense: true,
                  filled: true,
                  fillColor: Colors.amber,
                  hintText: result,
                  enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: BorderSide.none),
                )),
          )),
    );
  }
}

String getStringFromCase(Flavor flavor) {
  String result = "";
  switch (flavor) {
    case Flavor.simpson:
      result = "The Simpson Characters";
      break;
    case Flavor.other:
      result = "The Wireviewer Characters";
      break;

    default:
      result = "";
  }
  return result;
}

class SearchItems extends StatelessWidget {
  const SearchItems({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final List<BaseCharacter> searchedCharacters = [];
    final interactiveBloc = BlocProvider.of<InteractiveBloc>(context);
    final navBloc = BlocProvider.of<NavigationBloc>(context);
    return BlocBuilder<InteractiveBloc, BaseInteractiveState>(
      builder: (context, state) {
        if (state is InteractiveState) {
          searchedCharacters.clear();
          final allChars = state.dataState.characters;

          final searchTerm = state.searchTerm;

          if (searchTerm != null) {
            searchedCharacters.clear();

            searchedCharacters.addAll(allChars.where(
                (element) => element.title.toLowerCase().contains(searchTerm)));
          }

          if (searchedCharacters.isNotEmpty) {
            return Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    ...searchedCharacters.map(
                      (e) {
                        final index = state.dataState.characters.indexOf(e);
                        return TextButton(
                          child: Text(e.title),
                          onPressed: () {
                            interactiveBloc
                                .add(SetCharacterDetail(index: index));
                            navBloc.add(const PushPageRoute(
                                page: MaterialPage(
                                  child: CharacterDetail(),
                                ),
                                target: Target.mainStackMobile));
                          },
                        );
                      },
                    ),
                  ],
                ),
              ),
            );
          }
        }

        return SizedBox();
      },
    );
  }
}
