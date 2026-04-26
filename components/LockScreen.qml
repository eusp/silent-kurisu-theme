import QtQuick
import QtQuick.Controls
import QtQuick.Effects
import QtQuick.Layouts

Item {
    id: lockScreen

    signal loginRequested()

    function alignItem(item, pos) {
        switch (pos) {
        case "top-left":
            item.anchors.top = lockScreen.top;
            item.anchors.left = lockScreen.left;
            break;
        case "top-center":
            item.anchors.top = lockScreen.top;
            item.anchors.horizontalCenter = lockScreen.horizontalCenter;
            break;
        case "top-right":
            item.anchors.top = lockScreen.top;
            item.anchors.right = lockScreen.right;
            break;
        case "center-left":
            item.anchors.verticalCenter = lockScreen.verticalCenter;
            item.anchors.left = lockScreen.left;
            break;
        case "center":
            item.anchors.verticalCenter = lockScreen.verticalCenter;
            item.anchors.horizontalCenter = lockScreen.horizontalCenter;
            break;
        case "center-right":
            item.anchors.verticalCenter = lockScreen.verticalCenter;
            item.anchors.right = lockScreen.right;
            break;
        case "bottom-left":
            item.anchors.bottom = lockScreen.bottom;
            item.anchors.left = lockScreen.left;
            break;
        case "bottom-center":
            item.anchors.bottom = lockScreen.bottom;
            item.anchors.horizontalCenter = lockScreen.horizontalCenter;
            break;
        default:
            item.anchors.bottom = lockScreen.bottom;
            item.anchors.right = lockScreen.right;
        }
    }

    Keys.onPressed: function(event) {
        if (event.key === Qt.Key_CapsLock)
            root.capsLockOn = !root.capsLockOn;

        if (event.key === Qt.Key_Escape) {
            event.accepted = false;
            return ;
        } else {
            lockScreen.loginRequested();
        }
        event.accepted = true;
    }

    // TODO: Support for weather info?
    Item {
        id: timePositioner

        Component.onDestruction: {
            if (clockTimer)
                clockTimer.stop();

        }
        Component.onCompleted: {
            anchors.verticalCenter = lockScreen.verticalCenter;
            anchors.horizontalCenter = lockScreen.horizontalCenter;
            time.updateTime();
            date.updateDate();
        }

        ColumnLayout {
            id: timeColumn

            anchors.centerIn: parent
            spacing: 6

            Text {
                id: time

                function updateTime() {
                    text = new Date().toLocaleString(Qt.locale("en_US"), "hh:mm");
                }

                visible: true
                font.pixelSize: 120
                font.weight: 900
                font.family: "RedHatDisplay"
                color: "#050505"
                Layout.alignment: Qt.AlignHCenter
                layer.enabled: true

                layer.effect: MultiEffect {
                    shadowEnabled: true
                    shadowColor: "#5d5dff"
                    shadowBlur: 0.8
                    shadowHorizontalOffset: 0
                    shadowVerticalOffset: 0
                }

            }

            Rectangle {
                Layout.alignment: Qt.AlignHCenter
                width: 40
                height: 1
                color: "#a0a0ff"
                opacity: 0.4
            }

            Text {
                id: date

                function updateDate() {
                    text = new Date().toLocaleString(Qt.locale("en_US"), "dddd, MMMM dd, yyyy");
                }

                Layout.alignment: Qt.AlignHCenter
                visible: true
                font.pixelSize: 25
                font.family: "RedHatDisplay"
                font.weight: 800
                color: "#a0a0ff"
                layer.enabled: true

                layer.effect: MultiEffect {
                    shadowEnabled: true
                    shadowColor: "#5d5dff"
                    shadowBlur: 0.8
                    shadowHorizontalOffset: 0
                    shadowVerticalOffset: 0
                }

            }

        }

        Timer {
            id: clockTimer

            interval: 1000
            repeat: true
            running: true
            onTriggered: {
                time.updateTime();
                date.updateDate();
            }
        }

    }

    ColumnLayout {
        id: messagePositioner

        visible: false
        spacing: 0
        Component.onCompleted: lockScreen.alignItem(messagePositioner, "bottom-center")

        Item {
            Layout.alignment: Qt.AlignHCenter
            Layout.preferredWidth: 16
            Layout.preferredHeight: 16

            Image {
                id: lockIcon

                source: "../icons/enter.svg"
                width: 16
                height: 16
                sourceSize: Qt.size(16, 16)
                fillMode: Image.PreserveAspectFit
                visible: false
            }
            MultiEffect {
                source: lockIcon
                anchors.fill: lockIcon
                colorization: 1
                colorizationColor: "#e0e0ff"
                visible: true
                antialiasing: true
            }

        }

        Text {
            id: lockMessage

            Layout.alignment: Qt.AlignHCenter
            font.pixelSize: 12
            font.family: "RedHatDisplay"
            font.weight: 400
            color: "#e0e0ff"
            text: "Press any key"
        }

        anchors {
            // FIX: Height calculation fixes - protect against zero division
            topMargin: 0 || (lockScreen.height > 0 ? lockScreen.height / 10 : 50)
            rightMargin: 0 || (lockScreen.height > 0 ? lockScreen.height / 10 : 50)
            bottomMargin: 0 || (lockScreen.height > 0 ? lockScreen.height / 10 : 50)
            leftMargin: 0 || (lockScreen.height > 0 ? lockScreen.height / 10 : 50)
        }

    }

    MouseArea {
        id: lockScreenMouseArea

        hoverEnabled: true
        z: -1
        anchors.fill: lockScreen
        onClicked: lockScreen.loginRequested()
    }

}
