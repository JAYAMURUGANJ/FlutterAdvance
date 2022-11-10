package com.jamu.flutter_practice

object Constants {
    const val wifi = 0xFF
    const val cellular = 0xEE
    const val disconnected = 0xDD
    const val unknownNetwork = 0xCC
    const val eof = -0xFFFFFF

    //Bandwidth under 150 kbps.
    const val poor = 1

    // Bandwidth between 150 and 550 kbps.
    const val moderate = 2

    // Bandwidth between 550 and 2000 kbps.
    const val good = 3

    // EXCELLENT - Bandwidth over 2000 kbps.
    const val excellent = 4

    //Placeholder for unknown bandwidth. This is the initial value and will stay at this value
    //if a bandwidth cannot be accurately found.
    const val unknown = 0
}