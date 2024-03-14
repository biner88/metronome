import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:metronome/metronome.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final _metronomePlugin = Metronome();
  bool isplaying = false;
  int bpm = 120;
  int vol = 50;
  @override
  void initState() {
    super.initState();
    _metronomePlugin.init(
      'assets/audio/snare.wav',
      bpm: bpm,
      volume: vol,
      enableTapCallback: true,
    );
    _metronomePlugin.onListenTap((_) {
      if (kDebugMode) {
        print('tap');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Metronome example'),
        ),
        body: SizedBox(
          width: double.infinity,
          child: Column(
            children: [
              Text(
                'BPM:$bpm',
                style: const TextStyle(fontSize: 20),
              ),
              Slider(
                value: bpm.toDouble(),
                min: 30,
                max: 300,
                divisions: 270,
                onChanged: (val) {
                  bpm = val.toInt();
                  _metronomePlugin.setBPM(bpm);
                  setState(() {});
                },
              ),
              Text(
                'Volume:$vol%',
                style: const TextStyle(fontSize: 20),
              ),
              Slider(
                value: vol.toDouble(),
                min: 0,
                max: 100,
                divisions: 100,
                onChanged: (val) {
                  vol = val.toInt();
                  _metronomePlugin.setVolume(vol);
                  setState(() {});
                },
              ),
              SizedBox(
                width: 200,
                height: 400,
                child: ListView(
                  children: [
                    ElevatedButton(
                      child: const Text("base"),
                      onPressed: () {
                        _metronomePlugin
                            .setAudioAssets('assets/audio/base44_wav.wav');
                      },
                    ),
                    ElevatedButton(
                      child: const Text("claves"),
                      onPressed: () {
                        _metronomePlugin
                            .setAudioAssets('assets/audio/claves44_wav.wav');
                      },
                    ),
                    ElevatedButton(
                      child: const Text("hihat"),
                      onPressed: () {
                        _metronomePlugin
                            .setAudioAssets('assets/audio/hihat44_wav.wav');
                      },
                    ),
                    ElevatedButton(
                      child: const Text("snare"),
                      onPressed: () {
                        _metronomePlugin
                            .setAudioAssets('assets/audio/snare.wav');
                      },
                    ),
                    ElevatedButton(
                      child: const Text("sticks"),
                      onPressed: () {
                        _metronomePlugin
                            .setAudioAssets('assets/audio/sticks48_wav.wav');
                      },
                    ),
                    ElevatedButton(
                      child: const Text("woodblock_high"),
                      onPressed: () {
                        _metronomePlugin.setAudioAssets(
                            'assets/audio/woodblock_high44_wav.wav');
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
            if (isplaying) {
              _metronomePlugin.pause();
              isplaying = false;
            } else {
              _metronomePlugin.setVolume(vol);
              _metronomePlugin.play(bpm);
              isplaying = true;
            }
            // int? bpm2 = await _metronomePlugin.getBPM();
            // print(bpm2);
            // int? vol2 = await _metronomePlugin.getVolume();
            // print(vol2);
            setState(() {});
          },
          child: Icon(isplaying ? Icons.pause : Icons.play_arrow),
        ),
      ),
    );
  }
}
