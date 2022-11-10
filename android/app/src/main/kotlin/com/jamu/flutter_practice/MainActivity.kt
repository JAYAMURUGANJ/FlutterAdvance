package com.jamu.flutter_practice
import android.content.res.Configuration
import android.os.Bundle
import androidx.annotation.NonNull
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.MethodChannel

class MainActivity: FlutterActivity() {

    companion object{
        //method channel
        private const val METHOD_CHANNEL = "MethodChannel"
        //event channel
        private const val EVENT_CHANNEL_BAROMETER = "EventChannelBarometer"
        private const val EVENT_CHANNEL_CHECK_DEVICE_MODE = "EventChannelCheckDeviceMode"
        private const val EVENT_CHANNEL_CHECK_NETWORK_STATUS = "EventChannelCheckNetworkStatus"
        private const val EVENT_CHANNEL_CHECK_NETWORK_SPEED = "EventChannelCheckNetworkSpeed"
        //class
        private  val barometerReading = BarometerReading()
        private  val checkDeviceMode = CheckDeviceMode()

    }
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        checkDeviceMode.oldConfig = Configuration(context.resources.configuration)
    }
    override fun onConfigurationChanged(newConfig: Configuration) {
        super.onConfigurationChanged(newConfig)
        if(checkDeviceMode.isDarkModeConfigUpdated(newConfig)) {
            checkDeviceMode.deviceModeEventSink?.success(checkDeviceMode.isDarkMode(newConfig))
        }
        checkDeviceMode.oldConfig = Configuration(newConfig)
    }
    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(
            flutterEngine.dartExecutor.binaryMessenger,
            METHOD_CHANNEL
        ).setMethodCallHandler { call, result ->
            if (call.method.equals("initializeBarometer")){
                barometerReading.init(this.context)
                result.success(true)
                return@setMethodCallHandler
            }
            result.notImplemented()
            return@setMethodCallHandler
        }
        EventChannel(flutterEngine.dartExecutor.binaryMessenger, EVENT_CHANNEL_CHECK_NETWORK_STATUS).setStreamHandler(NetworkTypeHandler(this));
        EventChannel(flutterEngine.dartExecutor.binaryMessenger, EVENT_CHANNEL_CHECK_NETWORK_SPEED).setStreamHandler(NetworkSpeedHandler(this));
        EventChannel(flutterEngine.dartExecutor.binaryMessenger, EVENT_CHANNEL_CHECK_DEVICE_MODE).setStreamHandler(checkDeviceMode);
        EventChannel(flutterEngine.dartExecutor.binaryMessenger,EVENT_CHANNEL_BAROMETER).setStreamHandler(barometerReading)
    }
}

