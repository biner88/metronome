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
  double bpm = 120;
  double vol = 50;
  @override
  void initState() {
    super.initState();
    _metronomePlugin.init('assets/audio/sound3.wav', bpm: bpm, volume: vol);
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
                value: bpm,
                min: 30,
                max: 300,
                divisions: 270,
                onChanged: (val) {
                  bpm = val.roundToDouble();
                  _metronomePlugin.setBPM(bpm);
                  setState(() {});
                },
              ),
              Text(
                'Volume:$vol',
                style: const TextStyle(fontSize: 20),
              ),
              Slider(
                value: vol,
                min: 0,
                max: 100,
                divisions: 100,
                onChanged: (val) {
                  vol = val.roundToDouble();
                  _metronomePlugin.setVolume(vol);
                  setState(() {});
                },
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  ElevatedButton(
                    child: const Text("base44"),
                    onPressed: () {
                      _metronomePlugin
                          .setAudioAssets('assets/audio/base44_wav.wav');
                    },
                  ),
                  ElevatedButton(
                    child: const Text("sound3"),
                    onPressed: () {
                      _metronomePlugin
                          .setAudioAssets('assets/audio/sound3.wav');
                    },
                  ),
                  ElevatedButton(
                    child: const Text("snare"),
                    onPressed: () {
                      _metronomePlugin.setAudioAssets('assets/audio/snare.wav');
                    },
                  ),
                  ElevatedButton(
                    child: const Text("sticks48"),
                    onPressed: () {
                      _metronomePlugin
                          .setAudioAssets('assets/audio/sticks48_wav.wav');
                    },
                  ),
                ],
              )
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            if (isplaying) {
              _metronomePlugin.pause();
              isplaying = false;
            } else {
              _metronomePlugin.setVolume(vol);
              _metronomePlugin.play(bpm);
              isplaying = true;
            }
            setState(() {});
          },
          child: Icon(isplaying ? Icons.pause : Icons.play_arrow),
        ),
      ),
    );
  }
}
