import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final MethodChannel _channel = const MethodChannel('MethodChannel');
  final EventChannel _eventChannelBarometer =
      const EventChannel('EventChannelBarometer');

  final EventChannel _eventChannelNetworkStatus =
      const EventChannel('EventChannelCheckNetworkSpeed');

  Stream<double> _barometerStream = const Stream.empty();

  Future<dynamic> initializeBarometer() async {
    return _channel.invokeMethod('initializeBarometer');
  }

  Stream<double> pressureStream() {
    _barometerStream = _eventChannelBarometer
        .receiveBroadcastStream()
        .map<double>((event) => event);

    return _barometerStream;
  }

  @override
  void initState() {
    super.initState();
    initializeBarometer();
  }

  @override
  Widget build(BuildContext context) {
    final networkStream = _eventChannelNetworkStatus
        .receiveBroadcastStream()
        .map<int>((event) => event);
    return Scaffold(
      appBar: AppBar(
        title: const Text("Barometer Pressure"),
      ),
      body: Center(
        child: Column(
          children: [
            StreamBuilder(
              stream: pressureStream(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return Text("Pressure: ${snapshot.data}");
                }
                return const Text("Pressure not detected");
              },
            ),
            StreamBuilder(
              stream: networkStream,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return Text("Network: ${snapshot.data} Mbps");
                }
                return const Text("Network not detected");
              },
            ),
          ],
        ),
      ),
    );
  }
}
