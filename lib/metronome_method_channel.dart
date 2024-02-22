import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'metronome_platform_interface.dart';

/// An implementation of [MetronomePlatform] that uses method channels.
class MethodChannelMetronome extends MetronomePlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('metronome');
  @override
  Future<void> init(
    String mainPath, {
    double bpm = 120.0,
    double volume = 50.0,
  }) async {
    try {
      await methodChannel.invokeMethod<void>('init', {
        'path': mainPath,
        'bpm': bpm,
        'volume': volume,
      });
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      // rethrow;
    }
  }

  @override
  Future<void> play(double bpm) async {
    try {
      await methodChannel.invokeMethod<void>('play', {
        'bpm': bpm,
      });
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      // rethrow;
    }
  }

  @override
  Future<void> setBPM(double bpm) async {
    try {
      await methodChannel.invokeMethod<void>('setBPM', {
        'bpm': bpm,
      });
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      // rethrow;
    }
  }

  @override
  Future<void> pause() async {
    try {
      await methodChannel.invokeMethod<void>('pause');
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      // rethrow;
    }
  }

  @override
  Future<void> stop() async {
    try {
      await methodChannel.invokeMethod<void>('stop');
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      // rethrow;
    }
  }

  @override
  Future<double?> getVolume() async {
    try {
      return await methodChannel.invokeMethod<double>('getVolume');
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      // rethrow;
      return 0;
    }
  }

  @override
  Future<void> setVolume(double volume) async {
    try {
      await methodChannel.invokeMethod<void>('setVolume', {
        'volume': volume,
      });
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      // rethrow;
    }
  }

  @override
  Future<bool?> isPlaying() async {
    try {
      return await methodChannel.invokeMethod<bool>('isPlaying');
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      // rethrow;
      return false;
    }
  }

  @override
  Future<void> setAudioFile(String mainPath) async {
    try {
      await methodChannel.invokeMethod<void>('setAudioFile', {
        'path': mainPath,
      });
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      // rethrow;
    }
  }

  @override
  Future<void> setAudioAssets(String mainPath) async {
    try {
      await methodChannel.invokeMethod<void>('setAudioAssets', {
        'path': mainPath,
      });
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      // rethrow;
    }
  }

  @override
  Future<void> destroy() async {
    try {
      await methodChannel.invokeMethod<void>('destroy');
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      // rethrow;
    }
  }
}
