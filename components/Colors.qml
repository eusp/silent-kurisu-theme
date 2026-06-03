import QtQuick

QtObject {
    id: colors

    // Base
    readonly property color base: "#040509"
    readonly property color text: "#e8ecff"
    readonly property color subtext0: "#9ba6d9"

    // Surfaces
    readonly property color surface0: "#0c1020"
    readonly property color surface1: "#141b33"
    readonly property color surface2: "#1f2950"

    // Overlays
    readonly property color overlay0: "#24315f"
    readonly property color overlay1: "#35488a"

    // Primary
    readonly property color primary: "#6d7cff"
    readonly property color primaryAlt: "#9ca7ff"
    readonly property color primaryMuted: "#4a569a"

    // Semantic
    readonly property color danger: "#a33456"
    readonly property color warning: "#d3c17d"
    readonly property color success: "#65a6b3"
    readonly property color info: "#8ea7ff"

    // Accents
    readonly property color accent0: "#d7deff"
    readonly property color accent1: "#a9b8ff"
    readonly property color accent2: "#7b88ff"
    readonly property color accent3: "#eef1ff"

    // Layers
    readonly property color mantle: "#070910"
    readonly property color crust: "#020307"
}
