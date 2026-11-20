import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/foundation.dart';

abstract class RideRingtoneService {
  Future<void> playCallingRingtone();
  Future<void> stopCallingRingtone();
  Future<void> dispose();
  bool get isPlaying;
}

class RideRingtoneServiceImpl implements RideRingtoneService {
  static final RideRingtoneServiceImpl _instance = RideRingtoneServiceImpl._internal();
  factory RideRingtoneServiceImpl() => _instance;
  RideRingtoneServiceImpl._internal();

  AudioPlayer? _player;
  bool _isPlaying = false;
  bool _shouldPlay = false;

  @override
  bool get isPlaying => _isPlaying;

  @override
  Future<void> playCallingRingtone() async {
    _shouldPlay = true;
    if (_isPlaying) return;
    try {
      _player ??= AudioPlayer();
      await _player!.setReleaseMode(ReleaseMode.loop);
      if (!_shouldPlay) {
        await _player?.stop();
        _isPlaying = false;
        return;
      }
      await _player!.play(AssetSource('audio/calling.mp3'));
      if (!_shouldPlay) {
        await _player?.stop();
        _isPlaying = false;
        return;
      }
      _isPlaying = true;
      debugPrint('[RideRingtoneService] Started playing calling.mp3 in loop');
    } catch (e) {
      _isPlaying = false;
      debugPrint('[RideRingtoneService] Error playing calling ringtone: $e');
    }
  }

  @override
  Future<void> stopCallingRingtone() async {
    _shouldPlay = false;
    _isPlaying = false;
    try {
      if (_player != null) {
        await _player!.stop();
        debugPrint('[RideRingtoneService] Stopped calling.mp3');
      }
    } catch (e) {
      debugPrint('[RideRingtoneService] Error stopping calling ringtone: $e');
    }
  }

  @override
  Future<void> dispose() async {
    _shouldPlay = false;
    _isPlaying = false;
    try {
      await stopCallingRingtone();
      await _player?.dispose();
      _player = null;
    } catch (e) {
      debugPrint('[RideRingtoneService] Error disposing player: $e');
    }
  }
}
