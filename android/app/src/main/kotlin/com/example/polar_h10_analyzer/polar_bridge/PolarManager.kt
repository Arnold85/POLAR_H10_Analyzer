package com.example.polar_h10_analyzer.polar_bridge

import android.bluetooth.BluetoothAdapter
import android.bluetooth.BluetoothManager
import android.content.Context
import android.os.Handler
import android.os.Looper
import android.util.Log
import com.polar.sdk.api.PolarBleApi
import com.polar.sdk.api.PolarBleApiCallback
import com.polar.sdk.api.PolarBleApiDefaultImpl
import com.polar.sdk.api.errors.PolarInvalidArgument
import com.polar.sdk.api.model.PolarAccelerometerData
import com.polar.sdk.api.model.PolarDeviceInfo
import com.polar.sdk.api.model.PolarEcgData
import com.polar.sdk.api.model.PolarHrData
import io.flutter.plugin.common.EventChannel
import io.reactivex.rxjava3.android.schedulers.AndroidSchedulers
import io.reactivex.rxjava3.disposables.CompositeDisposable
import io.reactivex.rxjava3.schedulers.Schedulers
import java.util.*

class PolarManager(
    private val context: Context,
    private val activity: android.app.Activity?,
    private val connectionStatusChannel: EventChannel,
    private val heartRateChannel: EventChannel,
    private val ecgChannel: EventChannel,
    private val accelerationChannel: EventChannel,
    private val deviceDiscoveryChannel: EventChannel
) {
    companion object {
        private const val TAG = "PolarManager"
    }

    private var api: PolarBleApi? = null
    private val disposables = CompositeDisposable()
    private var connectedDeviceId: String? = null
    private var isScanning = false
    private var isMockMode = false
    
    // Event channel stream handlers
    private var connectionStatusStreamHandler: ConnectionStatusStreamHandler? = null
    private var heartRateStreamHandler: HeartRateStreamHandler? = null
    private var ecgStreamHandler: EcgStreamHandler? = null
    private var accelerationStreamHandler: AccelerationStreamHandler? = null
    private var deviceDiscoveryStreamHandler: DeviceDiscoveryStreamHandler? = null
    
    private val mainHandler = Handler(Looper.getMainLooper())

    fun initialize() {
        // Initialize Polar BLE API
        api = PolarBleApiDefaultImpl.defaultImplementation(
            context,
            setOf(
                PolarBleApi.PolarBleSdkFeature.FEATURE_POLAR_ONLINE_STREAMING,
                PolarBleApi.PolarBleSdkFeature.FEATURE_BATTERY_INFO,
                PolarBleApi.PolarBleSdkFeature.FEATURE_DEVICE_INFO
            )
        )

        // Set up event channel stream handlers
        setupEventChannels()

        // Set up API callbacks
        api?.setApiCallback(object : PolarBleApiCallback() {
            override fun blePowerStateChanged(powered: Boolean) {
                Log.d(TAG, "BLE power state changed: $powered")
                if (!powered) {
                    sendConnectionStatus("disconnected")
                }
            }

            override fun deviceConnected(polarDeviceInfo: PolarDeviceInfo) {
                Log.d(TAG, "Device connected: ${polarDeviceInfo.deviceId}")
                connectedDeviceId = polarDeviceInfo.deviceId
                sendConnectionStatus("connected")
            }

            override fun deviceConnecting(polarDeviceInfo: PolarDeviceInfo) {
                Log.d(TAG, "Device connecting: ${polarDeviceInfo.deviceId}")
                sendConnectionStatus("connecting")
            }

            override fun deviceDisconnected(polarDeviceInfo: PolarDeviceInfo) {
                Log.d(TAG, "Device disconnected: ${polarDeviceInfo.deviceId}")
                connectedDeviceId = null
                sendConnectionStatus("disconnected")
            }

            override fun streamingFeaturesReady(
                identifier: String,
                features: Set<PolarBleApi.PolarDeviceDataType>
            ) {
                Log.d(TAG, "Streaming features ready for $identifier: $features")
                sendConnectionStatus("connected")
            }

            override fun hrFeatureReady(identifier: String) {
                Log.d(TAG, "HR feature ready for $identifier")
            }

            override fun disInformationReceived(identifier: String, uuid: UUID, value: String) {
                Log.d(TAG, "Device info received for $identifier: $value")
            }

            override fun batteryLevelReceived(identifier: String, level: Int) {
                Log.d(TAG, "Battery level received for $identifier: $level%")
            }
        })

        Log.d(TAG, "Polar Manager initialized")
    }

    private fun setupEventChannels() {
        connectionStatusStreamHandler = ConnectionStatusStreamHandler()
        heartRateStreamHandler = HeartRateStreamHandler()
        ecgStreamHandler = EcgStreamHandler()
        accelerationStreamHandler = AccelerationStreamHandler()
        deviceDiscoveryStreamHandler = DeviceDiscoveryStreamHandler()

        connectionStatusChannel.setStreamHandler(connectionStatusStreamHandler)
        heartRateChannel.setStreamHandler(heartRateStreamHandler)
        ecgChannel.setStreamHandler(ecgStreamHandler)
        accelerationChannel.setStreamHandler(accelerationStreamHandler)
        deviceDiscoveryChannel.setStreamHandler(deviceDiscoveryStreamHandler)
    }

    fun isBluetoothEnabled(): Boolean {
        val bluetoothManager = context.getSystemService(Context.BLUETOOTH_SERVICE) as BluetoothManager
        val bluetoothAdapter = bluetoothManager.adapter
        return bluetoothAdapter?.isEnabled == true
    }

    fun startDeviceScan() {
        if (isMockMode) {
            startMockDeviceScan()
            return
        }

        if (isScanning) {
            Log.d(TAG, "Already scanning")
            return
        }

        if (!isBluetoothEnabled()) {
            Log.e(TAG, "Bluetooth is not enabled")
            return
        }

        api?.let { polarApi ->
            sendConnectionStatus("scanning")
            isScanning = true

            val scanDisposable = polarApi.searchForDevice()
                .observeOn(AndroidSchedulers.mainThread())
                .subscribe(
                    { polarDeviceInfo ->
                        Log.d(TAG, "Device found: ${polarDeviceInfo.deviceId}")
                        deviceDiscoveryStreamHandler?.sendDevice(
                            mapOf(
                                "deviceId" to polarDeviceInfo.deviceId,
                                "name" to polarDeviceInfo.name,
                                "address" to polarDeviceInfo.address,
                                "rssi" to polarDeviceInfo.rssi,
                                "isConnectable" to polarDeviceInfo.isConnectable
                            )
                        )
                    },
                    { error ->
                        Log.e(TAG, "Device scan error", error)
                        isScanning = false
                    }
                )

            disposables.add(scanDisposable)
        }
    }

    fun stopDeviceScan() {
        if (isMockMode) {
            return
        }

        isScanning = false
        sendConnectionStatus("disconnected")
        Log.d(TAG, "Device scan stopped")
    }

    fun connectToDevice(deviceId: String) {
        if (isMockMode) {
            startMockConnection(deviceId)
            return
        }

        api?.let { polarApi ->
            try {
                sendConnectionStatus("connecting")
                polarApi.connectToDevice(deviceId)
                Log.d(TAG, "Connecting to device: $deviceId")
            } catch (polarInvalidArgument: PolarInvalidArgument) {
                Log.e(TAG, "Invalid device ID: $deviceId", polarInvalidArgument)
                sendConnectionStatus("error")
            }
        }
    }

    fun disconnectFromDevice() {
        connectedDeviceId?.let { deviceId ->
            api?.disconnectFromDevice(deviceId)
            Log.d(TAG, "Disconnecting from device: $deviceId")
        }
        connectedDeviceId = null
        sendConnectionStatus("disconnected")
    }

    fun startHeartRateStream() {
        if (isMockMode) {
            startMockHeartRateStream()
            return
        }

        connectedDeviceId?.let { deviceId ->
            api?.let { polarApi ->
                val hrDisposable = polarApi.startHrStreaming(deviceId)
                    .observeOn(AndroidSchedulers.mainThread())
                    .subscribe(
                        { hrData: PolarHrData ->
                            sendConnectionStatus("streaming")
                            val sampleData = mapOf(
                                "timestamp" to System.currentTimeMillis(),
                                "heartRate" to hrData.hr,
                                "rrIntervals" to hrData.rrs.map { it.toInt() },
                                "contactStatus" to hrData.contactStatus,
                                "contactSupported" to hrData.contactStatusSupported
                            )
                            heartRateStreamHandler?.sendSample(sampleData)
                        },
                        { error ->
                            Log.e(TAG, "HR stream error", error)
                        }
                    )
                disposables.add(hrDisposable)
                Log.d(TAG, "HR stream started for device: $deviceId")
            }
        }
    }

    fun stopHeartRateStream() {
        // Disposables will be cleared when stopping
        Log.d(TAG, "HR stream stopped")
    }

    fun startEcgStream() {
        if (isMockMode) {
            startMockEcgStream()
            return
        }

        connectedDeviceId?.let { deviceId ->
            api?.let { polarApi ->
                val ecgDisposable = polarApi.startEcgStreaming(deviceId)
                    .observeOn(AndroidSchedulers.mainThread())
                    .subscribe(
                        { ecgData: PolarEcgData ->
                            sendConnectionStatus("streaming")
                            val sampleData = mapOf(
                                "timestamp" to System.currentTimeMillis(),
                                "samples" to ecgData.samples.map { it.voltage },
                                "samplingRate" to ecgData.samples.firstOrNull()?.timeStamp ?: 130
                            )
                            ecgStreamHandler?.sendSample(sampleData)
                        },
                        { error ->
                            Log.e(TAG, "ECG stream error", error)
                        }
                    )
                disposables.add(ecgDisposable)
                Log.d(TAG, "ECG stream started for device: $deviceId")
            }
        }
    }

    fun stopEcgStream() {
        Log.d(TAG, "ECG stream stopped")
    }

    fun startAccelerationStream() {
        if (isMockMode) {
            startMockAccelerationStream()
            return
        }

        connectedDeviceId?.let { deviceId ->
            api?.let { polarApi ->
                val accDisposable = polarApi.startAccStreaming(deviceId)
                    .observeOn(AndroidSchedulers.mainThread())
                    .subscribe(
                        { accData: PolarAccelerometerData ->
                            sendConnectionStatus("streaming")
                            accData.samples.forEach { sample ->
                                val sampleData = mapOf(
                                    "timestamp" to System.currentTimeMillis(),
                                    "x" to sample.x,
                                    "y" to sample.y,
                                    "z" to sample.z
                                )
                                accelerationStreamHandler?.sendSample(sampleData)
                            }
                        },
                        { error ->
                            Log.e(TAG, "Acceleration stream error", error)
                        }
                    )
                disposables.add(accDisposable)
                Log.d(TAG, "Acceleration stream started for device: $deviceId")
            }
        }
    }

    fun stopAccelerationStream() {
        Log.d(TAG, "Acceleration stream stopped")
    }

    fun enableMockMode(enabled: Boolean) {
        isMockMode = enabled
        Log.d(TAG, "Mock mode ${if (enabled) "enabled" else "disabled"}")
        
        if (enabled) {
            sendConnectionStatus("disconnected")
        }
    }

    private fun sendConnectionStatus(status: String) {
        mainHandler.post {
            connectionStatusStreamHandler?.sendStatus(status)
        }
    }

    private fun startMockDeviceScan() {
        sendConnectionStatus("scanning")
        
        // Simulate finding devices after a delay
        mainHandler.postDelayed({
            val mockDevices = listOf(
                mapOf(
                    "deviceId" to "12345678",
                    "name" to "Polar H10 12345678",
                    "address" to "AA:BB:CC:DD:EE:FF",
                    "rssi" to -60,
                    "isConnectable" to true
                ),
                mapOf(
                    "deviceId" to "87654321",
                    "name" to "Polar H10 87654321",
                    "address" to "FF:EE:DD:CC:BB:AA",
                    "rssi" to -70,
                    "isConnectable" to true
                )
            )
            
            mockDevices.forEach { device ->
                deviceDiscoveryStreamHandler?.sendDevice(device)
            }
        }, 2000)
    }

    private fun startMockConnection(deviceId: String) {
        sendConnectionStatus("connecting")
        
        mainHandler.postDelayed({
            connectedDeviceId = deviceId
            sendConnectionStatus("connected")
        }, 1500)
    }

    private fun startMockHeartRateStream() {
        sendConnectionStatus("streaming")
        
        val mockTimer = Timer()
        mockTimer.scheduleAtFixedRate(object : TimerTask() {
            override fun run() {
                val mockData = mapOf(
                    "timestamp" to System.currentTimeMillis(),
                    "heartRate" to (60..100).random(),
                    "rrIntervals" to listOf(800, 820, 790, 810),
                    "contactStatus" to true,
                    "contactSupported" to true
                )
                
                mainHandler.post {
                    heartRateStreamHandler?.sendSample(mockData)
                }
            }
        }, 1000, 1000) // Send every second
    }

    private fun startMockEcgStream() {
        sendConnectionStatus("streaming")
        
        val mockTimer = Timer()
        mockTimer.scheduleAtFixedRate(object : TimerTask() {
            override fun run() {
                val samples = (1..130).map { (-500..500).random() } // 130 samples for 130Hz
                val mockData = mapOf(
                    "timestamp" to System.currentTimeMillis(),
                    "samples" to samples,
                    "samplingRate" to 130
                )
                
                mainHandler.post {
                    ecgStreamHandler?.sendSample(mockData)
                }
            }
        }, 1000, 1000) // Send every second
    }

    private fun startMockAccelerationStream() {
        sendConnectionStatus("streaming")
        
        val mockTimer = Timer()
        mockTimer.scheduleAtFixedRate(object : TimerTask() {
            override fun run() {
                val mockData = mapOf(
                    "timestamp" to System.currentTimeMillis(),
                    "x" to (-1000..1000).random(),
                    "y" to (-1000..1000).random(),
                    "z" to (-1000..1000).random()
                )
                
                mainHandler.post {
                    accelerationStreamHandler?.sendSample(mockData)
                }
            }
        }, 100, 100) // Send every 100ms
    }

    fun cleanup() {
        disposables.clear()
        api?.shutDown()
        Log.d(TAG, "Polar Manager cleaned up")
    }

    // Stream handlers for event channels
    private inner class ConnectionStatusStreamHandler : EventChannel.StreamHandler {
        private var eventSink: EventChannel.EventSink? = null

        override fun onListen(arguments: Any?, events: EventChannel.EventSink?) {
            eventSink = events
        }

        override fun onCancel(arguments: Any?) {
            eventSink = null
        }

        fun sendStatus(status: String) {
            eventSink?.success(status)
        }
    }

    private inner class HeartRateStreamHandler : EventChannel.StreamHandler {
        private var eventSink: EventChannel.EventSink? = null

        override fun onListen(arguments: Any?, events: EventChannel.EventSink?) {
            eventSink = events
        }

        override fun onCancel(arguments: Any?) {
            eventSink = null
        }

        fun sendSample(sampleData: Map<String, Any>) {
            eventSink?.success(sampleData)
        }
    }

    private inner class EcgStreamHandler : EventChannel.StreamHandler {
        private var eventSink: EventChannel.EventSink? = null

        override fun onListen(arguments: Any?, events: EventChannel.EventSink?) {
            eventSink = events
        }

        override fun onCancel(arguments: Any?) {
            eventSink = null
        }

        fun sendSample(sampleData: Map<String, Any>) {
            eventSink?.success(sampleData)
        }
    }

    private inner class AccelerationStreamHandler : EventChannel.StreamHandler {
        private var eventSink: EventChannel.EventSink? = null

        override fun onListen(arguments: Any?, events: EventChannel.EventSink?) {
            eventSink = events
        }

        override fun onCancel(arguments: Any?) {
            eventSink = null
        }

        fun sendSample(sampleData: Map<String, Any>) {
            eventSink?.success(sampleData)
        }
    }

    private inner class DeviceDiscoveryStreamHandler : EventChannel.StreamHandler {
        private var eventSink: EventChannel.EventSink? = null

        override fun onListen(arguments: Any?, events: EventChannel.EventSink?) {
            eventSink = events
        }

        override fun onCancel(arguments: Any?) {
            eventSink = null
        }

        fun sendDevice(deviceData: Map<String, Any>) {
            eventSink?.success(deviceData)
        }
    }
}