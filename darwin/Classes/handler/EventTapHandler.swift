#if os(iOS)
import Flutter
#elseif os(macOS)
import FlutterMacOS
#endif
class EventTickHandler: NSObject,FlutterStreamHandler {
    private var eventSink: FlutterEventSink?
    
    public func send(res:Bool){
        if let event = eventSink {
            event(res)
        }
    }
    
    func onListen(withArguments arguments: Any?, eventSink events: @escaping FlutterEventSink) -> FlutterError? {
        // if let arguments = arguments {
        //     print("StreamHandler - onListen: \(arguments)")
        // }
        self.eventSink = events
        return nil
    }
    
    func onCancel(withArguments arguments: Any?) -> FlutterError? {
//        if let arguments = arguments {
//            print("StreamHandler - onCancel: \(arguments)")
//        }
        eventSink = nil
        return nil
    }
}
