import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'metronome_platform_interface.dart';

/// An implementation of [MetronomePlatform] that uses method channels.
class MethodChannelMetronome extends MetronomePlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('metronome');
  final eventTickChannel = const EventChannel("metronome_tick");

  MethodChannelMetronome() {
    eventTickChannel.receiveBroadcastStream().listen(
      (event) {
        if (event is int) {
          tickController.add(event);
        }
      },
      onError: (error) {
        // print("Tick Stream Error: $error");
      },
    );
  }
  @override
  Future<void> init(
    String mainPath, {
    String accentedPath = '',
    int bpm = 120,
    int volume = 50,
    bool enableTickCallback = false,
    int timeSignature = 4,
    int sampleRate = 44100,
  }) async {
    if (mainPath == '') {
      throw Exception('Main path cannot be empty');
    }
    if (volume > 100 || volume < 0) {
      throw Exception('Volume must be between 0 and 100');
    }
    if (bpm <= 0) {
      throw Exception('BPM must be greater than 0');
    }
    if (timeSignature < 0) {
      throw Exception('timeSignature must be greater than 0');
    }
    if (sampleRate <= 0) {
      throw Exception('sampleRate must be greater than 0');
    }
    Uint8List mainFileBytes = await loadFileBytes(mainPath);
    Uint8List accentedFileBytes = Uint8List.fromList([]);
    if (accentedPath != '') {
      accentedFileBytes = await loadFileBytes(accentedPath);
    }
    try {
      await methodChannel.invokeMethod<void>('init', {
        'mainFileBytes': mainFileBytes,
        'accentedFileBytes': accentedFileBytes,
        'bpm': bpm,
        'volume': volume / 100.0,
        'enableTickCallback': enableTickCallback,
        'timeSignature': timeSignature,
        'sampleRate': sampleRate,
      });
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }

  @override
  Future<void> play() async {
    try {
      await methodChannel.invokeMethod<void>('play');
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
    if (bpm <= 0) {
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
  Future<void> setTimeSignature(int timeSignature) async {
    if (timeSignature < 0) {
      throw Exception('timeSignature must be a positive integer');
    }
    try {
      await methodChannel.invokeMethod<void>('setTimeSignature', {
        'timeSignature': timeSignature,
      });
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }

  @override
  Future<int?> getTimeSignature() async {
    try {
      return await methodChannel.invokeMethod<int>('getTimeSignature');
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
        'volume': volume / 100,
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
  Future<void> setAudioFile({
    String mainPath = '',
    String accentedPath = '',
  }) async {
    Uint8List mainFileBytes = Uint8List.fromList([]);
    Uint8List accentedFileBytes = Uint8List.fromList([]);
    if (mainPath != '') {
      mainFileBytes = await loadFileBytes(mainPath);
    }
    if (accentedPath != '') {
      accentedFileBytes = await loadFileBytes(accentedPath);
    }
    if (mainFileBytes.isEmpty && accentedFileBytes.isEmpty) {
      return;
    }
    try {
      await methodChannel.invokeMethod<void>('setAudioFile', {
        'mainFileBytes': mainFileBytes,
        'accentedFileBytes': accentedFileBytes,
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

  Future<Uint8List> loadFileBytes(String filePath) async {
    if (!filePath.startsWith('/')) {
      ByteData data = await rootBundle.load(filePath);
      return data.buffer.asUint8List();
    } else {
      File file = File(filePath);
      bool fileExists = await file.exists();
      if (!fileExists) {
        throw Exception('File does not exist: $filePath');
      }
      return await file.readAsBytes();
    }
  }
}
