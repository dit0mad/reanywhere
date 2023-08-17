import 'package:bloc_test/bloc_test.dart';
import 'package:coreapp/data/data_bloc/data_bloc.dart';
import 'package:coreapp/http_service/http_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/mockito.dart';
import 'package:simpsonsviewer/blocs/interactive_bloc.dart';

final Map<String, List<BaseCharacter>> characters = {
  'first': [
    SimpsonCharacter(
        description: 'description', image: 'image', title: 'title'),
    SimpsonCharacter(
        description: 'description2', image: 'image2', title: 'title2'),
  ],
};

abstract class HttpService {
  Future<http.Response> fetchData();
}

class MockApiService extends Mock implements HttpService {}

Future<http.Response> helperFunc() async {
  return http.Response('Mocked Response', 200);
}

void main() {
  group('Event to state tests', () {
    late InteractiveBloc inbloc;

    setUp(() {
      inbloc = InteractiveBloc();
    });

    final dataState = DataLoadedState(characters: [
      ...characters.values.first,
    ], title: 'title');

    test('initial state is InitInteractiveState', () {
      expect(inbloc.state, isA<InitInteractiveState>());
    });

    final event1 = LoadData(dataState: dataState);

    inbloc.add(event1);

    test('description', () {
      expect(inbloc.state, isA<InteractiveState>());
    });

    blocTest(
      'emits [InteractiveState] when LoadData is added',
      build: () => InteractiveBloc(),
      act: (bloc) => bloc
        ..add(LoadData(dataState: dataState))
        ..add(SetCharacterDetail(index: 1)),
      expect: () => [
        isA<InteractiveState>(),
        isA<InteractiveState>(),
      ],
    );
  });
}
