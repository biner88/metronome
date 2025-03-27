#ifndef METRONOME_PLUGIN_H_
#define METRONOME_PLUGIN_H_

#include <flutter/method_channel.h>
#include <flutter/plugin_registrar_windows.h>
#include <flutter/event_channel.h>
#include <memory>

#include "metronome.h"

namespace metronome
{

    class MetronomePlugin : public flutter::Plugin
    {
    public:
        static void RegisterWithRegistrar(flutter::PluginRegistrarWindows *registrar);

        MetronomePlugin();

        virtual ~MetronomePlugin();

    private:
        void HandleMethodCall(
            const flutter::MethodCall<flutter::EncodableValue> &method_call,
            std::unique_ptr<flutter::MethodResult<flutter::EncodableValue>> result);

        std::unique_ptr<Metronome> metronome;
        std::unique_ptr<flutter::EventChannel<flutter::EncodableValue>> eventChannel;
        std::shared_ptr<flutter::EventSink<flutter::EncodableValue>> eventSink;
    };

} // namespace metronome

#endif // METRONOME_PLUGIN_H_