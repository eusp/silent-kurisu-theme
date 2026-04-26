import QtQuick
import QtQuick.Layouts
import QtQuick.Controls

ColumnLayout {
    id: selector
    width: 100
    spacing: 2

    signal close

    KeyNavigation.up: shutdownButton
    KeyNavigation.down: suspendButton

    IconButton {
        id: suspendButton

        preferredWidth: Layout.preferredWidth
        Layout.preferredHeight: 32
        Layout.preferredWidth: 100

        focus: selector.visible
        width: Layout.preferredWidth
        enabled: sddm.canSuspend
        icon: "../icons/power-suspend.svg"
        contentColor: "#e0e0ff"
        activeContentColor: "#050505"
        fontFamily: "RedHatDisplay"
        backgroundColor: "transparent"
        activeBackgroundColor: "#5d5dff"
        activeBackgroundOpacity: 1.0
        iconSize: 16
        fontSize: 12
        onClicked: {
            selector.close();
            sddm.suspend();
        }
        label: textConstants.suspend

        KeyNavigation.up: shutdownButton
        KeyNavigation.down: rebootButton
    }

    IconButton {
        id: rebootButton

        preferredWidth: Layout.preferredWidth
        Layout.preferredHeight: 32
        Layout.preferredWidth: 100

        focus: selector.visible
        width: Layout.preferredWidth
        enabled: sddm.canReboot
        icon: "../icons/power-reboot.svg"
        contentColor: "#e0e0ff"
        activeContentColor: "#050505"
        fontFamily: "RedHatDisplay"
        backgroundColor: "transparent"
        activeBackgroundColor: "#5d5dff"
        activeBackgroundOpacity: 1.0
        iconSize: 16
        fontSize: 12
        onClicked: {
            selector.close();
            sddm.reboot();
        }
        label: textConstants.reboot

        KeyNavigation.up: suspendButton
        KeyNavigation.down: shutdownButton
    }

    IconButton {
        id: shutdownButton

        preferredWidth: Layout.preferredWidth
        Layout.preferredHeight: 32
        Layout.preferredWidth: 100

        focus: selector.visible
        width: Layout.preferredWidth
        enabled: sddm.canPowerOff
        icon: "../icons/power.svg"
        contentColor: "#e0e0ff"
        activeContentColor: "#050505"
        fontFamily: "RedHatDisplay"
        backgroundColor: "transparent"
        activeBackgroundColor: "#5d5dff"
        activeBackgroundOpacity: 1.0
        iconSize: 16
        fontSize: 12
        onClicked: {
            selector.close();
            sddm.powerOff();
        }
        label: textConstants.shutdown

        KeyNavigation.up: rebootButton
        KeyNavigation.down: suspendButton
    }

    Keys.onPressed: function (event) {
        if (event.key == Qt.Key_Return || event.key == Qt.Key_Enter || event.key === Qt.Key_Space) {
            selector.close();
        } else if (event.key === Qt.Key_CapsLock) {
            root.capsLockOn = !root.capsLockOn;
        }
    }
}
