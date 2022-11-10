part of 'call_api_bloc.dart';

abstract class CallApiState extends Equatable {

}

class ApiLoadingState extends CallApiState {
  @override
  List<Object?> get props => [];
}

class ApiLoadedState extends CallApiState {
  final JokeModel joke;
  ApiLoadedState(this.joke);
  @override
  List<Object?> get props => [joke];

  Map<String, dynamic> toJson() {
    return {'joke': joke};
  }
}

class ApiErrorState extends CallApiState {
  final String error;
  ApiErrorState(this.error);
  @override
  List<Object?> get props => [error];
}

class HomeNoInternetState extends CallApiState {
  @override
  List<Object?> get props => [];
}

class LoadingDeviceInfo extends CallApiState {
  @override
  List<Object?> get props => [];
}

// ignore: must_be_immutable
class LoadedDeviceInfo extends CallApiState {
  Map<String, dynamic> deviceData = <String, dynamic>{};
  LoadedDeviceInfo(this.deviceData);
  @override
  List<Object?> get props => [deviceData];
}

class DeviceInfoError extends CallApiState {
  final String error;
  DeviceInfoError(this.error);
  @override
  List<Object?> get props => [error];
}
