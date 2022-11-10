part of 'call_api_bloc.dart';

abstract class CallApiEvent extends Equatable {
  const CallApiEvent();
}

class LoadApiEvent extends CallApiEvent {
  @override
  List<Object> get props => [];
}

class NoInternetEvent extends CallApiEvent {
  @override
  List<Object> get props => [];
}

class GetDeviceInfoEvent extends CallApiEvent {
  @override
  List<Object> get props => [];
}
