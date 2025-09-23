import QtQuick
import Quickshell
import Quickshell.Services.Pipewire
import qs.common
pragma Singleton
pragma ComponentBehavior: Bound

Singleton {
    id: root

    property bool ready: Pipewire.defaultAudioSink?.ready ?? false
    property PwNode sink: Pipewire.defaultAudioSink
    property PwNode source: Pipewire.defaultAudioSource

    signal sinkProtectionTriggered(string reason)

    PwObjectTracker {
        objects: [sink, source]
    }

    Connections {
        target: sink?.audio ?? null
        property bool lastReady: false
        property real lastVolume: 0

        function onVolumeChanged() {
            if (!Config.options.audio.protection.enable)
                return;
            if (!lastReady) {
                lastVolume = sink.audio.volume;
                lastReady = true;
                return;
            }

            const newVolume = sink.audio.volume;
            const maxAllowedIncrease = Config.options.audio.protection.maxAllowedIncrease / 100;
            const maxAllowed = Config.options.audio.protection.maxAllowed / 100;

            if (newVolume - lastVolume > maxAllowedIncrease) {
                sink.audio.volume = lastVolume;
                root.sinkProtectionTriggered("Incremento ilegal");
            } else if (newVolume > maxAllowed) {
                root.sinkProtectionTriggered("Excedeu o máximo");
                sink.audio.volume = Math.min(lastVolume, maxAllowed);
            }

            if (sink.ready && (isNaN(sink.audio.volume) || sink.audio.volume === undefined || sink.audio.volume === null)) {
                sink.audio.volume = 0;
            }
            lastVolume = sink.audio.volume;
        }
    }
}
