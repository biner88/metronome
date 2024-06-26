package com.sumsg.metronome;

import android.os.Handler;
import android.os.Looper;
import io.flutter.plugin.common.EventChannel;

public class BeatTimer {
    // private final String TAG = "BeatTimer";
    private final EventChannel.EventSink eventTickSink;
    private Handler handler;
    private Runnable beatRunnable;

    BeatTimer(EventChannel.EventSink _eventTickSink) {
        eventTickSink = _eventTickSink;
    }

    public void startBeatTimer(int bpm) {
        stopBeatTimer();
        handler = new Handler(Looper.getMainLooper());
        double timerIntervalInSamples = 60 / (double) bpm;
        if (eventTickSink!=null){
            beatRunnable = new Runnable() {
                @Override
                public void run() {
                    eventTickSink.success(true);
                    handler.postDelayed(this, (long) (timerIntervalInSamples * 1000));
                }
            };

            handler.post(beatRunnable);
        }
    }

    public void stopBeatTimer() {
        if (handler != null && beatRunnable != null) {
            handler.removeCallbacks(beatRunnable);
            handler = null;
            beatRunnable = null;
        }
    }
}
