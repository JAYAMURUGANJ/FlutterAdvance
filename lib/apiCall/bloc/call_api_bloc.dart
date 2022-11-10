// ignore_for_file: non_constant_identifier_names, avoid_print
import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_practice/util/device_info_service.dart';
import 'package:flutter_practice/util/connectivity_service.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import '../data/model/joke_model.dart';
import '../data/repositories/joke_repository.dart';
part 'call_api_event.dart';
part 'call_api_state.dart';

class CallApiBloc extends HydratedBloc<CallApiEvent, CallApiState> {
  final JokeRepository _jokeRepository;
  final ConnectivityService _connectivityService;
  final DeviceInfoService _deviceInfoService;
  CallApiBloc(
      this._connectivityService, this._jokeRepository, this._deviceInfoService)
      : super(ApiLoadingState()) {
    _connectivityService.connectivityStream.stream.listen((event) {
      if (event == ConnectivityResult.none) {
        print('no internet');
        add(NoInternetEvent());
      } else {
        print('yes internet');
        add(LoadApiEvent());
        add(GetDeviceInfoEvent());
      }
    });
    on<LoadApiEvent>(_LoadNewApiData);
    on<NoInternetEvent>(_NoInternetEvent);
    on<GetDeviceInfoEvent>(_GetDeviceInfo);
  }

  FutureOr<void> _LoadNewApiData(
    LoadApiEvent event,
    Emitter<CallApiState> emit,
  ) async {
    try {
      final joke = await _jokeRepository.getJoke();
      emit(ApiLoadedState(joke));
    } catch (e) {
      emit(ApiErrorState(e.toString()));
    }
  }

  FutureOr<void> _NoInternetEvent(
    NoInternetEvent event,
    Emitter<CallApiState> emit,
  ) async {
    emit(HomeNoInternetState());
  }

  FutureOr<void> _GetDeviceInfo(
    GetDeviceInfoEvent event,
    Emitter<CallApiState> emit,
  ) async {
    try {
      var deviceData = await _deviceInfoService.initPlatformState();
      emit(LoadedDeviceInfo(deviceData));
    } catch (e) {
      emit(DeviceInfoError(e.toString()));
    }
  }

  @override
  CallApiState? fromJson(Map<String, dynamic> json) {
    try {
      return json['joke'];
    } catch (e) {
      return null;
    }
  }

  @override
  Map<String, dynamic>? toJson(CallApiState state) {
    if (state is ApiLoadedState) {
      return state.toJson();
    } else {
      return null;
    }
  }
}



    // networkTypeEventChannel.receiveBroadcastStream().listen((event) {
    //   print("AM HERE");
    //   if (intToConnection(event) == Connection.disconnected &&
    //       intToConnection(event) == Connection.unknown) {
    //     print('no internet');
    //     add(NoInternetEvent());
    //   } else {
    //     print('yes internet');
    //     add(LoadApiEvent());
    //     add(GetDeviceInfoEvent());
    //   }
    // });
