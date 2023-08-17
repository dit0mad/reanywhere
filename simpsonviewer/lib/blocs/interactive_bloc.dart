import 'package:coreapp/data/data_bloc/data_bloc.dart';
import 'package:coreapp/http_service/http_service.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

abstract class BaseInteractiveState extends Equatable {
  const BaseInteractiveState();

  @override
  List<Object?> get props => [];
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
  List<Object?> get props => [searchTerm, selectedCharacter, dataState];
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
    on<LoadData>(
      (event, emit) {
        final nextState = InteractiveState(
          selectedCharacter: event.dataState.characters.first,
          dataState: event.dataState,
        );

        emit(nextState);
      },
    );
    on<SearchValue>((event, emit) {
      final nextState = state as InteractiveState;

      emit(nextState.copyWith(
        searchTerm: event.searchTerm,
      ));
    });

    on<SetCharacterDetail>((event, emit) {
      final nextState = state as InteractiveState;

      final nextCharacter =
          nextState.dataState.characters.elementAt(event.index);

      emit(nextState.copyWith(selectedCharacter: nextCharacter));
    });
  }
}
