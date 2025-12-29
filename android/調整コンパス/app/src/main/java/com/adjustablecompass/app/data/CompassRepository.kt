package com.adjustablecompass.app.data

import android.hardware.Sensor
import android.hardware.SensorEvent
import android.hardware.SensorEventListener
import android.hardware.SensorManager
import kotlinx.coroutines.channels.awaitClose
import kotlinx.coroutines.flow.Flow
import kotlinx.coroutines.flow.callbackFlow
import kotlin.math.toDegrees

class CompassRepository(private val sensorManager: SensorManager) {
    
    private val accelerometerSensor: Sensor? = 
        sensorManager.getDefaultSensor(Sensor.TYPE_ACCELEROMETER)
    private val magneticSensor: Sensor? = 
        sensorManager.getDefaultSensor(Sensor.TYPE_MAGNETIC_FIELD)
    
    private var accelerometerData: FloatArray? = null
    private var magneticData: FloatArray? = null
    
    private val rotationMatrix = FloatArray(9)
    private val orientationAngles = FloatArray(3)

    fun isSensorAvailable(): Boolean {
        return accelerometerSensor != null && magneticSensor != null
    }

    fun getAzimuth(): Flow<Float> = callbackFlow {
        val sensorEventListener = object : SensorEventListener {
            override fun onSensorChanged(event: SensorEvent?) {
                if (event == null) return
                
                when (event.sensor.type) {
                    Sensor.TYPE_ACCELEROMETER -> {
                        accelerometerData = event.values.clone()
                    }
                    Sensor.TYPE_MAGNETIC_FIELD -> {
                        magneticData = event.values.clone()
                        calculateAndEmitAzimuth()
                    }
                }
            }

            override fun onAccuracyChanged(sensor: Sensor?, accuracy: Int) {
                // 必要に応じて実装
            }

            private fun calculateAndEmitAzimuth() {
                val accel = accelerometerData ?: return
                val mag = magneticData ?: return
                
                val success = SensorManager.getRotationMatrix(
                    rotationMatrix, null, accel, mag
                )
                
                if (success) {
                    SensorManager.getOrientation(rotationMatrix, orientationAngles)
                    val azimuth = toDegrees(orientationAngles[0].toDouble()).toFloat()
                    val normalizedAzimuth = if (azimuth < 0) azimuth + 360 else azimuth
                    trySend(normalizedAzimuth)
                }
            }
        }

        accelerometerSensor?.let {
            sensorManager.registerListener(
                sensorEventListener,
                it,
                SensorManager.SENSOR_DELAY_UI
            )
        }
        
        magneticSensor?.let {
            sensorManager.registerListener(
                sensorEventListener,
                it,
                SensorManager.SENSOR_DELAY_UI
            )
        }

        awaitClose {
            sensorManager.unregisterListener(sensorEventListener)
        }
    }
}


