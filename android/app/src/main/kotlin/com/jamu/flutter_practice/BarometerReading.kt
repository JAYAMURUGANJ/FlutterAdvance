package com.jamu.flutter_practice

import android.content.Context
import android.hardware.Sensor
import android.hardware.SensorEvent
import android.hardware.SensorEventListener
import android.hardware.SensorManager
import io.flutter.plugin.common.EventChannel

class BarometerReading : EventChannel.StreamHandler, SensorEventListener {
   private lateinit var sensorManager: SensorManager
   lateinit var barometer : Sensor
   var latestReading: Float = 0F
    lateinit var barometerEventSink :EventChannel.EventSink

    fun init(context: Context) {
        sensorManager = context.getSystemService(Context.SENSOR_SERVICE) as SensorManager
        barometer = sensorManager.getDefaultSensor(Sensor.TYPE_PRESSURE)
        sensorManager.registerListener(this,barometer,SensorManager.SENSOR_DELAY_NORMAL)
    }


    override fun onListen(arguments: Any?, events: EventChannel.EventSink?) {
        if (events != null) {
            barometerEventSink = events
        }
    }

    override fun onCancel(arguments: Any?) {
       // barometerEventSink = null!!
    }

    override fun onSensorChanged(p0: SensorEvent?) {
       latestReading = p0!!.values[0]
        if (barometerEventSink != null){
            barometerEventSink.success(latestReading)
        }
    }

    override fun onAccuracyChanged(p0: Sensor?, p1: Int) {

    }

}
