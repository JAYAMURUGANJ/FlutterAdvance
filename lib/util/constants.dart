class ConnectionType {
  /// Event for when network state changes to Wifi
  static const wifi = 0xFF;

  /// Event for when network state changes to cellular/mobile data
  static const cellular = 0xEE;

  /// Event for when network is disconnected
  static const disconnected = 0xDD;

  /// Event for when network state is a state you do not
  /// support (e.g VPN or Ethernet on Android)
  static const unknown = 0xCC;
}

class ConnectionSpeedState {
  //Bandwidth under 150 kbps.
  static const poor = 1;

  // Bandwidth between 150 and 550 kbps.
  static const moderate = 2;

  // Bandwidth between 550 and 2000 kbps.
  static const good = 3;

  // EXCELLENT - Bandwidth over 2000 kbps.
  static const excellent = 4;

  //Placeholder for unknown bandwidth. This is the initial value and will stay at this value
  //if a bandwidth cannot be accurately found.
  static const unknown = 5;
}
