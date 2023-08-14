import 'package:coreapp/data/data_bloc/data_bloc.dart';
import 'package:coreapp/http_service/http_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

abstract class BaseInteractiveState {
  const BaseInteractiveState();
}

class InteractiveState extends BaseInteractiveState {
  final BaseCharacter? selectedCharacter;

  final DataLoadedState dataState;

  const InteractiveState({
    this.selectedCharacter,
    required this.dataState,
  });
  InteractiveState copyWith({
    final BaseCharacter? selectedCharacter,
    final DataLoadedState? dataState,
  }) {
    return InteractiveState(
      selectedCharacter: selectedCharacter ?? this.selectedCharacter,
      dataState: dataState ?? this.dataState,
    );
  }
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
    on<SetCharacterDetail>((event, emit) {
      final nextState = state as InteractiveState;

      final nextCharacter =
          nextState.dataState.characters.elementAt(event.index);

      emit(nextState.copyWith(selectedCharacter: nextCharacter));
    });
  }
}
