import Flutter
import UIKit

public class MetronomePlugin: NSObject, FlutterPlugin {
    var metronome:Metronome?

    public static func register(with registrar: FlutterPluginRegistrar) {
      let channel = FlutterMethodChannel(name: "metronome", binaryMessenger: registrar.messenger())
      let instance = MetronomePlugin()
      registrar.addMethodCallDelegate(instance, channel: channel)
    }
    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
          let attributes = call.arguments as? NSDictionary
          switch call.method {
              case "init":
                  metronomeInit(attributes: attributes)
                  setVolume(attributes: attributes)
                  setBPM(attributes: attributes)
                break;
              case "play":
              let bpm: Double = (attributes?["bpm"] as? Double) ?? 120
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
      //  channel?.setMethodCallHandler(nil)
    }
    private func setBPM( attributes:NSDictionary?) {
        if metronome != nil {
            let bpm: Double = (attributes?["bpm"] as? Double) ?? 120
            metronome?.setBPM(bpm: bpm)
        }
    }
    private func metronomeInit( attributes:NSDictionary?) {
        let mainFilePath: String = (attributes?["path"] as? String) ?? ""
        let mainFileUrl = URL(fileURLWithPath: mainFilePath);
        if mainFilePath != "" {
            metronome =  Metronome( mainFile: mainFileUrl)
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
            let volume1: Float = Float(volume)
            metronome?.setVolume(vol: volume1)
        }
    }
}
