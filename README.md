# Metronome

[![pub package](https://img.shields.io/pub/v/metronome.svg)](https://pub.dev/packages/metronome)

Efficient, accurate, cross-platform metronome; supports volume, BPM, and audio source settings.
##

![Metronome](https://raw.githubusercontent.com/biner88/metronome/main/screenshot/home.png)

## Quick Start 

### Init

```dart
final metronome = Metronome();
double bpm = 120;
double vol = 50;
metronome.init('assets/audio/snare.wav', bpm: bpm, volume: vol);
```

### Play

```dart
metronome.play();
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
