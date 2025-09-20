package com.example.polar_h10_analyzer

import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import com.example.polar_h10_analyzer.polar_bridge.PolarBridgePlugin

class MainActivity : FlutterActivity() {
    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        
        // Register the Polar Bridge plugin
        flutterEngine.plugins.add(PolarBridgePlugin())
    }
}
