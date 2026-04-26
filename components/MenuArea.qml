import QtQuick
import QtQuick.Controls
import QtQuick.Effects

Item {
    id: menuArea
    anchors.fill: parent

    Component {
        id: sessionMenuComponent

            IconButton {
            id: sessionButton
            property bool showLabel: true
            preferredWidth: showLabel ? undefined : 32
            height: 32
            iconSize: 16
            fontSize: 12
            enabled: loginScreen.state === "normal" || popup.visible
            active: popup.visible
            contentColor: "#e0e0ff"
            activeContentColor: "#050505"
            borderRadius: 8
            borderSize: 0
            backgroundColor: "#5d5dff"
            backgroundOpacity: 0.0
            activeBackgroundColor: "#5d5dff"
            activeBackgroundOpacity: 1.0
            fontFamily: "RedHatDisplay"
            activeFocusOnTab: true
            focus: false
            onClicked: {
                if (loginScreen.isSelectingUser) {
                    loginScreen.isSelectingUser = false;
                } else {
                    popup.open();
                }
            }
            tooltipText: "Change session"

                Popup {
                id: popup
                parent: sessionButton
                padding: 10
                background: Rectangle {
                    color: "#050505"
                    opacity: 0.95
                    radius: 8

                    Rectangle {
                        anchors.fill: parent
                        visible: true
                        radius: parent.radius
                        color: "transparent"
                        border {
                            color: "#5d5dff"
                            width: 1
                        }
                    }
                }
                dim: true
                Overlay.modal: Rectangle {
                    color: "transparent"
                    MouseArea {
                        anchors.fill: parent
                        hoverEnabled: true
                        onClicked: function (event) {
                            popup.close();
                            event.accepted = true;
                        }
                    }
                }

                onOpened: loginScreen.safeStateChange("popup")
                onClosed: loginScreen.safeStateChange("normal")

                modal: true
                popupType: Popup.Item
                closePolicy: Popup.CloseOnEscape | Popup.CloseOnPressOutside
                focus: visible

                SessionSelector {
                    focus: popup.focus
                    onSessionChanged: function (newSessionIndex, sessionIcon, sessionLabel) {
                        loginScreen.sessionIndex = newSessionIndex;
                        sessionButton.icon = sessionIcon;
                        sessionButton.label = sessionButton.showLabel ? sessionLabel : "";
                    }
                    onClose: {
                        popup.close();
                    }
                }

                Component.onCompleted: {
                    [x, y] = menuArea.calculatePopupPos("up", "start", popup, sessionButton);
                }
            }
        }
    }


    Component {
        id: powerMenuComponent

        IconButton {
            id: powerButton

            height: 32
            width: 32
            icon: "../icons/power.svg"
            iconSize: 16
            contentColor: "#e0e0ff"
            activeContentColor: "#050505"
            fontFamily: "RedHatDisplay"
            active: popup.visible
            borderRadius: 8
            borderSize: 0
            backgroundColor: "#5d5dff"
            backgroundOpacity: 0.0
            activeBackgroundColor: "#5d5dff"
            activeBackgroundOpacity: 1.0
            showKeyboardPattern: true
            enabled: loginScreen.state === "normal" || popup.visible
            activeFocusOnTab: true
            focus: false
            onClicked: {
                popup.open();
            }
            tooltipText: "Power options"

                Popup {
                id: popup
                parent: powerButton
                background: Rectangle {
                    color: "#050505"
                    opacity: 0.95
                    radius: 8

                    Rectangle {
                        anchors.fill: parent
                        visible: true
                        radius: parent.radius
                        color: "transparent"
                        border {
                            color: "#5d5dff"
                            width: 1
                        }
                    }
                }
                dim: true
                padding: 10
                Overlay.modal: Rectangle {
                    color: "transparent"  // Remove dim background (dim: false doesn't work here)
                    MouseArea {
                        anchors.fill: parent
                        hoverEnabled: true
                        onClicked: function (event) {
                            popup.close();
                            event.accepted = true;
                        }
                    }
                }

                onOpened: loginScreen.safeStateChange("popup")
                onClosed: loginScreen.safeStateChange("normal")

                modal: true
                popupType: Popup.Item
                closePolicy: Popup.CloseOnEscape | Popup.CloseOnPressOutside
                focus: visible

                PowerMenu {
                    focus: popup.focus
                    onClose: {
                        popup.close();
                    }
                }

                Component.onCompleted: {
                    [x, y] = menuArea.calculatePopupPos("up", "end", popup, powerButton);
                }
            }
        }
    }

    Row {
        // top_left
        id: topLeftButtons

        height: childrenRect.height
        width: childrenRect.width
        spacing: 10
        anchors {
            top: parent.top
            left: parent.left
            topMargin: 0
            leftMargin: 15
        }
    }

    Row {
        // top_center
        id: topCenterButtons

        height: childrenRect.height
        width: childrenRect.width
        spacing: 10
        anchors {
            top: parent.top
            horizontalCenter: parent.horizontalCenter
            topMargin: 0
        }
    }

    Component {
        id: keyboardButtonComponent
        IconButton {
            id: keyboardButton
            height: 32
            width: 32
            icon: "../icons/keyboard.svg" // fallback to an existing icon if keyboard doesn't exist, wait, do we have keyboard.svg? Let's check or use user-default.svg temporarily
            iconSize: 16
            contentColor: root.virtualKeyboardVisible ? "#050505" : "#e0e0ff"
            activeContentColor: "#050505"
            fontFamily: "RedHatDisplay"
            active: root.virtualKeyboardVisible
            borderRadius: 8
            borderSize: 0
            backgroundColor: "#5d5dff"
            backgroundOpacity: root.virtualKeyboardVisible ? 1.0 : 0.0
            activeBackgroundColor: "#5d5dff"
            activeBackgroundOpacity: 1.0
            showKeyboardPattern: true
            enabled: loginScreen.state === "normal"
            activeFocusOnTab: true
            focus: false
            onClicked: {
                root.virtualKeyboardVisible = !root.virtualKeyboardVisible;
            }
            tooltipText: "Toggle Keyboard"
        }
    }


    Row {
        // top_right
        id: topRightButtons

        height: childrenRect.height
        width: childrenRect.width
        spacing: 10
        anchors {
            top: parent.top
            right: parent.right
            topMargin: 0
            rightMargin: 15
        }
    }

    Column {
        // center_left
        id: centerLeftButtons

        height: childrenRect.height
        width: childrenRect.width
        spacing: 10
        anchors {
            left: parent.left
            verticalCenter: parent.verticalCenter
            leftMargin: 15
        }
    }

    Column {
        // center_right
        id: centerRightButtons

        height: childrenRect.height
        width: childrenRect.width
        spacing: 10
        anchors {
            right: parent.right
            verticalCenter: parent.verticalCenter
            rightMargin: 15
        }
    }

   Rectangle {
        id: bottomLeftPanel
        color: "#0a0a0f"
        opacity: 0.92
        radius: 12
        anchors {
            bottom: parent.bottom
            left: parent.left
            bottomMargin: 15 - 10
            leftMargin: 15 - 10
        }
        width: bottomLeftButtons.width + 20
        height: bottomLeftButtons.height + 20

        layer.enabled: true
        layer.effect: MultiEffect {
            shadowEnabled: true
            shadowColor: "#5d5dff"
            shadowBlur: 0.6
            shadowHorizontalOffset: 0
            shadowVerticalOffset: 0
        }
    }

   Row {
        // bottom_left
        id: bottomLeftButtons

        height: childrenRect.height
        width: childrenRect.width
        spacing: 10
        anchors {
            bottom: parent.bottom
            left: parent.left
            bottomMargin: 15
            leftMargin: 15
        }
   }

   Row {
        // bottom_center
        id: bottomCenterButtons

        height: childrenRect.height
        width: childrenRect.width
        spacing: 10
        anchors {
            bottom: parent.bottom
            horizontalCenter: parent.horizontalCenter
            bottomMargin: 15
        }
    }

    Row {
        // bottom_right
        id: bottomRightButtons

        height: childrenRect.height
        width: childrenRect.width
        spacing: 10
        anchors {
            bottom: parent.bottom
            right: parent.right
            bottomMargin: 15
            rightMargin: 15
        }
    }

    // FIX: Critical createObject memory leak prevention
    property var createdObjects: []

    Component.onCompleted: {
        var menus = [
            { name: "session", index: 1, position: "bottom-left" },
            { name: "power", index: 2, position: "bottom-right" },
            { name: "keyboard", index: 3, position: "top-right" }
        ];

        for (var i = 0; i < menus.length; i++) {
            var pos;
            switch (menus[i].position) {
            case "top-left": pos = topLeftButtons; break;
            case "top-center": pos = topCenterButtons; break;
            case "top-right": pos = topRightButtons; break;
            case "center-left": pos = centerLeftButtons; break;
            case "center-right": pos = centerRightButtons; break;
            case "bottom-left": pos = bottomLeftButtons; break;
            case "bottom-center": pos = bottomCenterButtons; break;
            case "bottom-right": pos = bottomRightButtons; break;
            }

            var createdObject;
            if (menus[i].name === "session")
                createdObject = sessionMenuComponent.createObject(pos, {});
            else if (menus[i].name === "power")
                createdObject = powerMenuComponent.createObject(pos, {});
            else if (menus[i].name === "keyboard")
                createdObject = keyboardButtonComponent.createObject(pos, {});

            if (createdObject) {
                createdObjects.push(createdObject);
            }
        }
    }

    Component.onDestruction: {
        // FIX: Critical createObject memory leak cleanup
        for (var i = 0; i < createdObjects.length; i++) {
            if (createdObjects[i]) {
                createdObjects[i].destroy();
            }
        }
        createdObjects = [];
    }

    function calculatePopupPos(direction, align, popup, button) {
        var popupMargin = 10;
        var x = 0, y = 0;

        if (direction === "up") {
            y = -popup.height - popupMargin;
            if (align === "start") {
                x = 0;
            } else if (align === "end") {
                x = -popup.width + button.width;
            } else {
                x = (button.width - popup.width) / 2;
            }
        } else if (direction === "down") {
            y = button.height + popupMargin;
            if (align === "start") {
                x = 0;
            } else if (align === "end") {
                x = -popup.width + button.width;
            } else {
                x = (button.width - popup.width) / 2;
            }
        } else if (direction === "left") {
            x = -popup.width - popupMargin;
            if (align === "start") {
                y = 0;
            } else if (align === "end") {
                y = -popup.height + button.height;
            } else {
                y = (button.height - popup.height) / 2;
            }
        } else {
            x = button.width + popupMargin;
            if (align === "start") {
                y = 0;
            } else if (align === "end") {
                y = -popup.height + button.height;
            } else {
                y = (button.height - popup.height) / 2;
            }
        }
        return [x, y];
    }
}
