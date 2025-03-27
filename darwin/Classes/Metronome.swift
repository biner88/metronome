import AVFoundation

class Metronome {
    private var eventTick: EventTickHandler?
    private var audioPlayerNode: AVAudioPlayerNode = AVAudioPlayerNode()
    private var audioEngine: AVAudioEngine = AVAudioEngine()
    private var mixerNode: AVAudioMixerNode
    private var audioBuffer: AVAudioPCMBuffer?
    //
    private var audioFileMain: AVAudioFile
    private var audioFileAccented: AVAudioFile
    public var audioBpm: Int = 120
    public var audioVolume: Float = 0.5
    public var audioTimeSignature: Int = 0

    private var sampleRate: Int = 44100
    private var timer: DispatchSourceTimer?
    private var startTime: AVAudioTime?
    /// Initialize the metronome with the main and accented audio files.
    init(mainFileBytes: Data, accentedFileBytes: Data, bpm: Int, timeSignature: Int = 0, volume: Float, sampleRate: Int) {
        self.sampleRate = sampleRate
        audioTimeSignature = timeSignature
        audioBpm = bpm
        audioVolume = volume
        // Initialize audio files
        audioFileMain = try! AVAudioFile(fromData: mainFileBytes)
        if accentedFileBytes.isEmpty {
            audioFileAccented = audioFileMain
        }else{
            audioFileAccented = try! AVAudioFile(fromData: accentedFileBytes)
        }
        // Initialize audio engine and player node
        audioEngine.attach(audioPlayerNode)
        // Set up mixer node
        mixerNode = audioEngine.mainMixerNode
        mixerNode.outputVolume = audioVolume
        // Connect nodes
        audioEngine.connect(audioPlayerNode, to: mixerNode, format: audioFileMain.processingFormat)
        audioEngine.prepare()
        // Start the audio engine
        if !self.audioEngine.isRunning {
            do {
                try self.audioEngine.start()
            } catch {
                print("Failed to start audio engine: \(error.localizedDescription)")
            }
        }
        // Set volume
        setVolume(volume:volume)
    }
    /// Start the metronome.
    func play() {
       audioBuffer = generateBuffer()
    }

    /// Pause the metronome.
    func pause() {
        stop()
    }
    
    /// Stop the metronome.
    func stop() {
        if audioBuffer != nil {
            audioBuffer?.frameLength = 0
            self.audioPlayerNode.scheduleBuffer(audioBuffer!, at: nil, options: .interruptsAtLoop, completionHandler: nil)
        }
        audioPlayerNode.stop()
        stopBeatTimer()
    }
    
    /// Set the BPM of the metronome.
    func setBPM(bpm: Int) {
        if audioBpm != bpm {
            audioBpm = bpm
            if isPlaying {
                pause()
                play()
            }
        }
    }
    ///Set the TimeSignature of the metronome.
    func setTimeSignature(timeSignature: Int) {
        if audioTimeSignature != timeSignature {
            audioTimeSignature = timeSignature
            if isPlaying {
                pause()
                play()
            }
        }
       
    }
    
    func setAudioFile(mainFileBytes: Data, accentedFileBytes: Data) {
        if !mainFileBytes.isEmpty {
            audioFileMain = try! AVAudioFile(fromData: mainFileBytes)
        }
        if !accentedFileBytes.isEmpty {
            audioFileAccented = try! AVAudioFile(fromData: accentedFileBytes)
        }
        if !mainFileBytes.isEmpty || !accentedFileBytes.isEmpty {
            if isPlaying {
                pause()
                play()
            }
        }
    }
    
    var getTimeSignature: Int {
        return audioTimeSignature
    }
    
    var getVolume: Int {
        return Int(audioVolume * 100)
    }
    
    func setVolume(volume: Float) {
        audioVolume = volume
        mixerNode.outputVolume = volume
    }
    
    var isPlaying: Bool {
        return audioPlayerNode.isPlaying
    }
    
    /// Enable the tick callback.
    public func enableTickCallback(_eventTickSink: EventTickHandler) {
        self.eventTick = _eventTickSink
    }
    
    /// Enable the Audio Session
    public func enableAudioSession() {
#if os(iOS)
        do {
            let session = AVAudioSession.sharedInstance()
            try session.setCategory(.playAndRecord, options: [.defaultToSpeaker, .allowAirPlay, .allowBluetoothA2DP])
            try session.setActive(true)
        } catch {
            print("Failed to set audio session category: \(error)")
        }
        UIApplication.shared.beginReceivingRemoteControlEvents()
#endif
    }
    /// Generate buffer with accents based on time signature
    private func generateBuffer() -> AVAudioPCMBuffer {
       
        audioFileMain.framePosition = 0
        audioFileAccented.framePosition = 0

        let beatLength = AVAudioFrameCount(Double(self.sampleRate) * 60 / Double(self.audioBpm))
        // let beatLength = AVAudioFrameCount(audioFileMain.processingFormat.sampleRate * 60 / Double(self.audioBpm))
        let bufferMainClick = AVAudioPCMBuffer(pcmFormat: audioFileMain.processingFormat, frameCapacity: beatLength)!
        try! audioFileMain.read(into: bufferMainClick)
        bufferMainClick.frameLength = beatLength

        let bufferBar: AVAudioPCMBuffer
        if self.audioTimeSignature < 2 {
            bufferBar = AVAudioPCMBuffer(pcmFormat: audioFileMain.processingFormat, frameCapacity: beatLength)!
            bufferBar.frameLength = beatLength

            let channelCount = Int(audioFileMain.processingFormat.channelCount)
            let mainClickArray = Array(UnsafeBufferPointer(start: bufferMainClick.floatChannelData![0], count: channelCount * Int(beatLength)))

            bufferBar.floatChannelData!.pointee.update(from: mainClickArray, count: channelCount * Int(bufferBar.frameLength))
        } else {
            let bufferAccentedClick = AVAudioPCMBuffer(pcmFormat: audioFileAccented.processingFormat, frameCapacity: beatLength)!
            try! audioFileAccented.read(into: bufferAccentedClick)
            bufferAccentedClick.frameLength = beatLength

            bufferBar = AVAudioPCMBuffer(pcmFormat: audioFileMain.processingFormat, frameCapacity: beatLength * AVAudioFrameCount(self.audioTimeSignature))!
            bufferBar.frameLength = beatLength * AVAudioFrameCount(self.audioTimeSignature)

            let channelCount = Int(audioFileMain.processingFormat.channelCount)
            let mainClickArray = Array(UnsafeBufferPointer(start: bufferMainClick.floatChannelData![0], count: channelCount * Int(beatLength)))
            let accentedClickArray = Array(UnsafeBufferPointer(start: bufferAccentedClick.floatChannelData![0], count: channelCount * Int(beatLength)))

            var barArray = [Float]()
            for i in 0..<self.audioTimeSignature {
                if i == 0 {
                    barArray.append(contentsOf: accentedClickArray)
                } else {
                    barArray.append(contentsOf: mainClickArray)
                }
            }

            bufferBar.floatChannelData!.pointee.update(from: barArray, count: channelCount * Int(bufferBar.frameLength))
        }
        //
        self.startTime = self.audioPlayerNode.lastRenderTime
        self.audioPlayerNode.scheduleBuffer(bufferBar, at: nil, options: .loops,completionHandler: nil)
        self.audioPlayerNode.play()
        startBeatTimer()
        return bufferBar
    }
    
    func stopBeatTimer() {
        if timer != nil {
            timer?.cancel()
            timer = nil
        }
    }
    
    private func startBeatTimer() {
        if self.eventTick == nil {return}
        let beatDuration = 60.0 / Double(audioBpm)
        timer?.cancel()
        timer = DispatchSource.makeTimerSource(queue: DispatchQueue.global(qos: .background))
        timer?.schedule(deadline: .now(), repeating: beatDuration, leeway: .milliseconds(10))
        timer?.setEventHandler { [weak self] in
            guard let self = self else { return }
            guard let startTime = self.startTime,
                  let currentTime = self.audioPlayerNode.lastRenderTime,
                  let elapsedTime = self.getElapsedTime(from: startTime, to: currentTime) else { return }

            let currentBeat = Int(elapsedTime / beatDuration)
            let currentTick = (self.audioTimeSignature > 1) ? (currentBeat % self.audioTimeSignature) : 0

            DispatchQueue.main.async {
                self.eventTick?.send(res: currentTick)
            }
        }

        timer?.resume()
    }
    
    private func getElapsedTime(from startTime: AVAudioTime, to currentTime: AVAudioTime) -> TimeInterval? {
//        guard let sampleRate = startTime.sampleRate as Double? else { return nil }
        let elapsedSamples = currentTime.sampleTime - startTime.sampleTime
        return Double(elapsedSamples) / Double(self.sampleRate)
    }

    func destroy() {
        audioPlayerNode.reset()
        audioPlayerNode.stop()
        audioEngine.reset()
        audioEngine.stop()
        audioEngine.detach(audioPlayerNode)
        audioBuffer = nil
        stopBeatTimer()
    }
}
extension AVAudioFile {
    convenience init(fromData data: Data) throws {
        let tempURL = URL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent(UUID().uuidString + ".wav")
        do {
            try data.write(to: tempURL)
            //print("Temporary file created at: \(tempURL)")
        } catch {
            //print("Failed to write data to temporary file: \(error.localizedDescription)")
            throw error
        }
        do {
            try self.init(forReading: tempURL)
        } catch {
            //print("Failed to initialize AVAudioFile: \(error.localizedDescription)")
            throw error
        }
    }
}
