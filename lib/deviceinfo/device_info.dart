import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_practice/apiCall/apiCall.dart';
import '../apiCall/data/repositories/joke_repository.dart';
import '../util/connectivity_service.dart';
import '../util/device_info_service.dart';

class DeviceInfo extends StatefulWidget {
  const DeviceInfo({Key? key}) : super(key: key);

  @override
  State<DeviceInfo> createState() => _DeviceInfoState();
}

class _DeviceInfoState extends State<DeviceInfo> {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => CallApiBloc(
            ConnectivityService(),
            JokeRepository(),
            DeviceInfoService(),
          )..add(GetDeviceInfoEvent()),
        )
      ],
      child: Scaffold(
          appBar: AppBar(
            title: Text(
              kIsWeb
                  ? 'Web Browser info'
                  : Platform.isAndroid
                      ? 'Android Device Info'
                      : Platform.isIOS
                          ? 'iOS Device Info'
                          : Platform.isLinux
                              ? 'Linux Device Info'
                              : Platform.isMacOS
                                  ? 'MacOS Device Info'
                                  : Platform.isWindows
                                      ? 'Windows Device Info'
                                      : '',
            ),
          ),
          body:
              BlocBuilder<CallApiBloc, CallApiState>(builder: (context, state) {
            if (state is LoadingDeviceInfo) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            if (state is HomeNoInternetState) {
              return const Center(
                child: Text("No Internetwork"),
              );
            }
            if (state is DeviceInfoError) {
              return Center(
                child: Text(state.error.toString()),
              );
            }
            if (state is LoadedDeviceInfo) {
              return ListView(
                children: state.deviceData.keys.map(
                  (String property) {
                    return Row(
                      children: <Widget>[
                        Container(
                          padding: const EdgeInsets.all(10.0),
                          child: Text(
                            property,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Expanded(
                            child: Container(
                          padding:
                              const EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 10.0),
                          child: Text(
                            '${state.deviceData[property]}',
                            maxLines: 10,
                            overflow: TextOverflow.ellipsis,
                          ),
                        )),
                      ],
                    );
                  },
                ).toList(),
              );
            }
            return Container();
          })),
    );
  }
}
