package com.sumsg.metronome;

import android.content.Context;
import android.os.Build;
import android.util.Log;

import io.flutter.plugin.common.EventChannel;

public class Metronome {
    private final Object mLock = new Object();
    private int mBpm = 120;
    private static final int SAMPLE_RATE = 44100;
    private boolean play = false;
    private final AudioGenerator audioGenerator = new AudioGenerator(SAMPLE_RATE);
    private short[] mTookSilenceSoundArray;
    private AudioGenerator.Sample mTook;
    private int mBeatDivisionSampleCount;
    private float volume= (float) 0.5;
    private final Context context;
    private final BeatTimer beatTimer;
    public Metronome(Context ctx,EventChannel.EventSink _eventTapSink,boolean enableTapCallback) {
        context = ctx;
        beatTimer = new BeatTimer(_eventTapSink,enableTapCallback);
    }

    public void setAudioFile(String path) {
        mTook = AudioGenerator.loadSampleFromWav(path);
    }

    public void calcSilence() {
        //(beats per second * SAMPLE_RATE) - NumberOfSamples
        mBeatDivisionSampleCount = (int) (((60 / (float) mBpm) * SAMPLE_RATE));
        int silence = Math.max(mBeatDivisionSampleCount - mTook.getSampleCount(), 0);
        mTookSilenceSoundArray = new short[silence];

        for (int i = 0; i < silence; i++)
            mTookSilenceSoundArray[i] = 0;
    }

    private void isInitialized() {
        if (mTook == null ) {
            throw new IllegalStateException("Not initialized correctly");
        }
    }

    public void play(int bpm) {
        isInitialized();
        setBPM(bpm);
        play = true;
        audioGenerator.createPlayer(context);
        setVolume(volume);
        calcSilence();
        new Thread(() -> {
            do {
                short[] sample = (short[]) mTook.getSample();
                audioGenerator.writeSound(sample, Math.min(sample.length, mBeatDivisionSampleCount));
                audioGenerator.writeSound(mTookSilenceSoundArray);
                synchronized (mLock) {
                    if (!play) return;
                }
            } while (true);
        }).start();
        //
        beatTimer.startBeatTimer(bpm);
    }
    public void pause() {
        if (audioGenerator.getAudioTrack()!=null){
            play = false;
            audioGenerator.getAudioTrack().pause();
            beatTimer.stopBeatTimer();
        }
    }
    public void stop() {
        if (audioGenerator.getAudioTrack()!=null){
            play = false;
            audioGenerator.getAudioTrack().stop();
            beatTimer.stopBeatTimer();
        }
    }
    public int getVolume() {
        return (int) (volume * 100);
    }
    public void setVolume(float val) {
        if (audioGenerator.getAudioTrack()!=null){
            volume = val;
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.LOLLIPOP ) {
                try {
                    audioGenerator.getAudioTrack().setVolume(volume);
                }catch(Exception e) {
                    Log.e("setVolume", String.valueOf(e));
                }
            }
        }
    }
    public void setBPM(int bpm) {
        mBpm = bpm;
        calcSilence();
        beatTimer.startBeatTimer(bpm);
    }
    public double getBPM() {
        return mBpm;
    }
    public boolean isPlaying() {
        return play;
    }
    public void destroy() {
        if (!play) return;
        stop();
        synchronized (mLock) {
            mBeatDivisionSampleCount = 0;
        }
    }
}
