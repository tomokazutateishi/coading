package com.adjustablecompass.app.data

import android.content.Context
import android.content.SharedPreferences

object CompassPrefs {
    const val PREF_NAME = "compass_prefs"
    const val KEY_OFFSET_ANGLE = "offset_angle"
    const val KEY_IS_LOCKED = "is_locked"
}

class SettingsRepository(private val context: Context) {
    private val prefs: SharedPreferences = 
        context.getSharedPreferences(CompassPrefs.PREF_NAME, Context.MODE_PRIVATE)

    fun saveOffset(angle: Float) {
        prefs.edit().putFloat(CompassPrefs.KEY_OFFSET_ANGLE, angle).apply()
    }

    fun loadOffset(): Float {
        return prefs.getFloat(CompassPrefs.KEY_OFFSET_ANGLE, 0f)
    }

    fun saveLockState(isLocked: Boolean) {
        prefs.edit().putBoolean(CompassPrefs.KEY_IS_LOCKED, isLocked).apply()
    }

    fun loadLockState(): Boolean {
        return prefs.getBoolean(CompassPrefs.KEY_IS_LOCKED, false)
    }
}


