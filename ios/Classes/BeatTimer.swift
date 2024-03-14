class BeatTimer {
    private var eventTap: EventTapHandler
    private var enableTapCallback:Bool
    
    init(eventTap: EventTapHandler, _enableTapCallback: Bool = false) {
        self.eventTap = eventTap
        self.enableTapCallback = _enableTapCallback
    }
    private var beatTimer : Timer? = nil {
       willSet {
           beatTimer?.invalidate()
       }
    }
    func startBeatTimer(bpm: Int) {
        if (!self.enableTapCallback) {return}
        stopBeatTimer()
        let timerIntervallInSamples = 60 / Double(bpm)
//        var now1 = Date().timeIntervalSince1970
        beatTimer = Timer.scheduledTimer(withTimeInterval: timerIntervallInSamples, repeats: true) { timer in
//            let now2 = Date().timeIntervalSince1970
//            print("tick1:"+String(describing: timerIntervallInSamples)+",diff:"+String(describing: (now2-now1)))
//            now1 = now2
            self.eventTap.send(res: true)
        }
    }
    func stopBeatTimer() {
        guard beatTimer != nil else { return }
        beatTimer?.invalidate()
        beatTimer = nil
    }
}
