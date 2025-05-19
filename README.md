# Metronome

[![pub package](https://img.shields.io/pub/v/metronome.svg)](https://pub.dev/packages/metronome)

Efficient, accurate, cross-platform metronome; 
supports volume, BPM, time signature and audio source settings.

**Version 2.0 refactored most of the code, with better performance (BPM>600), less resource usage, and more accurate time signature callback.**

##

![Metronome](https://raw.githubusercontent.com/biner88/metronome/main/screenshot/demo2.png)

## Demo

[Live preview](https://biner88.github.io/metronome/)

## TODO

* [x] Add support for time signature [#2](https://github.com/biner88/metronome/issues/2)
* [x] Add windows support
* [x] Add tickCallback for web

## Quick Start 

### Init

```dart
final metronome = Metronome();
metronome.init(
    'assets/audio/snare.wav', 
    accentedPath: 'assets/audio/claves44_wav.wav',
    bpm: 120, 
    //0 ~ 100
    volume: 50,  
    enableTickCallback: true,
    // The time signature is the number of beats per measure,default is 4
    timeSignature: 4,
    sampleRate: 44100,
);
```

### Play

```dart
metronome.play();
```

### Pause

```dart
metronome.pause();
```

### Stop

```dart
metronome.stop();
```

### Volume

```dart
metronome.getVolume();
metronome.setVolume(50);
```

### BPM

```dart
metronome.setBPM(120); 
metronome.getBPM(); 
```

### TimeSignature

Disable accents when less than 2

```dart
metronome.setTimeSignature(4); 
metronome.getTimeSignature(); 
```

### isPlaying

Get play state

```dart
metronome.isPlaying();
```

### isInitialized

Getter that returns true if the metronome has completed initialization. After `init` is called.
Not platform dependant.

```dart
metronome.isInitialized;
```

### setAudioFile

main, accent can be set at the same time or individually

```dart
metronome.setAudioFile(
    mainPath:'assets/audio/snare.wav',
    accentedPath:'assets/audio/claves.wav'
);
metronome.setAudioFile(
    mainPath:'assets/audio/snare.wav',
);
```

### destroy

```dart
metronome.destroy();
```

### Tick callback

`enableTickCallback` must be set to `true` in init

```dart
metronome.tickStream.listen((int tick) {
  print("tick: $tick");
});
```


