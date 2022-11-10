package com.jamu.flutter_practice

import android.content.pm.ActivityInfo
import android.content.res.Configuration
import io.flutter.plugin.common.EventChannel

class CheckDeviceMode : EventChannel.StreamHandler{
    var deviceModeEventSink: EventChannel.EventSink? = null
    var oldConfig: Configuration? = null

    fun isDarkModeConfigUpdated(config: Configuration): Boolean {
        return (config.diff(oldConfig) and ActivityInfo.CONFIG_UI_MODE) != 0
                && isDarkMode(config) != isDarkMode(oldConfig);
    }

    fun isDarkMode(config: Configuration?): Boolean {
        return config!!.uiMode and Configuration.UI_MODE_NIGHT_MASK == Configuration.UI_MODE_NIGHT_YES
    }

    override fun onListen(arguments: Any?, es: EventChannel.EventSink?) {
        deviceModeEventSink = es
        deviceModeEventSink?.success(isDarkMode(oldConfig))
    }

    override fun onCancel(arguments: Any?) {

    }

}
