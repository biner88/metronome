// In order to *not* need this ignore, consider extracting the "web" version
// of your plugin as a separate package, instead of inlining it in the same
// package as the core of your plugin.
// ignore: avoid_web_libraries_in_flutter, unused_import
import 'dart:js';
import 'dart:js_interop';
import 'package:flutter_web_plugins/flutter_web_plugins.dart';
import 'metronome_platform_interface.dart';

@JS()
external void initm(String mainPath, double bpm, double volume);
@JS()
external void playm(double bpm);
@JS()
external void stopm();
@JS()
external void setBPMm(double bpm);
@JS()
external void setVolumem(double volume);
@JS()
external void setAudioFilem(String path);
@JS()
external double getVolumem();
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
    double bpm = 120.0,
    double volume = 50,
  }) async {
    initm(mainPath, bpm, volume);
  }

  @override
  Future<void> setAudioAssets(String mainPath) async {
    MetronomePlatform.instance.setAudioFile(mainPath);
  }

  @override
  Future<void> play(double bpm) async {
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
  Future<double?> getVolume() async {
    return getVolumem();
  }

  @override
  Future<void> setVolume(double volume) async {
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
  Future<void> setBPM(double bpm) async {
    setBPMm(bpm);
  }
}
