import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hello/app_config.dart';
import 'package:hello/data/events/data_events.dart';
import 'package:hello/http_service/http_service.dart';

abstract class DataState {
  const DataState();
}

class InitDataState extends DataState {
  const InitDataState();
}

class DataLoadedState extends DataState {
  final List<BaseCharacter> characters;
  final String title;

  final BaseCharacter? selectedCharacter;

  DataLoadedState({
    required this.characters,
    required this.title,
    this.selectedCharacter,
  });

  DataLoadedState copyWith({
    final List<BaseCharacter>? characters,
    final String? title,
    final BaseCharacter? selectedCharacter,
  }) =>
      DataLoadedState(
          characters: characters ?? this.characters,
          title: title ?? this.title,
          selectedCharacter: selectedCharacter ?? this.selectedCharacter);
}

class DataBloc extends Bloc<ApiEvents, DataState> {
  final AppConfig appConfig;

  DataBloc({required this.appConfig})
      : super(
          const InitDataState(),
        ) {
    on<GetData>((event, emit) async {
      final httpService = appConfig.httpService;

      final flavor = appConfig.flavor;

      final data = await httpService.getData();

      switch (flavor) {
        case Flavor.simpson:
          final re = data.values.first.map((e) => SimpsonCharacter.fromType(e));
          emit(
            DataLoadedState(
                characters: re.toList(),
                title: data.keys.first,
                selectedCharacter: re.first),
          );
          break;
        case Flavor.other:
          break;
        default:
      }
    });
  }
}
