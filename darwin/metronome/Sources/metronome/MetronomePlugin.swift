#if os(iOS)
import Flutter
#elseif os(macOS)
import FlutterMacOS
// import Cocoa
#endif
public class MetronomePlugin: NSObject, FlutterPlugin {
    var channel:FlutterMethodChannel?
    var metronome:Metronome?
    //
    private let eventTickListener: EventTickHandler = EventTickHandler()
    private var eventTick: FlutterEventChannel?
    //
    init(with registrar: FlutterPluginRegistrar) {}
    //
    public static func register(with registrar: FlutterPluginRegistrar) {
        let instance = MetronomePlugin(with: registrar)
#if os(iOS)
    let messenger = registrar.messenger()
#else
    let messenger = registrar.messenger
#endif
        instance.channel = FlutterMethodChannel(name: "metronome", binaryMessenger: messenger)

        registrar.addApplicationDelegate(instance)
        registrar.addMethodCallDelegate(instance, channel: instance.channel!)
        //
        instance.eventTick = FlutterEventChannel(name: "metronome_tick", binaryMessenger: messenger)
        instance.eventTick?.setStreamHandler(instance.eventTickListener )
    }
    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
          let attributes = call.arguments as? NSDictionary
          switch call.method {
              case "init":
                  metronomeInit(attributes: attributes)
                break;
              case "play":
                  metronome?.play()
                break;
              case "pause":
                  metronome?.pause()
                break;
              case "stop":
                  metronome?.stop()
                break;
              case "getVolume":
                  result(metronome?.getVolume)
                break;
              case "setVolume":
                  setVolume(attributes: attributes)
                break;
              case "isPlaying":
                  result(metronome?.isPlaying)
                break;
              case "setBPM":
                  setBPM(attributes: attributes)
                break;
              case "getBPM":
                  result(metronome?.audioBpm)
                break;
              case "setTimeSignature":
                  setTimeSignature(attributes: attributes)
                break;
              case "getTimeSignature":
                  result(metronome?.audioTimeSignature)
                break;
              case "setAudioFile":
                  setAudioFile(attributes: attributes)
                break;
              case "destroy":
                  metronome?.destroy()
                break;
              default:
                  result("unkown")
                break;
        }
    }
    public func detachFromEngine(for registrar: FlutterPluginRegistrar) {
        channel?.setMethodCallHandler(nil)
        eventTick?.setStreamHandler(nil)
    }
    private func setBPM( attributes:NSDictionary?) {
        if metronome != nil {
            let bpm: Int = (attributes?["bpm"] as? Int) ?? 120
            metronome?.setBPM(bpm: bpm)
        }
    }
    private func setTimeSignature( attributes:NSDictionary?) {
        if metronome != nil {
            let timeSignature: Int = (attributes?["timeSignature"] as? Int) ?? 0
            metronome?.setTimeSignature(timeSignature: timeSignature)
        }
    }
    private func metronomeInit( attributes:NSDictionary?) {
        let mainFileBytes = (attributes?["mainFileBytes"] as? FlutterStandardTypedData) ?? FlutterStandardTypedData()
        let accentedFileBytes = (attributes?["accentedFileBytes"] as? FlutterStandardTypedData) ?? FlutterStandardTypedData()
        let mainBytes: Data = mainFileBytes.data
        let accentedBytes: Data = accentedFileBytes.data
        
        let enableTickCallback: Bool = (attributes?["enableTickCallback"] as? Bool) ?? true
        let timeSignature: Int = (attributes?["timeSignature"] as? Int) ?? 0
        let bpm: Int = (attributes?["bpm"] as? Int) ?? 120
        let volume: Float = (attributes?["volume"] as? Float) ?? 0.5
        let sampleRate: Int = (attributes?["sampleRate"] as? Int) ?? 44100
        metronome =  Metronome( mainFileBytes:mainBytes,accentedFileBytes: accentedBytes,bpm:bpm,timeSignature:timeSignature,volume:volume,sampleRate:sampleRate)
        if(enableTickCallback){
            metronome?.enableTickCallback(_eventTickSink: eventTickListener);
        }
    }
    private func setAudioFile( attributes:NSDictionary?) {
        if metronome != nil {
            let mainFileBytes = (attributes?["mainFileBytes"] as? FlutterStandardTypedData) ?? FlutterStandardTypedData()
            let accentedFileBytes = (attributes?["accentedFileBytes"] as? FlutterStandardTypedData) ?? FlutterStandardTypedData()
            let mainBytes: Data = mainFileBytes.data
            let accentedBytes: Data = accentedFileBytes.data
            metronome?.setAudioFile( mainFileBytes:mainBytes,accentedFileBytes: accentedBytes)
        }
    }
    private func setVolume( attributes:NSDictionary?) {
        if metronome != nil {
            let volume: Double = (attributes?["volume"] as? Double) ?? 0.5
            metronome?.setVolume(volume: Float(volume))
        }
    }
}
