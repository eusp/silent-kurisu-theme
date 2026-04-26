import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import QtQuick.Effects

ColumnLayout {
    id: selector
    width: 160 - 10 * 2

    signal sessionChanged(sessionIndex: int, iconPath: string, label: string)
    signal close

    property int currentSessionIndex: (sessionModel && sessionModel.lastIndex >= 0) ? sessionModel.lastIndex : 0
    property string sessionName: ""
    property string sessionIconPath: ""

    function getSessionIcon(name) {
        var available_session_icons = ["hyprland", "plasma", "gnome", "ubuntu", "sway", "awesome", "qtile", "i3", "bspwm", "dwm", "xfce", "cinnamon", "niri"];
        for (var i = 0; i < available_session_icons.length; i++) {
            if (name && name.toLowerCase().includes(available_session_icons[i]))
                return "../icons/sessions/" + available_session_icons[i] + ".svg";
        }
        return "../icons/sessions/default.svg";
    }

    ListView {
        id: sessionList
        Layout.preferredWidth: parent.width
        Layout.preferredHeight: Math.min((sessionModel ? sessionModel.rowCount() : 0) * (32 + spacing), 200)
        orientation: ListView.Vertical
        interactive: true
        clip: true
        boundsBehavior: Flickable.StopAtBounds
        spacing: 2
        highlightFollowsCurrentItem: true
        highlightMoveDuration: 0
        contentHeight: sessionModel.rowCount() * (32 + spacing)

        ScrollBar.vertical: ScrollBar {
            id: scrollbar
            policy: true && sessionList.contentHeight > sessionList.height ? ScrollBar.AlwaysOn : ScrollBar.AlwaysOff
            contentItem: Rectangle {
                id: scrollbarBackground
                implicitWidth: 5
                radius: 5
                color: "#e0e0ff"
                opacity: 1.0
            }
        }

        model: sessionModel
        currentIndex: selector.currentSessionIndex
        onCurrentIndexChanged: {
            var session_name = sessionModel.data(sessionModel.index(currentIndex, 0), 260);

            selector.currentSessionIndex = currentIndex;
            selector.sessionName = session_name;
            selector.sessionChanged(selector.currentSessionIndex, getSessionIcon(session_name), session_name);
        }

        delegate: Rectangle {
            width: scrollbar.visible ? parent.width - 10 - scrollbar.width : parent.width
            height: 32
            color: "transparent"
            radius: 8

            Rectangle {
                anchors.fill: parent
                color: "#5d5dff"
                opacity: index === selector.currentSessionIndex ? 1.0 : (itemMouseArea.containsMouse ? 1.0 : 0.0)
                radius: 8
            }

            RowLayout {
                anchors.fill: parent

                Rectangle {
                    Layout.preferredWidth: parent.height
                    Layout.preferredHeight: parent.height
                    Layout.alignment: Qt.AlignVCenter
                    color: "transparent"

                    Image {
                        id: sessionIcon
                        anchors.centerIn: parent
                        source: selector.getSessionIcon(name)
                        width: 16
                        height: 16
                        sourceSize: Qt.size(width, height)
                        fillMode: Image.PreserveAspectFit
                        visible: false
                    }
                    MultiEffect {
                        id: sessionIconEffect
                        source: sessionIcon
                        anchors.fill: sessionIcon
                        colorization: 1
                        colorizationColor: index === selector.currentSessionIndex || itemMouseArea.containsMouse ? "#050505" : "#e0e0ff"
                        antialiasing: true
                    }
                }

                Rectangle {
                    Layout.fillWidth: true
                    Layout.preferredHeight: parent.height
                    Layout.alignment: Qt.AlignVCenter
                    color: "transparent"

                    Text {
                        anchors.verticalCenter: parent.verticalCenter
                        elide: Text.ElideRight
                        width: parent.width - 5
                        text: name
                        color: index === selector.currentSessionIndex || itemMouseArea.containsMouse ? "#050505" : "#e0e0ff"
                        font.pixelSize: 12
                        font.family: "RedHatDisplay"
                    }
                }
            }

            MouseArea {
                id: itemMouseArea
                anchors.fill: parent
                cursorShape: Qt.PointingHandCursor
                hoverEnabled: true
                onClicked: {
                    // FIXME: Some clicks seem to be ignored
                    sessionList.currentIndex = index;
                }
            }
        }
    }

    Keys.onPressed: function (event) {
        if (event.key === Qt.Key_Down) {
            if (sessionModel.rowCount() > 0) {
                sessionList.currentIndex = (sessionList.currentIndex + sessionModel.rowCount() + 1) % sessionModel.rowCount();
            }
        } else if (event.key === Qt.Key_Up) {
            if (sessionModel.rowCount() > 0) {
                sessionList.currentIndex = (sessionList.currentIndex + sessionModel.rowCount() - 1) % sessionModel.rowCount();
            }
        } else if (event.key == Qt.Key_Return || event.key == Qt.Key_Enter || event.key === Qt.Key_Space) {
            selector.close();
        } else if (event.key === Qt.Key_CapsLock) {
            root.capsLockOn = !root.capsLockOn;
        }
    }
}
