package com.adjustablecompass.app

import android.content.DialogInterface
import android.hardware.SensorManager
import android.os.Bundle
import android.view.View
import android.view.animation.AccelerateDecelerateInterpolator
import android.widget.Toast
import androidx.appcompat.app.AlertDialog
import androidx.appcompat.app.AppCompatActivity
import androidx.lifecycle.ViewModelProvider
import com.adjustablecompass.app.data.CompassRepository
import com.adjustablecompass.app.data.SettingsRepository
import com.adjustablecompass.app.databinding.ActivityCompassBinding
import com.adjustablecompass.app.ui.CompassViewModel
import kotlin.math.roundToInt

class CompassActivity : AppCompatActivity() {

    private lateinit var binding: ActivityCompassBinding
    private lateinit var viewModel: CompassViewModel
    private lateinit var sensorManager: SensorManager
    private var lastAzimuth: Float = 0f

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        binding = ActivityCompassBinding.inflate(layoutInflater)
        setContentView(binding.root)

        sensorManager = getSystemService(SENSOR_SERVICE) as SensorManager

        val compassRepository = CompassRepository(sensorManager)
        val settingsRepository = SettingsRepository(this)

        if (!compassRepository.isSensorAvailable()) {
            Toast.makeText(this, getString(R.string.sensor_error), Toast.LENGTH_LONG).show()
            finish()
            return
        }

        viewModel = ViewModelProvider(this, object : ViewModelProvider.Factory {
            @Suppress("UNCHECKED_CAST")
            override fun <T : androidx.lifecycle.ViewModel> create(modelClass: Class<T>): T {
                return CompassViewModel(compassRepository, settingsRepository) as T
            }
        })[CompassViewModel::class.java]

        setupObservers()
        setupClickListeners()
        
        viewModel.startCompass()
    }

    private fun setupObservers() {
        // 方位角の更新
        viewModel.adjustedAzimuth.observe(this) { azimuth ->
            updateCompassView(azimuth)
            updateAzimuthText(azimuth)
        }
        
        // 生の方位角の更新（調整モード用）
        viewModel.azimuth.observe(this) { rawAzimuth ->
            // 調整モード中はオフセットを更新
            if (viewModel.isAdjustmentMode.value == true) {
                viewModel.updateOffsetFromRotation(rawAzimuth)
            }
        }

        // オフセットの更新
        viewModel.offsetAngle.observe(this) { offset ->
            updateOffsetChip(offset)
        }

        // 調整モードの状態
        viewModel.isAdjustmentMode.observe(this) { isAdjustmentMode ->
            if (isAdjustmentMode) {
                binding.adjustmentOverlay.visibility = View.VISIBLE
                binding.offsetChip.visibility = View.VISIBLE
                binding.adjustButton.isEnabled = false
            } else {
                binding.adjustmentOverlay.visibility = View.GONE
                binding.offsetChip.visibility = View.GONE
                binding.adjustButton.isEnabled = true
            }
        }

        // ロック状態
        viewModel.isLocked.observe(this) { isLocked ->
            if (isLocked) {
                binding.lockButton.setIconResource(android.R.drawable.ic_lock_idle_lock)
                binding.adjustButton.isEnabled = false
                binding.resetButton.isEnabled = false
            } else {
                binding.lockButton.setIconResource(android.R.drawable.ic_lock_idle_unlock)
                binding.adjustButton.isEnabled = true
                binding.resetButton.isEnabled = true
            }
        }
    }

    private fun setupClickListeners() {
        binding.adjustButton.setOnClickListener {
            viewModel.enterAdjustmentMode()
        }

        binding.lockButton.setOnClickListener {
            if (viewModel.isLocked.value == true) {
                viewModel.unlockOffset()
            } else {
                if (viewModel.isAdjustmentMode.value == true) {
                    viewModel.lockOffset()
                } else {
                    // 調整モードに入らずにロックする場合、現在のオフセットをロック
                    viewModel.lockOffset()
                }
            }
        }

        binding.resetButton.setOnClickListener {
            showResetConfirmationDialog()
        }
    }

    private fun updateCompassView(azimuth: Float) {
        // CompassView内でCanvasのrotate()を使用して回転するため、
        // View自体の回転は不要
        binding.compassView.setAzimuth(azimuth)
        lastAzimuth = azimuth
    }

    private fun updateAzimuthText(azimuth: Float) {
        val azimuthInt = azimuth.roundToInt()
        binding.azimuthText.text = getString(R.string.azimuth_label, azimuthInt)
    }

    private fun updateOffsetChip(offset: Float) {
        val offsetInt = offset.roundToInt()
        val sign = if (offsetInt >= 0) "+" else ""
        binding.offsetChip.text = getString(R.string.offset_label, sign, offsetInt)
    }

    private fun showResetConfirmationDialog() {
        AlertDialog.Builder(this)
            .setTitle(getString(R.string.reset_button))
            .setMessage(getString(R.string.reset_confirmation))
            .setPositiveButton(getString(R.string.yes)) { _: DialogInterface, _: Int ->
                viewModel.resetOffset()
            }
            .setNegativeButton(getString(R.string.no), null)
            .show()
    }

    override fun onResume() {
        super.onResume()
        viewModel.startCompass()
    }

    override fun onPause() {
        super.onPause()
        // CompassRepositoryのFlowが自動的にクリーンアップされる
    }
}

