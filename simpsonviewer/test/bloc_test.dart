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
  ;
}

void main() {
  group('Event to state tests', () {
    final dataState = DataLoadedState(
        characters: [...characters.values.first], title: 'title');

    blocTest(
      'emits [InteractiveState] when LoadData is added',
      build: () => InteractiveBloc(),
      act: (bloc) => bloc.add(LoadData(dataState: dataState)),
      expect: () => [
        isA<InteractiveState>(),
      ],
    );
    test('Mock API Request', () async {
      final mockApiService = MockApiService();
      // Use when().thenReturn() to specify what the mock should return
      when(mockApiService.fetchData())
          .thenAnswer((realInvocation) async => helperFunc());

      verify(mockApiService.fetchData()).called(1);
    });
  });
}

// import 'package:bloc_test/bloc_test.dart';
// import 'package:coreapp/app_config.dart';
// import 'package:coreapp/data/data_bloc/data_bloc.dart';
// import 'package:coreapp/data/events/data_events.dart';
// import 'package:coreapp/http_service/http_service.dart' as ht;

// import 'package:flutter_test/flutter_test.dart';

// import 'package:mockito/mockito.dart';
// import 'package:simpsonsviewer/pages/route_names.dart';

// import 'mock_service.dart';

// import 'package:http/http.dart' as http;






// void main() {


//   group('MyBloc', () {
//     MockApiService mockApiService = MockApiService();

//     AppConfig appConfig = const AppConfig(
//         flavor: Flavor.simpson,
//         httpService: ht.HttpService(url: ''),
//         mobile: mobileStack,
//         tablet: tableStack);

//     blocTest<DataBloc, DataState>(
//       'emits [Loading, Loaded] when successful',
//       build: () {
//         when(mockApiService.fetchData()).thenAnswer(
//           (_) async {
//             print('Mock getData() called');
//             return http.Response('Mocked Response', 200);
//           },
//         );
//         return DataBloc(appConfig: appConfig);
//       },
//       act: (bloc) => bloc.add(const GetData()),
//       expect: () => [
//         DataLoadedState(
//             characters: characters.values.first, title: characters.keys.first)
//       ],
//     );
//   });
// }
