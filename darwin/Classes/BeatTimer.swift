class BeatTimer {
    private var eventTick: EventTickHandler
    
    init(eventTick: EventTickHandler) {
        self.eventTick = eventTick
    }
    private var beatTimer : Timer? = nil {
       willSet {
           beatTimer?.invalidate()
       }
    }
    func startBeatTimer(bpm: Int) {
        stopBeatTimer()
        let timerIntervallInSamples = 60 / Double(bpm)
//        var now1 = Date().timeIntervalSince1970
        beatTimer = Timer.scheduledTimer(withTimeInterval: timerIntervallInSamples, repeats: true) { timer in
//            let now2 = Date().timeIntervalSince1970
//            print("tick1:"+String(describing: timerIntervallInSamples)+",diff:"+String(describing: (now2-now1)))
//            now1 = now2
            self.eventTick.send(res: true)
        }
    }
    func stopBeatTimer() {
        guard beatTimer != nil else { return }
        beatTimer?.invalidate()
        beatTimer = nil
    }
}
