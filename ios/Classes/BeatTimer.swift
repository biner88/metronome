//
//  BeatTimer.swift
//  metronome
//
//  Created by xsonic on 2024/3/7.
//

class BeatTimer {
    private var beatTimer : Timer? = nil {
       willSet {
           beatTimer?.invalidate()
       }
    }
    func startBeatTimer(bpm: Double) {
        stopBeatTimer()
        guard self.beatTimer == nil else { return }
        beatTimer = Timer.scheduledTimer(withTimeInterval: 60 / bpm, repeats: true) { timer in
            print("tick1")
        }
    }
    func stopBeatTimer() {
        guard beatTimer != nil else { return }
        beatTimer?.invalidate()
        beatTimer = nil
    }
}
