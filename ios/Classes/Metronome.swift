
import AVFoundation

class Metronome {
    private var beatTimer:BeatTimer
    //
    private var audioPlayerNode: AVAudioPlayerNode
    private var audioFileMain: AVAudioFile
    private var audioEngine: AVAudioEngine
    private var mixerNode: AVAudioMixerNode
    //var
    public var audioBpm: Double = 120
    public var audioVolume: Float = 0.5
    //
    private var eventTap: EventTapHandler
    
    init(mainFile: URL,accentedFile: URL,eventTapHandler: EventTapHandler) {
        beatTimer = BeatTimer()
        eventTap = eventTapHandler
        //
        audioFileMain = try! AVAudioFile(forReading: mainFile)
        audioPlayerNode = AVAudioPlayerNode()
        
        audioEngine = AVAudioEngine()
        audioEngine.attach(self.audioPlayerNode)
        
        mixerNode = audioEngine.mainMixerNode
        mixerNode.outputVolume = audioVolume
        
        audioEngine.connect(audioPlayerNode, to: mixerNode, format: audioFileMain.processingFormat)
        audioEngine.prepare()

        if !self.audioEngine.isRunning {
            do {
                try self.audioEngine.start()
            } catch {
                print(error)
            }
        }

        let session = AVAudioSession.sharedInstance()
        do {
            try session.setActive(true)
            try session.overrideOutputAudioPort(AVAudioSession.PortOverride.speaker)
            try session.setCategory(AVAudioSession.Category.playback)
        } catch {
            print(error)
        }
        UIApplication.shared.beginReceivingRemoteControlEvents()
    }

    private func generateBuffer(bpm: Double) -> AVAudioPCMBuffer {

        audioFileMain.framePosition = 0
        let beatLength = AVAudioFrameCount(audioFileMain.processingFormat.sampleRate * 60 / bpm)
        let bufferMainClick = AVAudioPCMBuffer(pcmFormat: audioFileMain.processingFormat,
                                               frameCapacity: beatLength)!
        try! audioFileMain.read(into: bufferMainClick)
        bufferMainClick.frameLength = beatLength
        let bufferBar = AVAudioPCMBuffer(pcmFormat: audioFileMain.processingFormat,
                                         frameCapacity:  beatLength)!
//        bufferBar.frameLength = 4 * beatLength
        bufferBar.frameLength = beatLength

        // don't forget if we have two or more channels then we have to multiply memory pointee at channels count
        let channelCount = Int(audioFileMain.processingFormat.channelCount)
        let mainClickArray = Array(
            UnsafeBufferPointer(start: bufferMainClick.floatChannelData![0],
                                count: channelCount * Int(beatLength))
        )

        var barArray = [Float]()
            barArray.append(contentsOf: mainClickArray)
        bufferBar.floatChannelData!.pointee.update(from: barArray,
                                                   count: channelCount * Int(bufferBar.frameLength))
        return bufferBar
    }
    func play(bpm: Double) {
        audioBpm = bpm
        let buffer = generateBuffer(bpm: bpm)

        if audioPlayerNode.isPlaying {
            audioPlayerNode.scheduleBuffer(buffer, at: nil, options: .interruptsAtLoop, completionHandler: nil)
        } else {
            self.audioPlayerNode.play()
        }

        self.audioPlayerNode.scheduleBuffer(buffer, at: nil, options: .loops, completionHandler: nil)
        //
        beatTimer.startBeatTimer(bpm: bpm, eventTapHandler: eventTap)
    }
    func pause() {
        audioPlayerNode.pause()
        beatTimer.stopBeatTimer()
    }
    func stop() {
        audioPlayerNode.stop()
        beatTimer.stopBeatTimer()
    }
    func setBPM(bpm: Double) {
        audioBpm = bpm
        if audioPlayerNode.isPlaying {
            play(bpm: self.audioBpm)
        }
    }
    var getBPM: Double {
        return audioBpm;
    }
    var getVolume: Int {
        return Int(audioVolume * 100);
    }
    func setVolume(vol: Float) {
        audioVolume = vol
        mixerNode.outputVolume = vol
    }
    var isPlaying: Bool {
        return audioPlayerNode.isPlaying
    }
    func destroy() {
        audioPlayerNode.reset()
        audioPlayerNode.stop()
        audioEngine.reset()
        audioEngine.stop()
        audioEngine.detach(audioPlayerNode)
        beatTimer.stopBeatTimer()
    }
    func setAudioFile(mainFile: URL) {
        audioFileMain = try! AVAudioFile(forReading: mainFile)
        if isPlaying {
            stop()
            play(bpm: audioBpm)
        }
    }
}
