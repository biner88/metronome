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
  String metronomeIcon = 'assets/metronome-left.png';
  String metronomeIconRight = 'assets/metronome-right.png';
  String metronomeIconLeft = 'assets/metronome-left.png';
  @override
  void initState() {
    super.initState();
    _metronomePlugin.init(
      'assets/audio/snare.wav',
      bpm: bpm,
      volume: vol,
    );
    _metronomePlugin.onListenTick((_) {
      if (kDebugMode) {
        print('tick');
      }
      setState(() {
        if (metronomeIcon == metronomeIconRight) {
          metronomeIcon = metronomeIconLeft;
        } else {
          metronomeIcon = metronomeIconRight;
        }
      });
    });
  }

  @override
  void dispose() {
    _metronomePlugin.destroy();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Metronome example'),
        ),
        body: Container(
          padding: const EdgeInsets.all(10),
          child: ListView(
            children: [
              Image.asset(
                metronomeIcon,
                height: 100,
                gaplessPlayback: true,
              ),
              Text(
                'BPM:$bpm',
                style: const TextStyle(fontSize: 20),
              ),
              Slider(
                value: bpm.toDouble(),
                min: 30,
                max: 300,
                divisions: 270,
                onChangeEnd: (val) {
                  _metronomePlugin.setBPM(bpm);
                },
                onChanged: (val) {
                  bpm = val.toInt();
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
                onChangeEnd: (val) {
                  _metronomePlugin.setVolume(vol);
                },
                onChanged: (val) {
                  vol = val.toInt();
                  setState(() {});
                },
              ),
              SizedBox(
                width: 200,
                height: 350,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      child: const Text("base"),
                      onPressed: () async {
                        await _metronomePlugin
                            .setAudioAssets('assets/audio/base44_wav.wav');
                        await _metronomePlugin.setBPM(bpm);
                      },
                    ),
                    ElevatedButton(
                      child: const Text("claves"),
                      onPressed: () async {
                        await _metronomePlugin
                            .setAudioAssets('assets/audio/claves44_wav.wav');
                        await _metronomePlugin.setBPM(bpm);
                      },
                    ),
                    ElevatedButton(
                      child: const Text("hihat"),
                      onPressed: () async {
                        await _metronomePlugin
                            .setAudioAssets('assets/audio/hihat44_wav.wav');
                        await _metronomePlugin.setBPM(bpm);
                      },
                    ),
                    ElevatedButton(
                      child: const Text("snare"),
                      onPressed: () async {
                        await _metronomePlugin
                            .setAudioAssets('assets/audio/snare.wav');
                        await _metronomePlugin.setBPM(bpm);
                      },
                    ),
                    ElevatedButton(
                      child: const Text("sticks"),
                      onPressed: () async {
                        await _metronomePlugin
                            .setAudioAssets('assets/audio/sticks44_wav.wav');
                        await _metronomePlugin.setBPM(bpm);
                      },
                    ),
                    ElevatedButton(
                      child: const Text("woodblock_high"),
                      onPressed: () async {
                        await _metronomePlugin
                            .setAudioAssets(
                                'assets/audio/woodblock_high44_wav.wav')
                            .then((value) => null);
                        await _metronomePlugin.setBPM(bpm);
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
