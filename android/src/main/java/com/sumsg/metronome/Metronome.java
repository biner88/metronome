package com.sumsg.metronome;

import android.content.Context;
import android.os.Build;
import android.util.Log;

public class Metronome {

    private final Object mLock = new Object();
    private double mBpm = 120;
    private static final int SAMPLE_RATE = 44100;
    private boolean play = false;
    private final AudioGenerator audioGenerator = new AudioGenerator(SAMPLE_RATE);
    private short[] mTookSilenceSoundArray;
    private AudioGenerator.Sample mTook;
    private int mBeatDivisionSampleCount;
    private float volume= (float) 1.0F;
    private final Context context;
    public Metronome(Context ctx) {
        context = ctx;
    }

    public void setAudioFile(String path) {
        mTook = AudioGenerator.loadSampleFromWav(path);
    }

    public void calcSilence() {
        //(beats per second * SAMPLE_RATE) - NumberOfSamples
        mBeatDivisionSampleCount = (int) (((60 / mBpm) * SAMPLE_RATE));

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

    public void play(double bpm) {
        isInitialized();
        setBPM(bpm);
        play = true;
        audioGenerator.createPlayer(context);
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
    }

    public void stop() {
        play = false;
        audioGenerator.destroyAudioTrack();
    }
    public float getVolume() {
        return volume;
    }
    public void setVolume(float val) {
        volume = val;
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.LOLLIPOP ) {
            try {
                audioGenerator.getAudioTrack().setVolume(val);
            }catch(Exception e) {
                // Log.e("setVolume", String.valueOf(e));
            }
        }
    }
    public void setBPM(double bpm) {
        mBpm = bpm;
        calcSilence();
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
