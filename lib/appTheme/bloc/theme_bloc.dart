import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import '../apptheme.dart';
part 'theme_event.dart';
part 'theme_state.dart';

class ThemeBloc extends Bloc<ThemeEvent, ThemeState> {
  ThemeBloc()
      : super(ThemeState(themeData: appThemeData[AppTheme.GreenLight]!)) {
    on<ThemeEvent>((event, emit) {
      if (event is ThemeChange) {
        emit(ThemeState(themeData: appThemeData[event.theme]!));
      }
    });
  }
}
