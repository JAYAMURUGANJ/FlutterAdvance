import 'package:flutter/material.dart';
import 'constants.dart';

/// Connection is an enum of supported network states
enum Connection {
  /// When connection state is [ConnectionType.wifi]
  wifi,

  /// When connection state is [ConnectionType.cellular]
  cellular,

  /// When connection state is [ConnectionType.disconnected]
  disconnected,

  /// When connection state is [ConnectionType.unknown]
  unknown
}

/// converts the network events to the appropriate values of
/// the [Connection] enum
Connection intToConnection(int connectionInt) {
  var connection = Connection.unknown;
  switch (connectionInt) {
    case ConnectionType.wifi:
      connection = Connection.wifi;
      break;
    case ConnectionType.cellular:
      connection = Connection.cellular;
      break;
    case ConnectionType.disconnected:
      connection = Connection.disconnected;
      break;
    case ConnectionType.unknown:
      connection = Connection.unknown;
      break;
  }
  return connection;
}

/// converts the network events to the appropriate Color
Color getConnectionColor(Connection connection) {
  var color = Colors.red[900];
  switch (connection) {
    case Connection.wifi:
      color = Colors.green[800];
      break;
    case Connection.cellular:
      color = Colors.blue[900];
      break;
    case Connection.disconnected:
      color = Colors.red[900];
      break;
    case Connection.unknown:
      color = Colors.red[900];
      break;
  }
  return color!;
}

/// converts the network events to the appropriate user-readable strings
String getConnectionMessage(Connection connection) {
  var msg = 'Unknown connection';
  switch (connection) {
    case Connection.wifi:
      msg = 'Connected to Wifi';
      break;
    case Connection.cellular:
      msg = 'Connected to mobile data';
      break;
    case Connection.disconnected:
      msg = 'Offline';
      break;
    case Connection.unknown:
      msg = 'Unknown connection';
      break;
  }
  return msg;
}

String intToConnectionQuality(int connectionSpeedState) {
  var connectionSpeed = "unknown";
  switch (connectionSpeedState) {
    case ConnectionSpeedState.poor:
      connectionSpeed = "POOR";
      break;
    case ConnectionSpeedState.moderate:
      connectionSpeed = "MODERATE";
      break;
    case ConnectionSpeedState.good:
      connectionSpeed = "GOOD";
      break;
    case ConnectionSpeedState.excellent:
      connectionSpeed = "EXCELLENT";
      break;
    case ConnectionSpeedState.unknown:
      connectionSpeed = "UNKNOWN";
      break;
  }
  return connectionSpeed;
}
