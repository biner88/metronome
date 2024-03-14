var timer, currentBeatInBar, accentPitch = 380, offBeatPitch = 200;
var delta = 0;
var secondsPerBeat = 0.0;
var isPlaying = false;
var volume = 1;
var takt = "4"
var bpm = 120;
var metronomeSoundBuffer = null;
var metronomeAudioContext;
var enableTickCallback = false;

function initWeb(mainPath, _bpm, _volume) {
  try {
    bpm = _bpm;
    volume = _volume;
    metronomeAudioContext = new (window.AudioContext)();
    metronomeAudioContext.suspend && metronomeAudioContext.suspend();
    setAudioFileWeb(mainPath);
  } catch (e) {
  }
}

function setAudioFileWeb(url) {
  var request = new XMLHttpRequest();
  request.open('GET', url, true);
  request.responseType = 'arraybuffer';
  request.onload = function () {
    metronomeAudioContext.decodeAudioData(request.response, function (buffer) {
      metronomeSoundBuffer = buffer;
    }, function (err) { log(err); });
  }
  request.send();
}

function schedule() {
  while (secondsPerBeat < metronomeAudioContext.currentTime + 0.1) {
    playNote(secondsPerBeat);
    nextNote();
  }
  timer = window.setTimeout(schedule, 0.1);
}

function nextNote() {
  secondsPerBeat += 60.0 / bpm;
  currentBeatInBar++;
}

function playNote(t) {
  if (currentBeatInBar == parseInt(takt, 10))
    currentBeatInBar = 0;
  if (metronomeAudioContext.state == 'suspended') {
    metronomeAudioContext.resume();
  }
  var source = metronomeAudioContext.createBufferSource();
  source.buffer = metronomeSoundBuffer;

  var gainNode = metronomeAudioContext.createGain();
  gainNode.gain.value = volume;
  source.connect(gainNode);
  gainNode.connect(metronomeAudioContext.destination);
  source.start(t);
  source.stop(t + 0.05);
}
function setVolumeWeb(vol) {
  volume = vol;
}
function setBPMWeb(val) {
  bpm = val;
}
function getBPMWeb() {
  return bpm;
}
function getVolumeWeb() {
  return volume;
}
function isPlayingWeb() {
  return isPlaying;
}
function playWeb() {
  isPlaying = true;
  var volumeTP = volume;
  volume = 0;
  metronomeAudioContext.resume && metronomeAudioContext.resume();
  secondsPerBeat = metronomeAudioContext.currentTime;
  currentBeatInBar = parseInt(takt, 10);
  schedule();
  volume = volumeTP;
}
function stopWeb() {
  isPlaying = false;
  window.clearInterval(timer);
  metronomeAudioContext.suspend();
  metronomeAudioContext.currentTime = 0;
}
function enableTickCallbackWeb() {
  enableTickCallback = true;
}