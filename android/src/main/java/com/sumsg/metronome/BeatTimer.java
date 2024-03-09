package com.sumsg.metronome;
import android.os.Handler;
import android.os.Looper;
public class BeatTimer {
    private EventTapHandler eventTap;
    private Handler handler;
    private Runnable beatRunnable;

    public void startBeatTimer(int bpm, EventTapHandler eventTapHandler) {
        eventTap = eventTapHandler;
        handler = new Handler(Looper.getMainLooper());
        double timerIntervalInSamples = 60 / (double) bpm;

        beatRunnable = new Runnable() {
            @Override
            public void run() {
                eventTap.send(true);
                handler.postDelayed(this, (long) (timerIntervalInSamples * 1000));
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
