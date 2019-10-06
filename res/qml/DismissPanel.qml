import QtQuick 2.0
import QtQuick.Layouts 1.11
import QtQuick.Controls 2.5

import QClipboard 1.0

Container {
    Layout.preferredHeight: 39
    Layout.preferredWidth: 300

    contentItem: Rectangle {
        color: "#323642"
    }

    Image {
        anchors.verticalCenter: parent.verticalCenter
        anchors.horizontalCenter: parent.horizontalCenter
        source: "qrc:/res/images/up_chevron.png"
    }

    MouseArea {
        id: ma
        anchors.fill: parent
        onClicked: {
            window.hide();
        }
    }

}

