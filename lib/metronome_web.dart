// In order to *not* need this ignore, consider extracting the "web" version
// of your plugin as a separate package, instead of inlining it in the same
// package as the core of your plugin.
// ignore: avoid_web_libraries_in_flutter, unused_import
import 'dart:js';
import 'dart:js_interop';
import 'package:flutter_web_plugins/flutter_web_plugins.dart';
import 'metronome_platform_interface.dart';

@JS()
external void initm(
    String mainPath, int bpm, int volume, bool enableTapCallback);
@JS()
external void playm(int bpm);
@JS()
external void stopm();
@JS()
external void setBPMm(int bpm);
@JS()
external void setVolumem(int volume);
@JS()
external void setAudioFilem(String path);
@JS()
external int getVolumem();
@JS()
external bool isPlayingm();

/// A web implementation of the MetronomePlatform of the Metronome plugin.
class MetronomeWeb extends MetronomePlatform {
  /// Constructs a MetronomeWeb
  MetronomeWeb();

  static void registerWith(Registrar registrar) {
    MetronomePlatform.instance = MetronomeWeb();
  }

  @override
  Future<void> init(
    String mainPath, {
    int bpm = 120,
    int volume = 50,
    bool enableTapCallback = false,
  }) async {
    if (volume > 100 || volume < 0) {
      throw Exception('Volume must be between 0 and 100');
    }
    if (bpm < 0) {
      throw Exception('BPM must be greater than 0');
    }
    initm(mainPath, bpm, volume, enableTapCallback);
  }

  @override
  Future<void> setAudioAssets(String mainPath) async {
    MetronomePlatform.instance.setAudioFile(mainPath);
  }

  @override
  Future<void> play(int bpm) async {
    playm(bpm);
  }

  @override
  Future<void> pause() async {
    stopm();
  }

  @override
  Future<void> stop() async {
    stopm();
  }

  @override
  Future<int?> getVolume() async {
    return getVolumem();
  }

  @override
  Future<void> setVolume(int volume) async {
    setVolumem(volume);
  }

  @override
  Future<bool?> isPlaying() async {
    return isPlayingm();
  }

  @override
  Future<void> setAudioFile(String mainPath) async {
    setAudioFilem(mainPath);
  }

  @override
  Future<void> setBPM(int bpm) async {
    setBPMm(bpm);
  }
}
