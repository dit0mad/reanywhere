import 'package:coreapp/app_config.dart';
import 'package:coreapp/core_app.dart';
import 'package:coreapp/data/data_bloc/data_bloc.dart';
import 'package:coreapp/data/events/data_events.dart';
import 'package:coreapp/http_service/http_service.dart';
import 'package:coreapp/navigation/bloc/nav_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'blocs/interactive_bloc.dart';
import 'observer.dart';
import 'pages/route_names.dart';

//blocs -> baselayout -> entrypoint -> navigator

void main() {
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);

  WidgetsFlutterBinding.ensureInitialized();

  //configure the settings to pass to bloc here.
  const AppConfig appConfig = AppConfig(
      flavor: Flavor.simpson,
      httpService: HttpService(
          url: 'http://api.duckduckgo.com/?q=simpsons+characters&format=json'),
      mobile: mobileStack,
      tablet: tableStack);

  Bloc.observer = const ViewerBlocObserver();
  runApp(MultiBlocProvider(
    providers: [
      BlocProvider(
        create: (_) => DataBloc(
          appConfig: appConfig,
        )..add(const GetData()),
      ),
      BlocProvider(
          create: (_) => NaavBloc(
                mobileStack: appConfig.mobile,
                tabletStack: appConfig.tablet,
              )),
      BlocProvider(create: (_) => InteractiveBloc()),
      BlocListener<DataBloc, DataState>(
        listener: (context, state) {
          if (state is DataLoadedState) {
            BlocProvider.of<InteractiveBloc>(context).add(
              LoadData(dataState: state),
            );
          }
        },
      ),
    ],
    child: const MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: const BaseLayout());
  }
}
