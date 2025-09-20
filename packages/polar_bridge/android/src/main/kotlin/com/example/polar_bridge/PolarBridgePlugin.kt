package com.example.polar_bridge

import android.app.Activity
import android.util.Log
import android.content.Context
import androidx.annotation.NonNull
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import com.polar.sdk.api.PolarBleApi
import com.polar.sdk.api.PolarBleApiCallback
import com.polar.sdk.api.PolarBleApiDefaultImpl
import com.polar.sdk.api.model.PolarDeviceInfo
import com.polar.sdk.api.PolarBleApi.PolarBleSdkFeature
import com.polar.sdk.api.PolarBleApi.PolarDeviceDataType
import com.polar.sdk.api.model.PolarSensorSetting
import com.polar.sdk.api.model.PolarEcgData
import com.polar.sdk.api.model.PolarHrData
import io.reactivex.rxjava3.disposables.CompositeDisposable
import io.reactivex.rxjava3.kotlin.addTo
import io.reactivex.rxjava3.core.Flowable
import java.util.*
import io.reactivex.rxjava3.schedulers.Schedulers
import io.reactivex.rxjava3.android.schedulers.AndroidSchedulers
import java.nio.ByteBuffer
import java.nio.ByteOrder

/** PolarBridgePlugin */
class PolarBridgePlugin: FlutterPlugin, MethodCallHandler, EventChannel.StreamHandler, ActivityAware {
  private val TAG = "PolarBridgePlugin"
  private lateinit var context: Context
  private var activity: Activity? = null
  private lateinit var methodChannel : MethodChannel
  private lateinit var eventChannel: EventChannel
  private var api: PolarBleApi? = null
  private val eventsQueue: MutableList<Map<String, Any>> = mutableListOf()
  private var eventSink: EventChannel.EventSink? = null
  private val disposables = CompositeDisposable()
  private val startedEcgStreams: MutableSet<String> = mutableSetOf()

  override fun onAttachedToEngine(@NonNull flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
    context = flutterPluginBinding.applicationContext
    methodChannel = MethodChannel(flutterPluginBinding.binaryMessenger, "polar_bridge/methods")
    methodChannel.setMethodCallHandler(this)
    eventChannel = EventChannel(flutterPluginBinding.binaryMessenger, "polar_bridge/events")
    eventChannel.setStreamHandler(this)
  }

  override fun onMethodCall(@NonNull call: MethodCall, @NonNull result: Result) {
    when (call.method) {
      "isBluetoothEnabled" -> {
        try {
          val adapterClass = Class.forName("android.bluetooth.BluetoothAdapter")
          val method = adapterClass.getDeclaredMethod("getDefaultAdapter")
          val adapter = method.invoke(null)
          if (adapter == null) {
            result.success(false)
          } else {
            val isEnabledMethod = adapter.javaClass.getMethod("isEnabled")
            val enabled = isEnabledMethod.invoke(adapter) as Boolean
            result.success(enabled)
          }
        } catch (e: Exception) {
          result.success(false)
        }
      }
      "initialize" -> {
        val enableEcg = call.argument<Boolean>("ecg") ?: true
        val enableHr = call.argument<Boolean>("hr") ?: true
        val features = mutableSetOf<PolarBleSdkFeature>()
        if (enableHr) features.add(PolarBleSdkFeature.FEATURE_HR)
        if (enableEcg) features.add(PolarBleSdkFeature.FEATURE_POLAR_ONLINE_STREAMING)
        features.add(PolarBleSdkFeature.FEATURE_BATTERY_INFO)
        features.add(PolarBleSdkFeature.FEATURE_DEVICE_INFO)
        features.add(PolarBleSdkFeature.FEATURE_POLAR_FILE_TRANSFER)
        api = PolarBleApiDefaultImpl.defaultImplementation(context, features)
        // Use a dynamic Proxy implementing PolarBleApiCallbackProvider to avoid compile-time
        // signature mismatches across SDK versions. Handle callbacks by method name at runtime.
        try {
          val handler = java.lang.reflect.InvocationHandler { _, method, args ->
            try {
              when (method.name) {
                "blePowerStateChanged" -> {
                  val powered = args?.getOrNull(0) as? Boolean ?: false
                  Log.d(TAG, "blePowerStateChanged powered=$powered")
                  emit(mapOf("type" to "blePower", "powered" to powered))
                }
                "deviceConnecting" -> {
                  val dev = args?.getOrNull(0) as? PolarDeviceInfo
                  if (dev != null) {
                    Log.d(TAG, "deviceConnecting ${dev.deviceId}")
                    emit(mapOf("type" to "connection", "deviceId" to dev.deviceId, "state" to "connecting", "name" to (dev.name ?: "")))
                  }
                }
                "deviceConnected" -> {
                  val dev = args?.getOrNull(0) as? PolarDeviceInfo
                  if (dev != null) {
                    Log.d(TAG, "deviceConnected ${dev.deviceId}")
                    emit(mapOf("type" to "connection", "deviceId" to dev.deviceId, "state" to "connected", "name" to (dev.name ?: "")))
                  }
                }
                "deviceDisconnected" -> {
                  val dev = args?.getOrNull(0) as? PolarDeviceInfo
                  if (dev != null) {
                    Log.d(TAG, "deviceDisconnected ${dev.deviceId}")
                    emit(mapOf("type" to "connection", "deviceId" to dev.deviceId, "state" to "disconnected", "name" to (dev.name ?: "")))
                  }
                }
                "bleSdkFeatureReady" -> {
                  val id = args?.getOrNull(0) as? String
                  val feature = args?.getOrNull(1)
                  Log.d(TAG, "bleSdkFeatureReady $id feature=$feature")
                  emit(mapOf("type" to "feature", "deviceId" to (id ?: ""), "feature" to (feature?.toString() ?: "")))
                  // If HR feature is ready, try to enable HR notifications
                  try {
                    if (feature?.toString()?.contains("HR", ignoreCase = true) == true) {
                      try {
                        val apiRef = api
                        if (apiRef != null && id != null) {
                          // Use startHrStreaming(identifier) signature available in SDK
                          apiRef.startHrStreaming(id)
                            .subscribeOn(Schedulers.io())
                            .observeOn(AndroidSchedulers.mainThread())
                            .subscribe({ /* hr streaming handled by callback proxy */ }, { err -> emit(mapOf("type" to "error", "code" to "hr_start", "message" to (err.message ?: "hr start error"))) }).addTo(disposables)
                        }
                      } catch (e: Exception) {
                        Log.e(TAG, "hr stream request failed: ${e.message}")
                      }
                    }
                    // Auto-start ECG streaming when online streaming feature reported
                    if (feature?.toString()?.contains("POLAR_ONLINE_STREAMING", ignoreCase = true) == true || feature?.toString()?.contains("ECG", ignoreCase = true) == true) {
                      try {
                        if (id != null && !startedEcgStreams.contains(id)) {
                          startedEcgStreams.add(id)
                          // startEcgStreaming handles subscriptions and emits ecg events
                          startEcgStreaming(id)
                        }
                      } catch (e: Exception) {
                        Log.e(TAG, "ecg start failed: ${e.message}")
                      }
                    }
                  } catch (_: Throwable) { }
                }
                "disInformationReceived" -> {
                  val id = args?.getOrNull(0) as? String
                  val uuid = args?.getOrNull(1)
                  val value = args?.getOrNull(2) as? String
                  Log.d(TAG, "disInformationReceived $id $uuid")
                  emit(mapOf("type" to "dis", "deviceId" to (id ?: ""), "uuid" to (uuid?.toString() ?: ""), "value" to (value ?: "")))
                }
                "streamingFeaturesReady" -> {
                  // Some SDK versions call streamingFeaturesReady(identifier, streamingFeatures:Set)
                  val id = args?.getOrNull(0) as? String
                  val featuresObj = args?.getOrNull(1)
                  val featuresList = mutableListOf<String>()
                  if (featuresObj is Collection<*>) {
                    for (f in featuresObj) { featuresList.add(f?.toString() ?: "") }
                  } else if (featuresObj != null) {
                    featuresList.add(featuresObj.toString())
                  }
                  emit(mapOf("type" to "streamingFeatures", "deviceId" to (id ?: ""), "streamingFeatures" to featuresList))
                }
                "batteryLevelReceived" -> {
                  val id = args?.getOrNull(0) as? String
                  val level = (args?.getOrNull(1) as? Number)?.toInt() ?: -1
                  Log.d(TAG, "batteryLevelReceived $id level=$level")
                  emit(mapOf("type" to "battery", "deviceId" to (id ?: ""), "level" to level))
                }
                "batteryChargingStatusReceived" -> {
                  val id = args?.getOrNull(0) as? String
                  val status = args?.getOrNull(1)
                  Log.d(TAG, "batteryChargingStatusReceived $id status=$status")
                  emit(mapOf("type" to "batteryCharging", "deviceId" to (id ?: ""), "status" to (status?.toString() ?: "")))
                }
                "hrNotificationReceived" -> {
                  val id = args?.getOrNull(0) as? String
                  val sample = args?.getOrNull(1)
                  try {
                    val hrField = sample?.javaClass?.getDeclaredField("hr")
                    hrField?.isAccessible = true
                    val hr = hrField?.get(sample) as? Number
                    val rrsField = sample?.javaClass?.getDeclaredField("rrsMs")
                    rrsField?.isAccessible = true
                    val rrs = rrsField?.get(sample) as? List<*>
                    emit(mapOf("type" to "hr", "deviceId" to (id ?: ""), "hr" to (hr?.toInt() ?: -1), "rrs" to (rrs ?: emptyList<Int>()), "ts" to System.currentTimeMillis()))
                  } catch (e: Exception) {
                    Log.e(TAG, "hrNotificationReceived parse error: ${e.message}")
                  }
                }
                else -> {
                  // Unhandled callback - log and emit for debugging so Flutter can inspect unknown callbacks at runtime
                  Log.d(TAG, "unhandled callback: ${method.name} args=${args?.contentToString()}")
                  try {
                    val argsList = args?.map { it?.toString() } ?: emptyList<String>()
                    emit(mapOf("type" to "unhandledCallback", "method" to method.name, "args" to argsList))
                  } catch (_: Throwable) { }
                }
              }
            } catch (e: Exception) {
              Log.e(TAG, "callback handler error: ${e.message}", e)
            }
            null
          }

          val proxy = java.lang.reflect.Proxy.newProxyInstance(
            PolarBleApiCallback::class.java.classLoader,
            arrayOf(com.polar.sdk.api.PolarBleApiCallbackProvider::class.java),
            handler
          ) as com.polar.sdk.api.PolarBleApiCallbackProvider

          api?.setApiCallback(proxy)
        } catch (e: Exception) {
          Log.e(TAG, "failed to set proxy api callback: ${e.message}")
        }
        result.success(null)
      }
      "connect" -> {
        val deviceId = call.argument<String>("deviceId") ?: ""
        if (deviceId.isNotEmpty()) {
          // notify Dart that we're attempting to connect
          emit(mapOf("type" to "connection", "deviceId" to deviceId, "state" to "connecting"))
          api?.connectToDevice(deviceId)
        }
        result.success(null)
      }
      "disconnect" -> {
        api?.disconnectFromDevice(call.argument<String>("deviceId")!!)
        result.success(null)
      }
      "startScan" -> {
        // Start scanning using searchForDevice which returns an Observable of PolarDeviceInfo
        try {
          api?.searchForDevice()?.subscribe({ deviceInfo ->
            val scan = mapOf(
              "type" to "scanResult",
              "deviceId" to deviceInfo.deviceId,
              "name" to (deviceInfo.name ?: ""),
              "rssi" to (deviceInfo.rssi ?: 0)
            )
            emit(scan)
          }, { err -> emit(mapOf("type" to "error", "code" to "scan", "message" to (err.message ?: ""))) })?.addTo(disposables)
        } catch (e: Throwable) {
          // fall back to auto connect
          api?.autoConnectToDevice(-55, null, null)?.subscribe({}, { err -> emit(mapOf("type" to "error", "code" to "autoConnect", "message" to (err.message ?: ""))) })?.addTo(disposables)
        }
        result.success(null)
      }
      "stopScan" -> { /* no direct stop for autoConnect; would require disposing */ result.success(null) }
      "startEcg" -> {
        val deviceId = call.argument<String>("deviceId") ?: ""
        if (deviceId.isNotEmpty()) startEcgStreaming(deviceId)
        result.success(null)
      }
      "stopEcg" -> {
        val deviceId = call.argument<String>("deviceId") ?: ""
        if (deviceId.isNotEmpty()) stopStreaming(deviceId)
        result.success(null)
      }
      else -> result.notImplemented()
    }
  }

  // Helper functions moved outside of the when-block to keep Kotlin syntax valid
  private fun startEcgStreaming(deviceId: String) {
    val apiRef = api ?: return
    apiRef.requestStreamSettings(deviceId, PolarDeviceDataType.ECG)
      .flatMapPublisher { available: PolarSensorSetting ->
        // Try to extract a numeric sampling rate from the available settings using reflection
        val samplingRate = try {
          getIntField(available, "samplingRate") ?: getIntField(available, "sampleRate") ?: getIntField(available, "sampling_rate")
        } catch (_: Throwable) { null }

        // Emit a streamSettings event with the sensor setting description and parsed samplingRate
        try {
          val settingsMap: MutableMap<String, Any> = mutableMapOf("raw" to (available?.toString() ?: ""))
          if (samplingRate != null) settingsMap["samplingRate"] = samplingRate
          emit(mapOf("type" to "streamSettings", "deviceId" to deviceId, "settings" to settingsMap))
        } catch (_: Throwable) { }

        // Start streaming and carry samplingRate alongside each emitted PolarEcgData using map
        apiRef.startEcgStreaming(deviceId, available).map { ecg -> Pair(samplingRate, ecg) }
      }
      .subscribeOn(Schedulers.io())
      .observeOn(AndroidSchedulers.mainThread())
      .subscribe({ pair: Pair<Int?, PolarEcgData> ->
        val samplingRate = pair.first
        val ecg = pair.second
        try {
          // Try to extract a start timestamp from the ecg packet (if present)
          val startTs = getLongField(ecg, "timeStamp") ?: getLongField(ecg, "timestamp") ?: getLongField(ecg, "startTimeStamp") ?: getLongField(ecg, "start")

          val samples = ecg.samples.mapIndexed { idx, s ->
            val voltage = try {
              val c = s.javaClass
              val field = c.declaredFields.firstOrNull { f ->
                f.name.contains("micro", ignoreCase = true) || f.name.contains("volt", ignoreCase = true)
              }
              field?.apply { isAccessible = true }?.get(s)
            } catch (_: Throwable) { null }

            var ts = getLongField(s, "timeStamp") ?: getLongField(s, "timestamp")
            if (ts == null && startTs != null && samplingRate != null && samplingRate > 0) {
              // Reconstruct per-sample timestamp (startTs assumed to be in millis). Interval = 1000 / samplingRate ms.
              try {
                val intervalMs = 1000.0 / samplingRate.toDouble()
                ts = (startTs + (idx * intervalMs)).toLong()
              } catch (_: Throwable) { ts = null }
            }

            mapOf(
              "timeStamp" to (ts ?: startTs ?: System.currentTimeMillis()),
              "voltage" to voltage
            )
          }

          emit(mapOf("type" to "ecg", "deviceId" to deviceId, "samples" to samples, "ts" to System.currentTimeMillis(), "samplingRate" to (samplingRate ?: -1), "startTimeStamp" to (startTs ?: -1)))
        } catch (e: Exception) {
          Log.e(TAG, "ecg parse error: ${e.message}")
          emit(mapOf("type" to "error", "code" to "ecg_parse", "message" to (e.message ?: "")))
        }
      }, { err ->
        emit(mapOf("type" to "error", "code" to "ecg_stream", "message" to (err.message ?: "")))
      }).addTo(disposables)
  }

  private fun stopStreaming(deviceId: String) {
    val a = api ?: return
    try {
      val m = a.javaClass.methods.firstOrNull { it.name == "stopEcgStreaming" }
      if (m != null) {
        m.invoke(a, deviceId)
      } else {
        val stopWithType = a.javaClass.methods.firstOrNull { it.name == "stopStreaming" && it.parameterTypes.size == 2 }
        val typeEnum = a.javaClass.classes.firstOrNull { it.simpleName == "PolarDeviceDataType" }?.enumConstants?.firstOrNull { it.toString().contains("ECG") }
        if (stopWithType != null && typeEnum != null) {
          stopWithType.invoke(a, deviceId, typeEnum)
        }
      }
    } catch (e: Exception) {
      Log.e(TAG, "stopStreaming failed: ${e.message}")
      try { emit(mapOf("type" to "error", "code" to "stop_stream", "message" to (e.message ?: ""))) } catch (_: Throwable) {}
    }
  }

  private fun getLongField(obj: Any?, name: String): Long? {
    if (obj == null) return null
    return try {
      val f = obj.javaClass.getDeclaredField(name)
      f.isAccessible = true
      val v = f.get(obj)
      when (v) {
        is Long -> v
        is Number -> v.toLong()
        else -> null
      }
    } catch (e: Exception) {
      null
    }
  }

  private fun getIntField(obj: Any?, name: String): Int? {
    if (obj == null) return null
    return try {
      val f = obj.javaClass.getDeclaredField(name)
      f.isAccessible = true
      val v = f.get(obj)
      when (v) {
        is Int -> v
        is Number -> v.toInt()
        else -> null
      }
    } catch (e: Exception) {
      null
    }
  }

  private fun getByteArrayField(obj: Any?, name: String): ByteArray? {
    if (obj == null) return null
    return try {
      val f = obj.javaClass.getDeclaredField(name)
      f.isAccessible = true
      val v = f.get(obj)
      when (v) {
        is ByteArray -> v
        else -> null
      }
    } catch (e: Exception) {
      null
    }
  }

  private fun emit(event: Map<String, Any>) {
    // Ensure only JSON-serializable contents are sent to Flutter
    val safeEvent = event.mapValues { entry ->
      try {
        when (val v = entry.value) {
          is Number, is String, is Boolean, is List<*>, is Map<*, *> -> v
          else -> v?.toString() ?: ""
        }
      } catch (_: Throwable) {
        entry.value?.toString() ?: ""
      }
    }

    // Always post to main thread because EventChannel.EventSink must be used from UI thread
    val deliver = {
      if (eventSink == null) {
        Log.d(TAG, "queueing event: $safeEvent")
        eventsQueue.add(safeEvent)
      } else {
        try {
          Log.d(TAG, "sending event to sink: $safeEvent")
          eventSink?.success(safeEvent)
        } catch (e: Exception) {
          Log.e(TAG, "failed to emit event to sink: ${e.message}")
          try { eventSink?.success(mapOf("type" to "error", "message" to "event_emit_failed", "cause" to (e.message ?: ""))) } catch (_: Throwable) { }
        }
      }
    }

    try {
      val act = activity
      if (act != null) {
        act.runOnUiThread { deliver() }
      } else {
        android.os.Handler(android.os.Looper.getMainLooper()).post { deliver() }
      }
    } catch (e: Exception) {
      Log.e(TAG, "emit post failed: ${e.message}")
      // fallback direct
      try { deliver() } catch (_: Throwable) { /* ignore */ }
    }
  }

  override fun onListen(arguments: Any?, events: EventChannel.EventSink?) {
    eventSink = events
    eventsQueue.forEach { events?.success(it) }
    eventsQueue.clear()
  }

  override fun onCancel(arguments: Any?) { eventSink = null }

  override fun onDetachedFromEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
    methodChannel.setMethodCallHandler(null)
    eventChannel.setStreamHandler(null)
    disposables.clear()
    api?.shutDown()
  }

  override fun onAttachedToActivity(binding: ActivityPluginBinding) { activity = binding.activity }
  override fun onDetachedFromActivityForConfigChanges() { activity = null }
  override fun onReattachedToActivityForConfigChanges(binding: ActivityPluginBinding) { activity = binding.activity }
  override fun onDetachedFromActivity() { activity = null }
}
