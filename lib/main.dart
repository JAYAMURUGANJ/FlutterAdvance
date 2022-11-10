import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_practice/apiCall/apiCall.dart';
import 'package:flutter_practice/apiCall/data/repositories/joke_repository.dart';
import 'package:flutter_practice/calculator/data/repositories/operation_repository.dart';
import 'package:path_provider/path_provider.dart';
import 'appTheme/apptheme.dart';
import 'calculator/calculator.dart';
import 'mybloc_observer.dart';
import 'util/device_info_service.dart';
import 'util/connectivity_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  HydratedBloc.storage = await HydratedStorage.build(
      storageDirectory: await getApplicationSupportDirectory());

  Bloc.observer = MyBlocObserver();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<CalculatorBloc>(
          create: (context) => CalculatorBloc(
            operationRepository: OperationRepository(),
          ),
        ),
        BlocProvider<CallApiBloc>(
          create: (context) => CallApiBloc(
            ConnectivityService(),
            JokeRepository(),
            DeviceInfoService(),
          ),
        ),
        BlocProvider<ThemeBloc>(
          create: (context) => ThemeBloc(),
        )
      ],
      child: BlocBuilder<ThemeBloc, ThemeState>(
        builder: (context, state) {
          return MaterialApp(
            title: 'Flutter Demo',
            debugShowCheckedModeBanner: false,
            theme: state.themeData,
            darkTheme: ThemeData.dark(),
            themeMode: ThemeMode.system,
            home: const JokePage(),
          );
        },
      ),
    );
  }
}
