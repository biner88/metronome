// In order to *not* need this ignore, consider extracting the "web" version
// of your plugin as a separate package, instead of inlining it in the same
// package as the core of your plugin.
// ignore: avoid_web_libraries_in_flutter, unused_import
import 'dart:js';
import 'dart:js_interop';
import 'package:flutter/services.dart';
import 'package:flutter_web_plugins/flutter_web_plugins.dart';
import 'metronome_platform_interface.dart';

@JS()
external void initWeb(String mainPath, int bpm, int volume);
@JS()
external void playWeb(int bpm);
@JS()
external void stopWeb();
@JS()
external void setBPMWeb(int bpm);
@JS()
external void setVolumeWeb(int volume);
@JS()
external void setAudioFileWeb(String path);
@JS()
external int getVolumeWeb();
@JS()
external bool isPlayingWeb();
@JS()
external int getBPMWeb();
@JS()
external void enableTickCallbackWeb();

/// A web implementation of the MetronomePlatform of the Metronome plugin.
class MetronomeWeb extends MetronomePlatform {
  /// Constructs a MetronomeWeb
  MetronomeWeb();
  final eventTickChannel = const EventChannel("metronome_tick");

  static void registerWith(Registrar registrar) {
    MetronomePlatform.instance = MetronomeWeb();
  }

  @override
  Future<void> init(
    String mainPath, {
    int bpm = 120,
    int volume = 50,
    bool enableSession = true,
  }) async {
    if (volume > 100 || volume < 0) {
      throw Exception('Volume must be between 0 and 100');
    }
    if (bpm <= 0) {
      throw Exception('BPM must be greater than 0');
    }
    initWeb(mainPath, bpm, volume);
  }

  @override
  Future<void> setAudioAssets(String mainPath) async {
    MetronomePlatform.instance.setAudioFile(mainPath);
  }

  @override
  Future<void> play(int bpm) async {
    if (bpm <= 0) {
      throw Exception('BPM must be greater than 0');
    }
    playWeb(bpm);
  }

  @override
  Future<void> pause() async {
    stopWeb();
  }

  @override
  Future<void> stop() async {
    stopWeb();
  }

  @override
  Future<int?> getVolume() async {
    return getVolumeWeb();
  }

  @override
  Future<void> setVolume(int volume) async {
    setVolumeWeb(volume);
  }

  @override
  Future<bool?> isPlaying() async {
    return isPlayingWeb();
  }

  @override
  Future<void> setAudioFile(String mainPath) async {
    setAudioFileWeb(mainPath);
  }

  @override
  Future<void> setBPM(int bpm) async {
    if (bpm <= 0) {
      throw Exception('BPM must be greater than 0');
    }
    setBPMWeb(bpm);
  }

  @override
  Future<int> getBPM() async {
    return getBPMWeb();
  }

  @override
  void onListenTick(onEvent) {
    enableTickCallbackWeb();
    //TODO
    // eventTickChannel.receiveBroadcastStream().listen(onEvent);
  }
}
