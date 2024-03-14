#if os(iOS)
import Flutter
#elseif os(macOS)
import FlutterMacOS
import Cocoa
#endif
public class MetronomePlugin: NSObject, FlutterPlugin {
    var channel:FlutterMethodChannel?
    var metronome:Metronome?
    //
    private let eventTickListener: EventTickHandler = EventTickHandler()
    private var eventTick: FlutterEventChannel?
    private var enableTickCallback:Bool = false
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
              let bpm: Int = (attributes?["bpm"] as? Int) ?? (metronome?.audioBpm)!
                  metronome?.play(bpm: bpm)
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
                  result(metronome?.getBPM ?? (metronome?.audioBpm)! )
                break;
              case "setAudioFile":
                  setAudioFile(attributes: attributes)
                break;
              case "destroy":
                  metronome?.destroy()
                break;
              case "enableTickCallback":
                enableTickCallback = true;
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
    private func metronomeInit( attributes:NSDictionary?) {
        let mainFilePath: String = (attributes?["path"] as? String) ?? ""
        let mainFileUrl = URL(fileURLWithPath: mainFilePath);
        if mainFilePath != "" {
            metronome =  Metronome( mainFile: mainFileUrl,accentedFile: mainFileUrl)
            if(enableTickCallback){
                metronome?.enableTickCallback(_eventTickSink: eventTickListener);
            }
            setVolume(attributes: attributes)
            setBPM(attributes: attributes)
        }
    }
    private func setAudioFile( attributes:NSDictionary?) {
        if metronome != nil {
            let mainFilePath: String = (attributes?["path"] as? String) ?? ""
            let mainFileUrl = URL(fileURLWithPath: mainFilePath);
            if mainFilePath != "" {
                metronome?.setAudioFile( mainFile: mainFileUrl)
            }
        }
    }
    private func setVolume( attributes:NSDictionary?) {
        if metronome != nil {
            let volume: Double = (attributes?["volume"] as? Double) ?? 0.5
            metronome?.setVolume(vol: Float(volume))
        }
    }
}
