import 'package:coreapp/data/data_bloc/data_bloc.dart';
import 'package:coreapp/http_service/http_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

abstract class BaseInteractiveState {
  const BaseInteractiveState();
}

class InteractiveState extends BaseInteractiveState {
  final BaseCharacter? selectedCharacter;

  final DataLoadedState dataState;

  final String? searchTerm;

  const InteractiveState({
    this.selectedCharacter,
    required this.dataState,
    this.searchTerm,
  });
  InteractiveState copyWith(
      {final BaseCharacter? selectedCharacter,
      final DataLoadedState? dataState,
      final String? searchTerm}) {
    return InteractiveState(
      selectedCharacter: selectedCharacter ?? this.selectedCharacter,
      dataState: dataState ?? this.dataState,
      searchTerm: searchTerm,
    );
  }

  @override
  int get hashCode =>
      selectedCharacter.hashCode ^ dataState.hashCode ^ searchTerm.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(other, this) ||
      (other is InteractiveState &&
          other.runtimeType == runtimeType &&
          other.selectedCharacter == selectedCharacter &&
          other.dataState == dataState &&
          other.searchTerm == searchTerm);
}

class InitInteractiveState extends BaseInteractiveState {}

sealed class InteractiveEvents {
  const InteractiveEvents();
}

class SetCharacterDetail extends InteractiveEvents {
  final int index;
  SetCharacterDetail({required this.index});
}

class LoadData extends InteractiveEvents {
  final DataLoadedState dataState;

  const LoadData({required this.dataState});
}

class SearchValue extends InteractiveEvents {
  final String? searchTerm;

  const SearchValue({required this.searchTerm});
}

class InteractiveBloc extends Bloc<InteractiveEvents, BaseInteractiveState> {
  InteractiveBloc() : super(InitInteractiveState()) {
    on<SearchValue>((event, emit) {
      final nextState = state as InteractiveState;

      emit(nextState.copyWith(
        searchTerm: event.searchTerm,
      ));
    });

    on<LoadData>(
      (event, emit) {
        final nextState = InteractiveState(
          selectedCharacter: event.dataState.characters.first,
          dataState: event.dataState,
        );

        emit(nextState);
      },
    );
    on<SetCharacterDetail>((event, emit) {
      final nextState = state as InteractiveState;

      final nextCharacter =
          nextState.dataState.characters.elementAt(event.index);

      emit(nextState.copyWith(selectedCharacter: nextCharacter));
    });
  }
}
