package com.adjustablecompass.app.ui

import androidx.lifecycle.LiveData
import androidx.lifecycle.MutableLiveData
import androidx.lifecycle.ViewModel
import androidx.lifecycle.viewModelScope
import com.adjustablecompass.app.data.CompassRepository
import com.adjustablecompass.app.data.SettingsRepository
import kotlinx.coroutines.flow.catch
import kotlinx.coroutines.flow.launchIn
import kotlinx.coroutines.flow.onEach

class CompassViewModel(
    private val compassRepository: CompassRepository,
    private val settingsRepository: SettingsRepository
) : ViewModel() {

    private val _azimuth = MutableLiveData<Float>(0f)
    val azimuth: LiveData<Float> = _azimuth

    private val _offsetAngle = MutableLiveData<Float>()
    val offsetAngle: LiveData<Float> = _offsetAngle

    private val _isAdjustmentMode = MutableLiveData<Boolean>(false)
    val isAdjustmentMode: LiveData<Boolean> = _isAdjustmentMode

    private val _isLocked = MutableLiveData<Boolean>(false)
    val isLocked: LiveData<Boolean> = _isLocked

    private val _adjustedAzimuth = MutableLiveData<Float>(0f)
    val adjustedAzimuth: LiveData<Float> = _adjustedAzimuth

    private var baseAzimuth: Float = 0f
    private var adjustmentStartAzimuth: Float = 0f

    init {
        loadSettings()
    }

    fun startCompass() {
        if (!compassRepository.isSensorAvailable()) {
            return
        }

        compassRepository.getAzimuth()
            .onEach { rawAzimuth ->
                _azimuth.value = rawAzimuth
                updateAdjustedAzimuth()
            }
            .catch { e ->
                // エラーハンドリング
            }
            .launchIn(viewModelScope)
    }

    fun enterAdjustmentMode() {
        if (_isLocked.value == true) return
        
        _isAdjustmentMode.value = true
        adjustmentStartAzimuth = _azimuth.value ?: 0f
        baseAzimuth = _offsetAngle.value ?: 0f
    }

    fun exitAdjustmentMode() {
        _isAdjustmentMode.value = false
    }

    fun updateOffsetFromRotation(currentAzimuth: Float) {
        if (_isAdjustmentMode.value != true) return
        
        // 調整モード中: 現在の方位と開始時の方位の差を計算
        // ユーザーがデバイスを回転させて正しい北を設定する
        val delta = currentAzimuth - adjustmentStartAzimuth
        // 差分を-180から180度の範囲に正規化
        val normalizedDelta = when {
            delta > 180 -> delta - 360
            delta < -180 -> delta + 360
            else -> delta
        }
        val newOffset = (baseAzimuth + normalizedDelta) % 360
        _offsetAngle.value = if (newOffset < 0) newOffset + 360 else newOffset
        updateAdjustedAzimuth()
    }

    fun lockOffset() {
        _offsetAngle.value?.let { offset ->
            settingsRepository.saveOffset(offset)
            settingsRepository.saveLockState(true)
            _isLocked.value = true
            _isAdjustmentMode.value = false
        }
    }

    fun unlockOffset() {
        settingsRepository.saveLockState(false)
        _isLocked.value = false
    }

    fun resetOffset() {
        if (_isLocked.value == true) return
        
        _offsetAngle.value = 0f
        settingsRepository.saveOffset(0f)
        updateAdjustedAzimuth()
    }

    private fun updateAdjustedAzimuth() {
        val raw = _azimuth.value ?: 0f
        val offset = _offsetAngle.value ?: 0f
        val adjusted = (raw - offset) % 360
        _adjustedAzimuth.value = if (adjusted < 0) adjusted + 360 else adjusted
    }

    private fun loadSettings() {
        _offsetAngle.value = settingsRepository.loadOffset()
        _isLocked.value = settingsRepository.loadLockState()
    }
}

