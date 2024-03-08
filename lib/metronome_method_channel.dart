import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'metronome_platform_interface.dart';

/// An implementation of [MetronomePlatform] that uses method channels.
class MethodChannelMetronome extends MetronomePlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('metronome');
  final eventTapChannel = const EventChannel("metronome_tap");

  @override
  Future<void> init(
    String mainPath, {
    int bpm = 120,
    int volume = 50,
  }) async {
    if (volume > 100 || volume < 0) {
      throw Exception('Volume must be between 0 and 100');
    }
    if (bpm < 0) {
      throw Exception('BPM must be greater than 0');
    }
    try {
      await methodChannel.invokeMethod<void>('init', {
        'path': mainPath,
        'bpm': bpm,
        'volume': volume / 100.0,
      });
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }

  @override
  Future<void> play(int bpm) async {
    try {
      await methodChannel.invokeMethod<void>('play', {
        'bpm': bpm,
      });
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
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
    }
  }

  @override
  Future<void> setBPM(int bpm) async {
    if (bpm < 0) {
      throw Exception('BPM must be greater than 0');
    }
    try {
      await methodChannel.invokeMethod<void>('setBPM', {
        'bpm': bpm,
      });
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }

  @override
  Future<int?> getBPM() async {
    try {
      return await methodChannel.invokeMethod<int>('getBPM');
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }

      return 0;
    }
  }

  @override
  Future<int?> getVolume() async {
    try {
      return await methodChannel.invokeMethod<int>('getVolume');
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }

      return 0;
    }
  }

  @override
  Future<void> setVolume(int volume) async {
    if (volume > 100 || volume < 0) {
      throw Exception('Volume must be between 0 and 100');
    }
    try {
      await methodChannel.invokeMethod<void>('setVolume', {
        'volume': volume / 100.0,
      });
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
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
    }
  }

  @override
  void onListenTap(onEvent) {
    eventTapChannel.receiveBroadcastStream().listen(onEvent);
  }
}
