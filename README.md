# Metronome

[![pub package](https://img.shields.io/pub/v/metronome.svg)](https://pub.dev/packages/metronome)

Efficient, accurate, cross-platform metronome; supports volume, BPM, and audio source settings.
##

![Metronome](https://raw.githubusercontent.com/biner88/metronome/main/screenshot/demo2.png)

## TODO

* [ ] Add support for time signature [#2](https://github.com/biner88/metronome/issues/2)
* [ ] Add Windows support
* [ ] Add CallBack function on Tick for web

## Quick Start 

### Init

```dart
final metronome = Metronome();
metronome.init('assets/audio/snare.wav', bpm: 120, volume: 50);
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

### get Play state

```dart
metronome.isPlaying();
```

### setAudioFile

```dart
metronome.setAudioFile('assets/audio/snare.wav');
```

### destroy

```dart
metronome.destroy();
```

### Tick callback

```
metronome.onListenTick((_) {
  if (kDebugMode) {
    print('tick');
  }
});
```

## About Web

Please add the `example/web/app.js` file to index.html under your web. As follows:

```html
<script src="app.js" defer></script>
```
