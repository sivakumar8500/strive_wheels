// ignore: avoid_web_libraries_in_flutter, deprecated_member_use
import 'dart:js' as js;

/// Web implementation checking if window.google.maps JS object is initialized.
bool isGoogleMapJsLoaded() {
  try {
    if (js.context.hasProperty('google')) {
      final google = js.context['google'];
      if (google != null) {
        return js.context.hasProperty('google.maps') || (google is Map && google.containsKey('maps'));
      }
    }
  } catch (_) {}
  return false;
}
