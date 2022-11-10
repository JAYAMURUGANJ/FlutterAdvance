package com.jamu.flutter_practice
import android.content.Context
import android.net.ConnectivityManager
import android.net.Network
import android.net.NetworkCapabilities
import android.net.NetworkRequest
import android.os.Build
import androidx.annotation.RequiresApi
import io.flutter.plugin.common.EventChannel

class NetworkSpeedHandler(private var activity: MainActivity) : EventChannel.StreamHandler {
    private var networkStatsEventSink: EventChannel.EventSink? = null
    private var networkSpeed: Int? = 0

    @RequiresApi(Build.VERSION_CODES.LOLLIPOP)
    override fun onListen(arguments: Any?, events: EventChannel.EventSink?) {
        networkStatsEventSink = events
        startListeningNetworkChanges()
    }

    @RequiresApi(Build.VERSION_CODES.LOLLIPOP)
    override fun onCancel(arguments: Any?) {
        stopListeningNetworkChanges()
        networkStatsEventSink = null
       // activity = null!!
    }

    private val networkCallback = @RequiresApi(Build.VERSION_CODES.LOLLIPOP)
    object : ConnectivityManager.NetworkCallback() {
        override fun onLost(network: Network) {
            super.onLost(network)
            // Notify Flutter that the network is disconnected
            activity.runOnUiThread { networkStatsEventSink?.success(Constants.disconnected) }
        }
        override fun onCapabilitiesChanged(network: Network, netCap: NetworkCapabilities) {
            super.onCapabilitiesChanged(network, netCap)
            // Pick the supported network states and notify Flutter of this new state

             when {
                netCap.hasTransport(NetworkCapabilities.TRANSPORT_WIFI) || netCap.hasTransport(
                    NetworkCapabilities.TRANSPORT_CELLULAR) ->{
                        if(netCap.linkDownstreamBandwidthKbps in 0..149){
                            networkSpeed = Constants.poor
                        }
                        else if (netCap.linkDownstreamBandwidthKbps in 150..549){
                            networkSpeed = Constants.moderate
                        }
                        else if (netCap.linkDownstreamBandwidthKbps in 550..1999){
                            networkSpeed = Constants.good
                        }
                        else if (netCap.linkDownstreamBandwidthKbps >= 2000){
                            networkSpeed = Constants.excellent
                        }
                        else
                        {
                            networkSpeed = Constants.unknown
                        }
                    }
                //NetworkCapabilities.TRANSPORT_CELLULAR) -> (netCap.linkDownstreamBandwidthKbps)?.div(1000)
                else -> 0
            }
            activity.runOnUiThread { networkStatsEventSink?.success(networkSpeed) }
        }
    }


    @RequiresApi(Build.VERSION_CODES.LOLLIPOP)
    private fun startListeningNetworkChanges() {
        val manager = activity.getSystemService(Context.CONNECTIVITY_SERVICE) as? ConnectivityManager
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.N) {
            manager?.registerDefaultNetworkCallback(networkCallback)
        } else {
            val request = NetworkRequest.Builder()
                .addCapability(NetworkCapabilities.NET_CAPABILITY_INTERNET)
                .build()
            manager?.registerNetworkCallback(request, networkCallback)
        }
    }

    @RequiresApi(Build.VERSION_CODES.LOLLIPOP)
    private fun stopListeningNetworkChanges() {
        val manager = activity.getSystemService(Context.CONNECTIVITY_SERVICE) as? ConnectivityManager
        manager?.unregisterNetworkCallback(networkCallback)
    }
}
