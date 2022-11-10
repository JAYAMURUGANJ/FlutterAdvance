// ignore_for_file: file_names

import 'package:flutter/services.dart';
import 'package:flutter/material.dart';

class IsDarkMode extends StatefulWidget {
  const IsDarkMode({super.key});

  @override
  State<IsDarkMode> createState() => _IsDarkModeState();
}

class _IsDarkModeState extends State<IsDarkMode> {
  String _theme = '';
  static const events = EventChannel('EventChannelCheckDeviceMode');

  @override
  void initState() {
    super.initState();
    //call the event channel to check the device mode state
    events.receiveBroadcastStream().listen(checkDeviceMode);
  }

  void checkDeviceMode(Object? event) =>
      setState(() => _theme = event == true ? 'dark' : 'light');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("App Mode"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'System color theme:',
            ),
            Text(
              _theme,
              style: Theme.of(context).textTheme.headline4,
            ),
          ],
        ),
      ),
    );
  }
}
