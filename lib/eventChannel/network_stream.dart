import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../util/utils.dart';

class NetworkStreamWidget extends StatelessWidget {
  const NetworkStreamWidget({Key? key}) : super(key: key);
  final networkTypeEventChannel =
      const EventChannel('EventChannelCheckNetworkStatus');

  @override
  Widget build(BuildContext context) {
    final networkStream = networkTypeEventChannel
        .receiveBroadcastStream()
        .distinct()
        .map((dynamic event) => intToConnection(event as int));

    return StreamBuilder<Connection>(
      initialData: Connection.disconnected,
      stream: networkStream,
      builder: (context, snapshot) {
        final connection = snapshot.data ?? Connection.unknown;
        final message = getConnectionMessage(connection);
        final color = getConnectionColor(connection);
        return _NetworkStateWidget(message: message, color: color);
      },
    );
  }
}

class _NetworkStateWidget extends StatelessWidget {
  final String message;
  final Color color;
  const _NetworkStateWidget({required this.message, required this.color});
  final EventChannel networkSpeedEventChannel =
      const EventChannel('EventChannelCheckNetworkSpeed');
  @override
  Widget build(BuildContext context) {
    final networkStream = networkSpeedEventChannel
        .receiveBroadcastStream()
        .map<String>((event) => intToConnectionQuality(event as int));
    return AnimatedContainer(
      color: color,
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      duration: kThemeAnimationDuration,
      child: StreamBuilder(
        stream: networkStream,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  message,
                  style: Theme.of(context).textTheme.bodyText2!.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                ),
                const SizedBox(
                  width: 10.0,
                ),
                message != "Offline"
                    ? Container(
                        height: 25,
                        decoration: const BoxDecoration(
                          color: Colors.black,
                          borderRadius: BorderRadius.all(Radius.circular(100)),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 4.0, horizontal: 5.0),
                          child: Center(
                            child: Text(
                              snapshot.data.toString(),
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyText2!
                                  .copyWith(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                            ),
                          ),
                        ),
                      )
                    : const SizedBox()
              ],
            );
          }
          return Center(
            child: Text(
              "offline",
              style: Theme.of(context).textTheme.bodyText2!.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
            ),
          );
        },
      ),
    );
  }
}
