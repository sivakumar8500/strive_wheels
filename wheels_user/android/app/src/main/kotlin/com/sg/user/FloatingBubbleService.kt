package com.sg.user

import android.animation.ValueAnimator
import android.annotation.SuppressLint
import android.app.Service
import android.content.Context
import android.content.Intent
import android.graphics.Color
import android.graphics.PixelFormat
import android.graphics.Typeface
import android.graphics.drawable.GradientDrawable
import android.os.Build
import android.os.IBinder
import android.provider.Settings
import android.util.TypedValue
import android.view.Gravity
import android.view.MotionEvent
import android.view.View
import android.view.WindowManager
import android.view.animation.DecelerateInterpolator
import android.widget.FrameLayout
import android.widget.LinearLayout
import android.widget.TextView

class FloatingBubbleService : Service() {

    companion object {
        var isShowing: Boolean = false
            private set
    }

    private var windowManager: WindowManager? = null
    private var bubbleContainer: FrameLayout? = null
    private var layoutParams: WindowManager.LayoutParams? = null

    override fun onBind(intent: Intent?): IBinder? = null

    override fun onStartCommand(intent: Intent?, flags: Int, startId: Int): Int {
        if (!Settings.canDrawOverlays(this)) {
            stopSelf()
            return START_NOT_STICKY
        }

        val title = intent?.getStringExtra("title") ?: "STRIVE"
        val subText = intent?.getStringExtra("subText") ?: "WHEELS"

        if (bubbleContainer == null) {
            initBubble(title, subText)
        } else {
            updateBubbleContent(title, subText)
        }

        return START_NOT_STICKY
    }

    private fun dpToPx(dp: Float): Int {
        return TypedValue.applyDimension(
            TypedValue.COMPLEX_UNIT_DIP,
            dp,
            resources.displayMetrics
        ).toInt()
    }

    @SuppressLint("ClickableViewAccessibility")
    private fun initBubble(title: String, subText: String) {
        windowManager = getSystemService(Context.WINDOW_SERVICE) as WindowManager

        val bubbleSizePx = dpToPx(66f)

        // Window Layout Parameters
        val type = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            WindowManager.LayoutParams.TYPE_APPLICATION_OVERLAY
        } else {
            WindowManager.LayoutParams.TYPE_PHONE
        }

        layoutParams = WindowManager.LayoutParams(
            bubbleSizePx,
            bubbleSizePx,
            type,
            WindowManager.LayoutParams.FLAG_NOT_FOCUSABLE or
                    WindowManager.LayoutParams.FLAG_LAYOUT_NO_LIMITS,
            PixelFormat.TRANSLUCENT
        ).apply {
            gravity = Gravity.TOP or Gravity.START
            x = 0 // Docked to left edge initially
            y = (resources.displayMetrics.heightPixels * 0.40).toInt()
        }

        // Outer circular container
        bubbleContainer = FrameLayout(this).apply {
            val bgDrawable = GradientDrawable().apply {
                shape = GradientDrawable.OVAL
                setColor(Color.WHITE)
                setStroke(dpToPx(1.5f), Color.parseColor("#E2E8F0"))
            }
            background = bgDrawable
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.LOLLIPOP) {
                elevation = dpToPx(8f).toFloat()
            }
        }

        // Inner vertical content (Title + SubText pill)
        val contentLayout = LinearLayout(this).apply {
            orientation = LinearLayout.VERTICAL
            gravity = Gravity.CENTER
            val lp = FrameLayout.LayoutParams(
                FrameLayout.LayoutParams.MATCH_PARENT,
                FrameLayout.LayoutParams.MATCH_PARENT
            )
            layoutParams = lp
        }

        // Brand Title (e.g. STRIVE)
        val titleView = TextView(this).apply {
            id = View.generateViewId()
            text = title
            textSize = 10f
            typeface = Typeface.DEFAULT_BOLD
            setTextColor(Color.parseColor("#0F172A"))
            gravity = Gravity.CENTER
        }
        contentLayout.addView(titleView)

        // Pill badge for role or status (e.g. WHEELS / RIDE)
        val pillContainer = FrameLayout(this).apply {
            val pillBg = GradientDrawable().apply {
                shape = GradientDrawable.RECTANGLE
                cornerRadius = dpToPx(8f).toFloat()
                setColor(Color.parseColor("#DCFCE7")) // Soft fresh emerald mint
            }
            background = pillBg
            val pillLp = LinearLayout.LayoutParams(
                LinearLayout.LayoutParams.WRAP_CONTENT,
                LinearLayout.LayoutParams.WRAP_CONTENT
            ).apply {
                topMargin = dpToPx(2f)
            }
            layoutParams = pillLp
            setPadding(dpToPx(5f), dpToPx(1.5f), dpToPx(5f), dpToPx(1.5f))
        }

        val subTextView = TextView(this).apply {
            id = View.generateViewId()
            text = subText
            textSize = 8.5f
            typeface = Typeface.DEFAULT_BOLD
            setTextColor(Color.parseColor("#15803D")) // Dark emerald text
            gravity = Gravity.CENTER
        }
        pillContainer.addView(subTextView)
        contentLayout.addView(pillContainer)

        bubbleContainer?.addView(contentLayout)

        // Status indicator dot (top-right)
        val onlineDot = View(this).apply {
            val dotDrawable = GradientDrawable().apply {
                shape = GradientDrawable.OVAL
                setColor(Color.parseColor("#10B981")) // Active emerald green
                setStroke(dpToPx(1f), Color.WHITE)
            }
            background = dotDrawable
            val dotSize = dpToPx(11f)
            val dotLp = FrameLayout.LayoutParams(dotSize, dotSize).apply {
                gravity = Gravity.TOP or Gravity.END
                topMargin = dpToPx(4f)
                rightMargin = dpToPx(4f)
            }
            layoutParams = dotLp
        }
        bubbleContainer?.addView(onlineDot)

        // Setup touch drag & click
        setupTouchListener(bubbleContainer!!)

        try {
            windowManager?.addView(bubbleContainer, layoutParams)
            isShowing = true
        } catch (e: Exception) {
            e.printStackTrace()
            stopSelf()
        }
    }

    private fun updateBubbleContent(title: String, subText: String) {
        // Safe update if needed
    }

    @SuppressLint("ClickableViewAccessibility")
    private fun setupTouchListener(view: View) {
        var initialX = 0
        var initialY = 0
        var initialTouchX = 0f
        var initialTouchY = 0f
        var touchStartTime = 0L

        view.setOnTouchListener { _, event ->
            val params = layoutParams ?: return@setOnTouchListener false
            when (event.action) {
                MotionEvent.ACTION_DOWN -> {
                    initialX = params.x
                    initialY = params.y
                    initialTouchX = event.rawX
                    initialTouchY = event.rawY
                    touchStartTime = System.currentTimeMillis()
                    true
                }
                MotionEvent.ACTION_MOVE -> {
                    params.x = (initialX + (event.rawX - initialTouchX)).toInt()
                    params.y = (initialY + (event.rawY - initialTouchY)).toInt()
                    try {
                        windowManager?.updateViewLayout(view, params)
                    } catch (_: Exception) {}
                    true
                }
                MotionEvent.ACTION_UP -> {
                    val diffX = Math.abs(event.rawX - initialTouchX)
                    val diffY = Math.abs(event.rawY - initialTouchY)
                    val duration = System.currentTimeMillis() - touchStartTime

                    if (diffX < dpToPx(10f) && diffY < dpToPx(10f) && duration < 300) {
                        // Click detected: Bring Strive Wheels Customer app to the foreground
                        val launchIntent = packageManager.getLaunchIntentForPackage(packageName)?.apply {
                            flags = Intent.FLAG_ACTIVITY_NEW_TASK or
                                    Intent.FLAG_ACTIVITY_REORDER_TO_FRONT or
                                    Intent.FLAG_ACTIVITY_SINGLE_TOP
                        }
                        if (launchIntent != null) {
                            startActivity(launchIntent)
                        }
                    } else {
                        // Snap smoothly to nearest screen edge (left or right)
                        snapToNearestEdge(view, event.rawX)
                    }
                    true
                }
                else -> false
            }
        }
    }

    private fun snapToNearestEdge(view: View, currentRawX: Float) {
        val params = layoutParams ?: return
        val screenWidth = resources.displayMetrics.widthPixels
        val viewWidth = view.width.coerceAtLeast(dpToPx(66f))
        val targetX = if (currentRawX < screenWidth / 2) 0 else (screenWidth - viewWidth)

        val startX = params.x
        val animator = ValueAnimator.ofInt(startX, targetX)
        animator.duration = 200
        animator.interpolator = DecelerateInterpolator()
        animator.addUpdateListener { va ->
            params.x = va.animatedValue as Int
            try {
                windowManager?.updateViewLayout(view, params)
            } catch (_: Exception) {}
        }
        animator.start()
    }

    override fun onDestroy() {
        super.onDestroy()
        if (bubbleContainer != null && windowManager != null) {
            try {
                windowManager?.removeView(bubbleContainer)
            } catch (_: Exception) {}
            bubbleContainer = null
        }
        isShowing = false
    }
}
