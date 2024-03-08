import 'dart:io';
import 'package:flutter/services.dart';
import 'package:metronome/platform_utils.dart';
import 'package:path_provider/path_provider.dart';
import 'metronome_platform_interface.dart';

class Metronome {
  ///initialize the metronome
  Future<void> init(
    String mainPath, {
    String? accentedPath,
    int bpm = 120,
    int volume = 50,
  }) async {
    if (!PlatformUtils.isWeb) {
      String mainFile = await saveAudioAssetsToLocal(mainPath);
      MetronomePlatform.instance.init(mainFile, bpm: bpm, volume: volume);
    } else {
      MetronomePlatform.instance.init(mainPath, bpm: bpm, volume: volume);
    }
  }

  ///play the metronome
  Future<void> play(int bpm) async {
    return MetronomePlatform.instance.play(bpm);
  }

  ///pause the metronome
  Future<void> pause() async {
    return MetronomePlatform.instance.pause();
  }

  ///stop the metronome
  Future<void> stop() async {
    return MetronomePlatform.instance.stop();
  }

  ///get the volume of the metronome
  Future<int> getVolume() async {
    int? volume = await MetronomePlatform.instance.getVolume();
    return volume ?? 50;
  }

  ///set the volume of the metronome (0-100)
  Future<void> setVolume(int volume) async {
    return MetronomePlatform.instance.setVolume(volume);
  }

  ///check if the metronome is playing
  Future<bool?> isPlaying() async {
    return MetronomePlatform.instance.isPlaying();
  }

  ///set the audio file of the metronome
  Future<void> setAudioFile(String path) async {
    return MetronomePlatform.instance.setAudioFile(path);
  }

  ///set the audio assets of the metronome
  Future<void> setAudioAssets(String mainPath) async {
    if (!PlatformUtils.isWeb) {
      String mainFile = await saveAudioAssetsToLocal(mainPath);
      MetronomePlatform.instance.setAudioFile(mainFile);
    } else {
      MetronomePlatform.instance.setAudioFile(mainPath);
    }
  }

  ///set the bpm of the metronome
  Future<void> setBPM(int bpm) async {
    return MetronomePlatform.instance.setBPM(bpm);
  }

  ///get the bpm of the metronome
  Future<int> getBPM() async {
    int? bpm = await MetronomePlatform.instance.getBPM();
    return bpm ?? 120;
  }

  ///destroy the metronome
  Future<void> destroy() async {
    return MetronomePlatform.instance.destroy();
  }

  ///save the audio assets to local
  Future<String> saveAudioAssetsToLocal(String mainPath) async {
    Directory tempDir = await getTemporaryDirectory();
    String tempPath = tempDir.parent.parent.path;
    if (Platform.isAndroid) {
      tempPath = tempDir.path;
    }
    String fileName = mainPath.split('/').last;
    var mainFilePath = "$tempPath/tmp/$fileName";
    var mainFile = File(mainFilePath);
    if (!mainFile.existsSync()) {
      final mainByteData = await rootBundle.load(mainPath);
      final mainBuffer = mainByteData.buffer;
      mainFile.createSync(recursive: true);
      mainFile.writeAsBytesSync(mainBuffer.asUint8List(
          mainByteData.offsetInBytes, mainByteData.lengthInBytes));
    }
    return mainFile.path;
  }

  ///CallBack function on Tick
  void onListenTap(onEvent) {
    MetronomePlatform.instance.onListenTap(onEvent);
  }
}
