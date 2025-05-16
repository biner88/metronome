## 2.0.4

* fix(darwin): optimize audio routing change handling and application background mode

## 2.0.3

* Fix problem compiling for macOS [#21](https://github.com/biner88/metronome/issues/21)

## 2.0.2

* Fix multi-package support [#20](https://github.com/biner88/metronome/issues/20)

## 2.0.1

* Fix pub points
* remove path_provider dependency

## 2.0.0

* Add time signature [#2](https://github.com/biner88/metronome/issues/2)
* Add `sampleRate` parameter
* Add [Live preview](https://biner88.github.io/metronome/)
* Add windows support
* Add CallBack function on Tick for web
* Refactoring for MacOS, IOS, Android, Web
* Deprecated `onListenTick`, use `tickStream` instead
* Remove BPM parameter from `play()` method
* Remove `enableSession` parameter, no need to explicitly set audio session
* Remove IOS Media Player Widget [#16](https://github.com/biner88/metronome/issues/16)
* Fix Bluetooth headset and default player switching error [#15](https://github.com/biner88/metronome/issues/15)
* Update example

## 1.1.5

* Update readme

## 1.1.4

* Added `enableTickCallback` parameter in init, onTick will be called only when onListenTick is true

## 1.1.3

* Update example

## 1.1.2

* Update example
* Update path_provider
* Update minimum iOS implementation version
* Add privacy manifest
* Fix Android: remove destroy from onDetachedFromEngine [#10](https://github.com/biner88/metronome/issues/10) , [#7](https://github.com/biner88/metronome/pull/7) 

## 1.1.1+1

* Fix BPM must be greater than 0 [#8](https://github.com/biner88/metronome/issues/8)

## 1.1.1

* Add enableSession parameter for IOS [#5](https://github.com/biner88/metronome/issues/5)

## 1.1.0+1

* Fix init volume being ignored [#6](https://github.com/biner88/metronome/issues/6)

## 1.1.0

* Add CallBack function on Tick [#1](https://github.com/biner88/metronome/issues/1)
* Add getBMP() function
* Add MacOS support
* Fix IOS getVolume()
* Fix Android setVolume()
* Fix no sound with AirPods [#3](https://github.com/biner88/metronome/issues/3)
* Change ⚠️ volume type (double to int)
* Change ⚠️ BPM type (double to int)

## 1.0.4

* add pause() method
* fix stop() method replace pause() method

## 1.0.3

* fix android volume control

## 1.0.2

* update screenshot

## 1.0.0

* add android support
* add web support
* add example
* add screenshot

## 0.0.1

* Metronome, currently ios only.
