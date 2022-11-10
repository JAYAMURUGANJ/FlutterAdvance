import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_practice/apiCall/bloc/call_api_bloc.dart';
import 'package:flutter_practice/apiCall/data/model/joke_model.dart';
import 'package:flutter_practice/appTheme/view/theme_page.dart';
import 'package:flutter_practice/calculator/views/calculator_page.dart';
import 'package:flutter_practice/dark_light_mode/isDart_mode.dart';
import 'package:flutter_practice/eventChannel/call_native.dart';
import 'package:flutter_practice/util/device_info_service.dart';
import 'package:flutter_practice/util/connectivity_service.dart';
import '../../eventChannel/network_stream.dart';
import '../data/repositories/joke_repository.dart';

class JokePage extends StatelessWidget {
  const JokePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => CallApiBloc(
        ConnectivityService(),
        JokeRepository(),
        DeviceInfoService(),
      )..add(LoadApiEvent()),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('The Joke App'),
          actions: [
            IconButton(
              icon: const Icon(Icons.calculate),
              tooltip: 'calculator',
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => CalculatorPage()),
                );
              },
            ),
            IconButton(
              icon: const Icon(Icons.color_lens),
              tooltip: 'change color',
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const PreferencePage()),
                );
              },
            ),
            IconButton(
              icon: const Icon(Icons.home),
              tooltip: 'call navtive',
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const MyHomePage()),
                );
              },
            ),
            IconButton(
              icon: const Icon(Icons.dark_mode),
              tooltip: 'mode',
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const IsDarkMode()),
                );
              },
            ),
          ],
        ),
        body: Column(
          children: [
            const NetworkStreamWidget(),
            //using bloc
            Expanded(
              child: BlocBuilder<CallApiBloc, CallApiState>(
                builder: (context, state) {
                  if (state is ApiLoadingState) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  if (state is HomeNoInternetState) {
                    return const Center(child: Text("No Internet Connection"));
                  }
                  if (state is ApiLoadedState) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          ExpansionTile(
                            title: Text(
                              state.joke.setup,
                              textAlign: TextAlign.center,
                            ),
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  state.joke.delivery,
                                  style: const TextStyle(
                                    fontSize: 20,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ],
                          ),
                          ElevatedButton(
                            onPressed: () {
                              BlocProvider.of<CallApiBloc>(context)
                                  .add(LoadApiEvent());
                            },
                            child: const Text('Load New Joke'),
                          ),
                        ],
                      ),
                    );
                  }
                  if (state is ApiErrorState) {
                    return Center(
                      child: Text(state.error.toString()),
                    );
                  }
                  return Container();
                },
              ),
            ),
            //using stream builder
            StreamBuilder<JokeModel>(
                stream: JokeRepository().stream,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  } else if (snapshot.hasData) {
                    return ExpansionTile(
                      title: Text(
                        snapshot.data!.setup,
                        textAlign: TextAlign.center,
                      ),
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            snapshot.data!.delivery,
                            style: const TextStyle(
                              fontSize: 20,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                    );
                  } else if (snapshot.connectionState == ConnectionState.none) {
                    return const Center(
                      child: Text("No Data Available"),
                    );
                  } else if (snapshot.hasError) {
                    return const Center(
                      child: Text("Something went wrong"),
                    );
                  }
                  return const Center();
                }),
          ],
        ),
      ),
    );
  }
}
