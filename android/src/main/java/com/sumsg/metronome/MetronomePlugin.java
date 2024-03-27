package com.sumsg.metronome;

import android.content.Context;

import androidx.annotation.NonNull;
import java.util.Objects;
import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.plugin.common.EventChannel;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;

/** MetronomePlugin */
public class MetronomePlugin implements FlutterPlugin, MethodCallHandler {
  /// The MethodChannel that will the communication between Flutter and native
  /// Android
  ///
  /// This local reference serves to register the plugin with the Flutter Engine
  /// and unregister it
  /// when the Flutter Engine is detached from the Activity
  private MethodChannel channel;
  //
  private EventChannel eventTick;
  private EventChannel.EventSink eventTickSink;
  // private final String TAG = "metronome";
  /// Metronome
  private Metronome metronome;
  private Context context;
  private boolean enableTickCallback = false;

  @Override
  public void onAttachedToEngine(@NonNull FlutterPluginBinding flutterPluginBinding) {
    channel = new MethodChannel(flutterPluginBinding.getBinaryMessenger(), "metronome");
    channel.setMethodCallHandler(this);
    context = flutterPluginBinding.getApplicationContext();
    //
    eventTick = new EventChannel(flutterPluginBinding.getBinaryMessenger(),
        "metronome_tick");
    eventTick.setStreamHandler(new EventChannel.StreamHandler() {
      @Override
      public void onListen(Object args, EventChannel.EventSink events) {
        eventTickSink = events;
      }

      @Override
      public void onCancel(Object args) {
        eventTickSink = null;
      }
    });
  }

  @Override
  public void onMethodCall(@NonNull MethodCall call, @NonNull Result result) {
    switch (call.method) {
      case "init":
        metronomeInit(call);
        break;
      case "play":
        Integer _bpm = call.argument("bpm");
        if (_bpm == null)
          _bpm = 120;
        metronome.play(_bpm);
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
        setVolume(call);
        break;
      case "isPlaying":
        result.success(metronome.isPlaying());
        break;
      case "setBPM":
        setBPM(call);
        break;
      case "getBPM":
        result.success(metronome.getBPM());
        break;
      case "setAudioFile":
        setAudioFile(call);
        break;
      case "destroy":
        metronome.destroy();
        break;
      case "enableTickCallback":
        enableTickCallback = true;
        break;
      default:
        result.notImplemented();
        break;
    }
  }

  @Override
  public void onDetachedFromEngine(@NonNull FlutterPluginBinding binding) {
    context = null;
    channel.setMethodCallHandler(null);
    eventTick.setStreamHandler(null);
  }

  private void metronomeInit(@NonNull MethodCall call) {
    if (!Objects.equals(call.argument("path"), "")) {
      String _mainFilePath = call.argument("path");
      metronome = new Metronome(context, _mainFilePath);
      if (enableTickCallback) {
        metronome.enableTickCallback(eventTickSink);
      }
      setVolume(call);
      setBPM(call);
    }
  }

  private void setVolume(@NonNull MethodCall call) {
    if (metronome != null) {
      Double _volume = call.argument("volume");
      if (_volume != null) {
        float _volume1 = _volume.floatValue();
        metronome.setVolume(_volume1);
      }
    }
  }

  private void setBPM(@NonNull MethodCall call) {
    if (metronome != null) {
      Integer _bpm = call.argument("bpm");
      if (_bpm != null) {
        metronome.setBPM(_bpm);
      }
    }
  }

  private void setAudioFile(@NonNull MethodCall call) {
    if (metronome != null) {
      metronome.setAudioFile(call.argument("path"));
    }
  }
}
