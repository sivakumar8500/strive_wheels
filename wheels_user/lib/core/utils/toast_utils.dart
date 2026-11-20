import 'package:flutter/material.dart';

class ToastUtils {
  /// Global toggle for toast notifications / snackbars.
  /// Set to [false] to disable non-critical snackbars/toasts throughout the booking and trip flows.
  static bool enableToasts = false;

  /// Shows a snackbar toast message if [enableToasts] is true.
  static void showToast(
    BuildContext context, {
    required String message,
    Color? backgroundColor,
    Duration duration = const Duration(seconds: 3),
  }) {
    if (!enableToasts) return;

    try {
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: backgroundColor,
          duration: duration,
          behavior: SnackBarBehavior.floating,
        ),
      );
    } catch (_) {}
  }

  /// Always displays an error banner/toast to alert the user about validation failures.
  static void showError(
    BuildContext context,
    String message, {
    Duration duration = const Duration(seconds: 4),
  }) {
    try {
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const Icon(Icons.error_outline, color: Colors.white, size: 20),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  message,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          backgroundColor: const Color(0xFFEF4444),
          duration: duration,
          behavior: SnackBarBehavior.floating,
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      );
    } catch (_) {}
  }

  /// Clears any currently showing snackbars.
  static void clearToasts(BuildContext context) {
    try {
      ScaffoldMessenger.of(context).clearSnackBars();
    } catch (_) {}
  }
}
