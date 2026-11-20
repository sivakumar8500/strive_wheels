import 'package:flutter/material.dart';

class ToastUtils {
  /// Global toggle for toast notifications / snackbars.
  /// Set to [false] to disable all snackbars/toasts throughout the app.
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

  /// Clears any currently showing snackbars.
  static void clearToasts(BuildContext context) {
    try {
      ScaffoldMessenger.of(context).clearSnackBars();
    } catch (_) {}
  }
}
