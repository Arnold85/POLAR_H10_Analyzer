package com.example.polar_h10_analyzer.polar_bridge

import android.Manifest
import android.content.Context
import android.content.pm.PackageManager
import android.os.Build
import androidx.core.app.ActivityCompat
import androidx.core.content.ContextCompat
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.PluginRegistry

class PolarBridgePlugin : FlutterPlugin, ActivityAware, MethodChannel.MethodCallHandler,
    PluginRegistry.RequestPermissionsResultListener {

    companion object {
        private const val METHOD_CHANNEL_NAME = "polar_bridge/methods"
        private const val CONNECTION_STATUS_CHANNEL_NAME = "polar_bridge/connection_status"
        private const val HEART_RATE_CHANNEL_NAME = "polar_bridge/heart_rate"
        private const val ECG_CHANNEL_NAME = "polar_bridge/ecg"
        private const val ACCELERATION_CHANNEL_NAME = "polar_bridge/acceleration"
        private const val DEVICE_DISCOVERY_CHANNEL_NAME = "polar_bridge/device_discovery"
        
        private const val PERMISSION_REQUEST_CODE = 1001
    }

    private lateinit var methodChannel: MethodChannel
    private lateinit var connectionStatusChannel: EventChannel
    private lateinit var heartRateChannel: EventChannel
    private lateinit var ecgChannel: EventChannel
    private lateinit var accelerationChannel: EventChannel
    private lateinit var deviceDiscoveryChannel: EventChannel
    
    private var context: Context? = null
    private var activity: android.app.Activity? = null
    private var polarManager: PolarManager? = null
    private var permissionsPendingResult: MethodChannel.Result? = null

    override fun onAttachedToEngine(flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
        context = flutterPluginBinding.applicationContext
        
        methodChannel = MethodChannel(flutterPluginBinding.binaryMessenger, METHOD_CHANNEL_NAME)
        methodChannel.setMethodCallHandler(this)
        
        connectionStatusChannel = EventChannel(flutterPluginBinding.binaryMessenger, CONNECTION_STATUS_CHANNEL_NAME)
        heartRateChannel = EventChannel(flutterPluginBinding.binaryMessenger, HEART_RATE_CHANNEL_NAME)
        ecgChannel = EventChannel(flutterPluginBinding.binaryMessenger, ECG_CHANNEL_NAME)
        accelerationChannel = EventChannel(flutterPluginBinding.binaryMessenger, ACCELERATION_CHANNEL_NAME)
        deviceDiscoveryChannel = EventChannel(flutterPluginBinding.binaryMessenger, DEVICE_DISCOVERY_CHANNEL_NAME)
    }

    override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        methodChannel.setMethodCallHandler(null)
        polarManager?.cleanup()
        polarManager = null
    }

    override fun onAttachedToActivity(binding: ActivityPluginBinding) {
        activity = binding.activity
        binding.addRequestPermissionsResultListener(this)
        
        // Initialize Polar manager when activity is available
        context?.let { ctx ->
            polarManager = PolarManager(
                context = ctx,
                activity = activity,
                connectionStatusChannel = connectionStatusChannel,
                heartRateChannel = heartRateChannel,
                ecgChannel = ecgChannel,
                accelerationChannel = accelerationChannel,
                deviceDiscoveryChannel = deviceDiscoveryChannel
            )
        }
    }

    override fun onDetachedFromActivityForConfigChanges() {
        // Keep the plugin instance
    }

    override fun onReattachedToActivityForConfigChanges(binding: ActivityPluginBinding) {
        activity = binding.activity
        binding.addRequestPermissionsResultListener(this)
    }

    override fun onDetachedFromActivity() {
        activity = null
    }

    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        when (call.method) {
            "initialize" -> {
                initialize(result)
            }
            "isBluetoothEnabled" -> {
                isBluetoothEnabled(result)
            }
            "requestBluetoothPermissions" -> {
                requestBluetoothPermissions(result)
            }
            "startDeviceScan" -> {
                startDeviceScan(result)
            }
            "stopDeviceScan" -> {
                stopDeviceScan(result)
            }
            "connectToDevice" -> {
                val deviceId = call.argument<String>("deviceId")
                connectToDevice(deviceId, result)
            }
            "disconnectFromDevice" -> {
                disconnectFromDevice(result)
            }
            "startHeartRateStream" -> {
                startHeartRateStream(result)
            }
            "stopHeartRateStream" -> {
                stopHeartRateStream(result)
            }
            "startEcgStream" -> {
                startEcgStream(result)
            }
            "stopEcgStream" -> {
                stopEcgStream(result)
            }
            "startAccelerationStream" -> {
                startAccelerationStream(result)
            }
            "stopAccelerationStream" -> {
                stopAccelerationStream(result)
            }
            "enableMockMode" -> {
                val enabled = call.argument<Boolean>("enabled") ?: false
                enableMockMode(enabled, result)
            }
            else -> {
                result.notImplemented()
            }
        }
    }

    private fun initialize(result: MethodChannel.Result) {
        try {
            polarManager?.initialize()
            result.success(null)
        } catch (e: Exception) {
            result.error("INITIALIZATION_FAILED", "Failed to initialize Polar bridge", e.message)
        }
    }

    private fun isBluetoothEnabled(result: MethodChannel.Result) {
        try {
            val enabled = polarManager?.isBluetoothEnabled() ?: false
            result.success(enabled)
        } catch (e: Exception) {
            result.error("BLUETOOTH_CHECK_FAILED", "Failed to check Bluetooth status", e.message)
        }
    }

    private fun requestBluetoothPermissions(result: MethodChannel.Result) {
        if (activity == null) {
            result.error("NO_ACTIVITY", "Activity not available", null)
            return
        }

        val permissionsToRequest = getRequiredPermissions().filter { permission ->
            ContextCompat.checkSelfPermission(activity!!, permission) != PackageManager.PERMISSION_GRANTED
        }

        if (permissionsToRequest.isEmpty()) {
            result.success(true)
            return
        }

        permissionsPendingResult = result
        ActivityCompat.requestPermissions(
            activity!!,
            permissionsToRequest.toTypedArray(),
            PERMISSION_REQUEST_CODE
        )
    }

    private fun getRequiredPermissions(): List<String> {
        val permissions = mutableListOf<String>()
        
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.S) {
            permissions.addAll(listOf(
                Manifest.permission.BLUETOOTH_SCAN,
                Manifest.permission.BLUETOOTH_CONNECT,
                Manifest.permission.ACCESS_FINE_LOCATION
            ))
        } else {
            permissions.addAll(listOf(
                Manifest.permission.BLUETOOTH,
                Manifest.permission.BLUETOOTH_ADMIN,
                Manifest.permission.ACCESS_FINE_LOCATION
            ))
        }
        
        return permissions
    }

    override fun onRequestPermissionsResult(
        requestCode: Int,
        permissions: Array<out String>,
        grantResults: IntArray
    ): Boolean {
        if (requestCode == PERMISSION_REQUEST_CODE) {
            val allGranted = grantResults.all { it == PackageManager.PERMISSION_GRANTED }
            permissionsPendingResult?.success(allGranted)
            permissionsPendingResult = null
            return true
        }
        return false
    }

    private fun startDeviceScan(result: MethodChannel.Result) {
        try {
            polarManager?.startDeviceScan()
            result.success(null)
        } catch (e: Exception) {
            result.error("SCAN_START_FAILED", "Failed to start device scan", e.message)
        }
    }

    private fun stopDeviceScan(result: MethodChannel.Result) {
        try {
            polarManager?.stopDeviceScan()
            result.success(null)
        } catch (e: Exception) {
            result.error("SCAN_STOP_FAILED", "Failed to stop device scan", e.message)
        }
    }

    private fun connectToDevice(deviceId: String?, result: MethodChannel.Result) {
        if (deviceId == null) {
            result.error("INVALID_DEVICE_ID", "Device ID cannot be null", null)
            return
        }
        
        try {
            polarManager?.connectToDevice(deviceId)
            result.success(null)
        } catch (e: Exception) {
            result.error("CONNECTION_FAILED", "Failed to connect to device", e.message)
        }
    }

    private fun disconnectFromDevice(result: MethodChannel.Result) {
        try {
            polarManager?.disconnectFromDevice()
            result.success(null)
        } catch (e: Exception) {
            result.error("DISCONNECTION_FAILED", "Failed to disconnect from device", e.message)
        }
    }

    private fun startHeartRateStream(result: MethodChannel.Result) {
        try {
            polarManager?.startHeartRateStream()
            result.success(null)
        } catch (e: Exception) {
            result.error("HR_STREAM_START_FAILED", "Failed to start heart rate stream", e.message)
        }
    }

    private fun stopHeartRateStream(result: MethodChannel.Result) {
        try {
            polarManager?.stopHeartRateStream()
            result.success(null)
        } catch (e: Exception) {
            result.error("HR_STREAM_STOP_FAILED", "Failed to stop heart rate stream", e.message)
        }
    }

    private fun startEcgStream(result: MethodChannel.Result) {
        try {
            polarManager?.startEcgStream()
            result.success(null)
        } catch (e: Exception) {
            result.error("ECG_STREAM_START_FAILED", "Failed to start ECG stream", e.message)
        }
    }

    private fun stopEcgStream(result: MethodChannel.Result) {
        try {
            polarManager?.stopEcgStream()
            result.success(null)
        } catch (e: Exception) {
            result.error("ECG_STREAM_STOP_FAILED", "Failed to stop ECG stream", e.message)
        }
    }

    private fun startAccelerationStream(result: MethodChannel.Result) {
        try {
            polarManager?.startAccelerationStream()
            result.success(null)
        } catch (e: Exception) {
            result.error("ACC_STREAM_START_FAILED", "Failed to start acceleration stream", e.message)
        }
    }

    private fun stopAccelerationStream(result: MethodChannel.Result) {
        try {
            polarManager?.stopAccelerationStream()
            result.success(null)
        } catch (e: Exception) {
            result.error("ACC_STREAM_STOP_FAILED", "Failed to stop acceleration stream", e.message)
        }
    }

    private fun enableMockMode(enabled: Boolean, result: MethodChannel.Result) {
        try {
            polarManager?.enableMockMode(enabled)
            result.success(null)
        } catch (e: Exception) {
            result.error("MOCK_MODE_FAILED", "Failed to enable mock mode", e.message)
        }
    }
}