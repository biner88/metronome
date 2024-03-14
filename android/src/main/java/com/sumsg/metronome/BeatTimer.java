package com.sumsg.metronome;
import android.os.Handler;
import android.os.Looper;

import io.flutter.plugin.common.EventChannel;

public class BeatTimer {
//    private final String TAG = "BeatTimer";
    private final EventChannel.EventSink eventTapSink;
    private Handler handler;
    private Runnable beatRunnable;
    BeatTimer(EventChannel.EventSink _eventTapSink){
        eventTapSink = _eventTapSink;
    }
    public void startBeatTimer(int bpm) {
        stopBeatTimer();
        handler = new Handler(Looper.getMainLooper());
        double timerIntervalInSamples = 60 / (double) bpm;
        beatRunnable = new Runnable() {
            @Override
            public void run() {
                handler.postDelayed(this, (long) (timerIntervalInSamples * 1000));
                eventTapSink.success(true);
            }
        };

        handler.post(beatRunnable);
    }

    public void stopBeatTimer() {
        if (handler != null && beatRunnable != null) {
            handler.removeCallbacks(beatRunnable);
            handler = null;
            beatRunnable = null;
        }
    }
}
