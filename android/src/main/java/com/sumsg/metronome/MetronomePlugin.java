package com.sumsg.metronome;

import android.content.Context;
import androidx.annotation.NonNull;
import java.util.Objects;
import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;

/** MetronomePlugin */
public class MetronomePlugin implements FlutterPlugin, MethodCallHandler {
  /// The MethodChannel that will the communication between Flutter and native Android
  ///
  /// This local reference serves to register the plugin with the Flutter Engine and unregister it
  /// when the Flutter Engine is detached from the Activity
  private MethodChannel channel;
  private String TAG = "metronome";
  /// Metronome
  private Metronome metronome;
  private Context applicationContext;
  @Override
  public void onAttachedToEngine(@NonNull FlutterPluginBinding flutterPluginBinding) {
    channel = new MethodChannel(flutterPluginBinding.getBinaryMessenger(), "metronome");
    channel.setMethodCallHandler(this);
    applicationContext = flutterPluginBinding.getApplicationContext();
  }
  @Override
  public void onMethodCall(@NonNull MethodCall call, @NonNull Result result) {
    switch (call.method) {
      case "init":
        metronomeInit(call.argument("path"));
        setVolume(call.argument("volume"));
        setBPM(call.argument("bpm"));
        break;
      case "play":
        double bpm = call.argument("bpm");
        metronome.play(bpm);
        break;
      case "pause":
        metronome.pause();
        break;
      case "stop":
        metronome.stop();
        break;
      case "getVolume":
        result.success(metronome.getVolume());
        break;
      case "setVolume":
        setVolume(call.argument("volume") );
        break;
      case "isPlaying":
        result.success(metronome.isPlaying());
        break;
      case "setBPM":
        setBPM(call.argument("bpm"));
        break;  
      case "setAudioFile":
        setAudioFile(call.argument("path"));
        break;
      case "destroy":
        metronome.destroy();
        break;

      default:
        result.notImplemented();
        break;
    }
  }

  @Override
  public void onDetachedFromEngine(@NonNull FlutterPluginBinding binding) {
    channel.setMethodCallHandler(null);
  }
  private void metronomeInit(String path){
    if (!Objects.equals(path, "")){
      metronome = new Metronome(applicationContext);
      metronome.setAudioFile(path);
    }
  }
  private void setVolume(double volume){
    if (metronome!=null){
      float _volume = (float) (volume);
      metronome.setVolume(_volume);
    }
  }
  private void setBPM(double bpm){
    if (metronome!=null){
      metronome.setBPM(bpm);
    }
  }
  private void setAudioFile(String path){
    if (metronome!=null){
      metronome.setAudioFile(path);
    }
  }
}
