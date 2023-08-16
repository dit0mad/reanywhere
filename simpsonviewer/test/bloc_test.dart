import 'package:bloc_test/bloc_test.dart';
import 'package:coreapp/data/data_bloc/data_bloc.dart';
import 'package:coreapp/http_service/http_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/mockito.dart';
import 'package:simpsonsviewer/blocs/interactive_bloc.dart';

final Map<String, List<BaseCharacter>> characters = {
  'first': [
    SimpsonCharacter(description: 'description', image: 'image', title: 'title')
  ]
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

    final dataState = DataLoadedState(
        characters: [...characters.values.first], title: 'title');

    test('initial state is InitInteractiveState', () {
      expect(inbloc.state, isA<InitInteractiveState>());
    });

    blocTest(
      'emits [InteractiveState] when LoadData is added',
      build: () => inbloc,
      act: (inbloc) => inbloc.add(LoadData(dataState: dataState)),
      expect: () => [isA<InteractiveState>()],
    );

    blocTest(
      'emits [InteractiveState] when SetCharacterDetail is added',
      build: () => inbloc,
      act: (inbloc) {
        inbloc.add(SetCharacterDetail(index: 1));

        final nextStae = inbloc.state as InteractiveState;

        final resolved =
            nextStae.copyWith(selectedCharacter: characters.values.first.first);

        return resolved;
      },
      expect: () => [isA<InteractiveState>()],
    );
  });
}
