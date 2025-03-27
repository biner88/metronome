#ifndef METRONOME_H_
#define METRONOME_H_

#include <vector>
#include <atomic>
#include <thread>
#include <cstdint>
#include <windows.h>
#include <mmsystem.h>
#pragma comment(lib, "winmm.lib")
//
#include <windows.h>
#include <mmsystem.h>
#include <cmath>
#include <mutex>
#include <condition_variable>
#include <flutter/event_sink.h>
#include <flutter/encodable_value.h>
class Metronome
{
public:
    Metronome(const std::vector<uint8_t> &mainFileBytes,
              const std::vector<uint8_t> &accentedFileBytes,
              int bpm, int timeSignature, double volume, int sampleRate);
    ~Metronome();

    void Play();
    void Pause();
    void Stop();
    void SetBPM(int bpm);
    void SetTimeSignature(int timeSignature);
    void SetVolume(double volume);
    void SetAudioFile(const std::vector<uint8_t> &mainFileBytes, const std::vector<uint8_t> &accentedSound);
    void EnableTickCallback(std::shared_ptr<flutter::EventSink<flutter::EncodableValue>> eventSink);
    bool IsPlaying() const;
    void Destroy();
    int Metronome::GetVolume() const;
    int audioBpm = 120;
    int audioTimeSignature = 4;

private:
    void StartMetronome();
    void InitializeAudio();
    void OnBufferDone();
    void PlaySound();
    std::shared_ptr<flutter::EventSink<flutter::EncodableValue>> eventTickSink;
    std::vector<int16_t> Metronome::byteArrayToShortArray(const std::vector<uint8_t> &byteArray);
    std::vector<int16_t> Metronome::generateBuffer();
    static void CALLBACK WaveOutProc(HWAVEOUT hwo, UINT uMsg, DWORD_PTR dwInstance, DWORD_PTR dwParam1, DWORD_PTR dwParam2);
    HWAVEOUT hWaveOut;
    size_t playCursor;
    size_t writeCursor;
    std::mutex bufferMutex;
    std::condition_variable bufferCV;
    std::mutex paramMutex;
    int currentTick = 0;
    //
    std::vector<int16_t> audioBufferTemp;
    std::vector<int16_t> audioBuffer;
    std::vector<int16_t> mainSound;
    std::vector<int16_t> accentedSound;
    int sampleRate = 44100;
    int beatLength = 0;
    double audioVolume = 1.0;
    std::atomic<bool> playing{false};
    std::thread metronomeThread;
};

#endif // METRONOME_H_