pragma Singleton
import QtQuick 2.0

QtObject {
    readonly property color strongTextColor: "#efefef"
    readonly property string strongTextFont: "Roboto"
    readonly property int strongTextSize: 11

    readonly property color weakTextColor: "#3b7845"
    readonly property string weakTextFont: "Roboto"
    readonly property int weakTextSize: 11

    readonly property color panelBackgroundColor: "#31343c"
    readonly property color panelSeparatorColor: "#1a1c20"

    readonly property color highlightAffirmative: "#32b10e"
    readonly property color highlightNeutral: "#746c53"
    readonly property color highlightNegative: "#cc163d"
}
