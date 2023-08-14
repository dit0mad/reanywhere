import 'package:bloc_test/bloc_test.dart';
import 'package:coreapp/app_config.dart';
import 'package:coreapp/data/data_bloc/data_bloc.dart';
import 'package:coreapp/data/events/data_events.dart';
import 'package:coreapp/http_service/http_service.dart';

import 'package:flutter_test/flutter_test.dart';

import 'package:mockito/mockito.dart';

import '../lib/pages/route_names.dart';
import 'mock_service.dart';

void main() {
  final Map<String, List<BaseCharacter>> characters = {
    'first': [
      SimpsonCharacter(
          description: 'description', image: 'image', title: 'title')
    ]
  };

  group('MyBloc', () {
    final MockApiService mockApiService = MockApiService();

    final AppConfig appConfig = AppConfig(
        flavor: Flavor.simpson,
        httpService: mockApiService,
        mobile: mobileStack,
        tablet: tableStack);

    blocTest<DataBloc, DataState>(
      'emits [Loading, Loaded] when successful',
      build: () {
        when(mockApiService.getData()).thenAnswer(
          (_) async {
            print('Mock getData() called');
            return {
              'first': [
                SimpsonCharacter(
                    description: 'description', image: 'image', title: 'title')
              ]
            };
          },
        );
        return DataBloc(appConfig: appConfig);
      },
      act: (bloc) => bloc.add(const GetData()),
      expect: () => [
        DataLoadedState(
            characters: characters.values.first, title: characters.keys.first)
      ],
    );
  });
}
