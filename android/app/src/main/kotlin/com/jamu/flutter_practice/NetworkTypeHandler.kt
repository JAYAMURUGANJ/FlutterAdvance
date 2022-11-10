package com.jamu.flutter_practice
import android.app.Activity
import android.content.Context
import android.net.ConnectivityManager
import android.net.Network
import android.net.NetworkCapabilities
import android.net.NetworkRequest
import android.os.Build
import androidx.annotation.RequiresApi
import io.flutter.plugin.common.EventChannel

class NetworkTypeHandler(private var activity: Activity?) : EventChannel.StreamHandler {

    private var networkStatsEventSink: EventChannel.EventSink? = null


    @RequiresApi(Build.VERSION_CODES.LOLLIPOP)
    override fun onListen(arguments: Any?, events: EventChannel.EventSink?) {
        networkStatsEventSink = events
        startListeningNetworkChanges()
    }

    @RequiresApi(Build.VERSION_CODES.LOLLIPOP)
    override fun onCancel(arguments: Any?) {
        stopListeningNetworkChanges()
        networkStatsEventSink = null
        activity = null
    }

    private val networkCallback = @RequiresApi(Build.VERSION_CODES.LOLLIPOP)
    object : ConnectivityManager.NetworkCallback() {
        override fun onLost(network: Network) {
            super.onLost(network)
            // Notify Flutter that the network is disconnected
            activity?.runOnUiThread { networkStatsEventSink?.success(Constants.disconnected) }
        }
        override fun onCapabilitiesChanged(network: Network, netCap: NetworkCapabilities) {
            super.onCapabilitiesChanged(network, netCap)
            // Pick the supported network states and notify Flutter of this new state
            val networkTypeStatus =
                when {
                    netCap.hasTransport(NetworkCapabilities.TRANSPORT_WIFI) -> Constants.wifi
                    netCap.hasTransport(NetworkCapabilities.TRANSPORT_CELLULAR) -> Constants.cellular
                    else -> Constants.unknownNetwork
                }
            activity?.runOnUiThread { networkStatsEventSink?.success(networkTypeStatus) }
        }
    }


    @RequiresApi(Build.VERSION_CODES.LOLLIPOP)
    private fun startListeningNetworkChanges() {
        val manager = activity?.getSystemService(Context.CONNECTIVITY_SERVICE) as? ConnectivityManager
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
        val manager = activity?.getSystemService(Context.CONNECTIVITY_SERVICE) as? ConnectivityManager
        manager?.unregisterNetworkCallback(networkCallback)
    }
}
