package com.sumsg.metronome;
import android.os.Handler;
import android.os.Looper;

import io.flutter.plugin.common.EventChannel;

public class BeatTimer {
//    private final String TAG = "BeatTimer";
    private final EventChannel.EventSink eventTapSink;
    private Handler handler;
    private Runnable beatRunnable;
    private final boolean enable;
    BeatTimer(EventChannel.EventSink _eventTapSink,boolean _enable){
        eventTapSink = _eventTapSink;
        enable = _enable;
    }
    public void startBeatTimer(int bpm) {
        if (!enable) return;
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
