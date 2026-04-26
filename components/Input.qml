import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Effects

Item {
    id: input

    signal accepted

    property string placeholder: ""
    property alias input: textField
    property bool isPassword: false
    property bool splitBorderRadius: false
    property alias text: textField.text
    property string icon: ""
    property bool enabled: true

    width: 200
    height: 36

    TextField {
        id: textField
        anchors.fill: parent
        color: "#e0e0ff"
        enabled: input.enabled
        echoMode: input.isPassword ? TextInput.Password : TextInput.Normal
        passwordCharacter: "●"
        activeFocusOnTab: true
        selectByMouse: true
        verticalAlignment: TextField.AlignVCenter
        font.family: "RedHatDisplay"
        font.pixelSize: 12
        background: Rectangle {
            anchors.fill: parent
            color: "#0a0a0f"
            opacity: 1.0
            topLeftRadius: 10
            bottomLeftRadius: 10
            topRightRadius: input.splitBorderRadius ? 10 : 10
            bottomRightRadius: input.splitBorderRadius ? 10 : 10
        }
        leftPadding: placeholderLabel.x
        rightPadding: 10
        onAccepted: input.accepted()

        Rectangle {
            anchors.fill: parent
            border.width: 1
            border.color: "#5d5dff"
            color: "transparent"
            topLeftRadius: 10
            bottomLeftRadius: 10
            topRightRadius: input.splitBorderRadius ? 10 : 10
            bottomRightRadius: input.splitBorderRadius ? 10 : 10
        }

        Row {
            anchors.fill: parent
            spacing: 0
            leftPadding: true ? 2 : 10

            Rectangle {
                id: iconContainer
                color: "transparent"
                visible: true
                height: parent.height
                width: height

                Image {
                    id: icon
                    source: input.icon
                    anchors.centerIn: parent
                    width: 16
                    height: width
                    sourceSize: Qt.size(width, height)
                    fillMode: Image.PreserveAspectFit
                    opacity: input.enabled ? 1.0 : 0.3
                    Behavior on opacity {
                        enabled: true
                        NumberAnimation {
                            duration: 250
                        }
                    }

                    MultiEffect {
                        source: parent
                        anchors.fill: parent
                        colorization: 1
                        colorizationColor: textField.color
                    }
                }
            }

            Text {
                id: placeholderLabel
                anchors {
                    verticalCenter: parent.verticalCenter
                }
                padding: 0
                visible: textField.text.length === 0 && (!textField.preeditText || textField.preeditText.length === 0)
                text: input.placeholder
                color: textField.color
                font.pixelSize: Math.max(8, textField.font.pixelSize || 12)
                font.family: textField.font.family || "sans-serif"
                horizontalAlignment: Text.AlignLeft
                verticalAlignment: textField.verticalAlignment
                font.italic: true
            }
        }
    }
}
