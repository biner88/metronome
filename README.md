# Metronome

[![pub package](https://img.shields.io/pub/v/metronome.svg)](https://pub.dev/packages/metronome)

Efficient, accurate, cross-platform metronome; supports volume, BPM, and audio source settings.
##

![Metronome](https://raw.githubusercontent.com/biner88/metronome/main/screenshot/home1.png)

## TODO

* [ ] Add CallBack function on Tick
* [ ] Add MacOS support
* [ ] Add Windows support
* [ ] Add getBMP function
* [x] change volume type (double to int)
* [x] change bmp type (double to int)

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

### Set BPM

```dart
metronome.setBPM(120); 
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

## About Web

Please add the `example/web/app.js` file to index.html under your web. As follows:

```html
<script src="app.js" defer></script>
```
