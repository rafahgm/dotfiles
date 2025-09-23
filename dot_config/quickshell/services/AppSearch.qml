pragma Singleton

import qs.common
import Quickshell

Singleton {
    id: root

    function guessIcon(className) {
        if (!className || className.length == 0)
            return "image-missing";

        const entry = DesktopEntries.heuristicLookup(className);
        if(entry) return entry.icon;

        return className;
    }
}
