package com.sumsg.metronome;
import android.content.Context;
import android.media.AudioFormat;
import android.media.AudioManager;
import android.media.AudioTrack;
import android.os.Build;

import java.io.BufferedInputStream;
import java.io.DataInputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;

public class AudioGenerator {
	
    private final int sampleRate;
    private AudioTrack audioTrack;
//    private AudioManager audioManager;
    public AudioGenerator(int sampleRate) {
    	this.sampleRate = sampleRate;
    }
    public void createPlayer(Context context){
        audioTrack = new AudioTrack(AudioManager.STREAM_MUSIC,
                sampleRate, AudioFormat.CHANNEL_OUT_MONO,
                AudioFormat.ENCODING_PCM_16BIT, sampleRate,
                AudioTrack.MODE_STREAM);
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.LOLLIPOP) {
            audioTrack.setVolume(0.5F);
        }
        audioTrack.play();
    }
    public void writeSound(short[] sound) {
        if (audioTrack.getState() == AudioTrack.STATE_INITIALIZED ) {
            audioTrack.write(sound, 0, sound.length);
        }
    }

    public void writeSound(short[] sound, final int length) {
        if (audioTrack.getState() == AudioTrack.STATE_INITIALIZED ) {
            audioTrack.write(sound, 0, length);
        }
    }
    
    public void destroyAudioTrack() {
    	audioTrack.stop();
    	audioTrack.release();
    }

    public AudioTrack getAudioTrack() {
        return audioTrack;
    }
    public static SampleDataShort loadSampleFromWav(final String mainFilePath) {
        final int WAV_FILE_HEADER_BYTE_SIZE = 44;
        short[] audio = null;
        try {
            File file = new File(mainFilePath);
            long fileLength = file.length();
            FileInputStream is = new FileInputStream(file);

            audio = new short[((int) fileLength - WAV_FILE_HEADER_BYTE_SIZE) / 2];
            BufferedInputStream bis = new BufferedInputStream(is);
            DataInputStream dis = new DataInputStream(bis);
            int writeIndex = 0;
            int i = 0;
            while (dis.available() > 0) {
                if (i < WAV_FILE_HEADER_BYTE_SIZE) {
                    i++;
                    dis.readByte();
                    continue;
                }
                byte byte1 = dis.readByte();
                byte byte2 = dis.readByte();
                int low = (byte1 & 0xff);
                int high = byte2 & 0xff;
                short data = (short) (high << 8 | low);
                audio[writeIndex] = data;
                writeIndex++;
            }

            dis.close();
        } catch (IOException e) {
            e.printStackTrace();
        }

        return new SampleDataShort(audio);
    }
    public static class SampleDataShort implements Sample {
        short[] sample;
        int sampleCount;
        public SampleDataShort(short[] samp) {
            sample = samp;
            sampleCount = sample.length;
        }
        @Override
        public int getSampleCount() {
            return sampleCount;
        }
        @Override
        public Object getSample() {
            return sample;
        }
    }

    public interface Sample {
        int getSampleCount();
        Object getSample();
    }
}
