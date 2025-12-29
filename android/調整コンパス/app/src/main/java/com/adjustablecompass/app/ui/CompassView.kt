package com.adjustablecompass.app.ui

import android.content.Context
import android.graphics.Canvas
import android.graphics.Color
import android.graphics.Paint
import android.graphics.Path
import android.graphics.RectF
import android.util.AttributeSet
import android.view.View
import androidx.core.content.ContextCompat
import com.adjustablecompass.app.R

class CompassView @JvmOverloads constructor(
    context: Context,
    attrs: AttributeSet? = null,
    defStyleAttr: Int = 0
) : View(context, attrs, defStyleAttr) {

    private var azimuth: Float = 0f
    private var centerX: Float = 0f
    private var centerY: Float = 0f
    private var radius: Float = 0f

    private val paint = Paint(Paint.ANTI_ALIAS_FLAG)
    private val textPaint = Paint(Paint.ANTI_ALIAS_FLAG)
    private val northPaint = Paint(Paint.ANTI_ALIAS_FLAG)
    private val arrowPaint = Paint(Paint.ANTI_ALIAS_FLAG)
    private val markerPaint = Paint(Paint.ANTI_ALIAS_FLAG)

    private val arrowPath = Path()
    private val isDarkMode: Boolean

    init {
        isDarkMode = (resources.configuration.uiMode and 
            android.content.res.Configuration.UI_MODE_NIGHT_MASK) == 
            android.content.res.Configuration.UI_MODE_NIGHT_YES

        setupPaints()
    }

    private fun setupPaints() {
        // 外側リング
        paint.style = Paint.Style.STROKE
        paint.strokeWidth = 2f
        paint.color = if (isDarkMode) Color.parseColor("#BDBDBD") else Color.parseColor("#BDBDBD")

        // テキスト（方位ラベル）
        textPaint.textAlign = Paint.Align.CENTER
        textPaint.textSize = 48f
        textPaint.typeface = android.graphics.Typeface.DEFAULT_BOLD

        // 北（N）の色
        northPaint.textAlign = Paint.Align.CENTER
        northPaint.textSize = 56f
        northPaint.typeface = android.graphics.Typeface.DEFAULT_BOLD
        northPaint.color = Color.parseColor("#F44336")

        // 矢印
        arrowPaint.style = Paint.Style.FILL
        arrowPaint.color = Color.parseColor("#1976D2")

        // マーカー
        markerPaint.style = Paint.Style.STROKE
        markerPaint.strokeWidth = 1f
        markerPaint.color = if (isDarkMode) Color.parseColor("#757575") else Color.parseColor("#757575")
    }

    fun setAzimuth(angle: Float) {
        azimuth = angle
        invalidate()
    }

    override fun onSizeChanged(w: Int, h: Int, oldw: Int, oldh: Int) {
        super.onSizeChanged(w, h, oldw, oldh)
        centerX = w / 2f
        centerY = h / 2f
        radius = minOf(w, h) / 2f - 40f
        createArrowPath()
    }

    private fun createArrowPath() {
        arrowPath.reset()
        val arrowLength = radius * 0.3f
        val arrowWidth = radius * 0.15f
        
        arrowPath.moveTo(0f, -arrowLength)
        arrowPath.lineTo(-arrowWidth, arrowLength * 0.3f)
        arrowPath.lineTo(0f, 0f)
        arrowPath.lineTo(arrowWidth, arrowLength * 0.3f)
        arrowPath.close()
    }

    override fun onDraw(canvas: Canvas) {
        super.onDraw(canvas)

        canvas.save()
        canvas.translate(centerX, centerY)
        canvas.rotate(-azimuth)

        // 外側リング
        canvas.drawCircle(0f, 0f, radius, paint)

        // 45度ごとのマーカー
        for (i in 0 until 8) {
            val angle = i * 45f
            val startX = radius * 0.85f * kotlin.math.cos(Math.toRadians(angle.toDouble())).toFloat()
            val startY = radius * 0.85f * kotlin.math.sin(Math.toRadians(angle.toDouble())).toFloat()
            val endX = radius * kotlin.math.cos(Math.toRadians(angle.toDouble())).toFloat()
            val endY = radius * kotlin.math.sin(Math.toRadians(angle.toDouble())).toFloat()
            canvas.drawLine(startX, startY, endX, endY, markerPaint)
        }

        // 方位ラベル（N, E, S, W）
        val labelRadius = radius * 0.75f
        val directions = arrayOf("N", "E", "S", "W")
        val angles = floatArrayOf(0f, 90f, 180f, 270f)

        for (i in directions.indices) {
            val angle = angles[i]
            val x = labelRadius * kotlin.math.cos(Math.toRadians(angle.toDouble())).toFloat()
            val y = labelRadius * kotlin.math.sin(Math.toRadians(angle.toDouble())).toFloat()

            if (directions[i] == "N") {
                canvas.drawText("N", x, y + 20f, northPaint)
            } else {
                textPaint.color = if (isDarkMode) Color.parseColor("#757575") else Color.parseColor("#757575")
                canvas.drawText(directions[i], x, y + 20f, textPaint)
            }
        }

        // 中央の矢印
        canvas.drawPath(arrowPath, arrowPaint)

        canvas.restore()

        // 上部の固定マーカー（現在の方位を示す）
        canvas.save()
        canvas.translate(centerX, centerY - radius - 20f)
        markerPaint.strokeWidth = 3f
        markerPaint.color = Color.parseColor("#1976D2")
        canvas.drawLine(-15f, 0f, 15f, 0f, markerPaint)
        canvas.drawLine(0f, 0f, 0f, 15f, markerPaint)
        canvas.restore()
    }
}


