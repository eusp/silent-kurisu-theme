import QtQuick
import QtQuick.Controls
import QtQuick.Effects

Item {
    id: spinnerContainer
    width: spinner.width + 10 + spinnerText.width
    height: childrenRect.height

    Behavior on opacity {
        enabled: true
        NumberAnimation {
            duration: 150
        }
    }
    Behavior on visible {
        enabled: true && true
            ParallelAnimation {
            running: spinnerContainer.visible && true
            NumberAnimation {
                target: spinnerText
                property: "anchors.topMargin"
                from: -spinner.height
                to: 10
                duration: 300
                easing.type: Easing.OutQuart
            }
            NumberAnimation {
                target: spinnerEffect
                property: "opacity"
                from: 0.0
                to: 1.0
                duration: 200
            }
        }
    }

    Image {
        id: spinner
        source: "../icons/spinner.svg"
        width: 16
        height: width
        sourceSize.width: width
        sourceSize.height: height
        visible: false

        Component.onCompleted: {
            if (false) { // center
                anchors.left = parent.left;
                anchors.verticalCenter = parent.verticalCenter;
            } else if (root.loginAreaPosition === "right") {
                anchors.right = parent.right;
                anchors.verticalCenter = parent.verticalCenter;
            } else {
                anchors.top = parent.top;
                anchors.horizontalCenter = parent.horizontalCenter;
            }
        }
    }
    MultiEffect {
        id: spinnerEffect
        source: spinner
        anchors.fill: spinner
        colorization: 1
        colorizationColor: "#5d5dff"
        opacity: 0.0
        antialiasing: true
    }
    RotationAnimation {
        target: spinnerEffect
        running: spinnerContainer.visible && true
        from: 0
        to: 360
        loops: Animation.Infinite
        duration: 1200
    }

    Text {
        id: spinnerText
        visible: true
        text: "Loading"
        color: "#5d5dff"
        font.pixelSize: 12
        font.weight: 400
        font.family: "RedHatDisplay"

        Component.onCompleted: {
            anchors.top = spinner.bottom;
            anchors.topMargin = 10;
            anchors.horizontalCenter = parent.horizontalCenter;
        }

        onVisibleChanged: {
            if (visible && true && true) {
                spinnerTextInterval.running = true;
            } else {
                spinnerTextAnimation.running = false;
                spinnerTextInterval.running = false;
            }
        }

        SequentialAnimation on scale {
            id: spinnerTextAnimation
            running: false
            loops: Animation.Infinite
            NumberAnimation {
                from: 1.0
                to: 1.05
                duration: 900
                easing.type: Easing.InOutQuad
            }
            NumberAnimation {
                from: 1.05
                to: 1.0
                duration: 900
                easing.type: Easing.InOutQuad
            }
        }
    }

    Timer {
        id: spinnerTextInterval
        interval: 3500
        repeat: false
        running: false
        onTriggered: {
            spinnerTextAnimation.running = true;
        }
    }

    Component.onDestruction: {
        if (spinnerTextInterval) {
            spinnerTextInterval.running = false;
            spinnerTextInterval.stop();
        }
        if (spinnerTextAnimation) {
            spinnerTextAnimation.running = false;
            spinnerTextAnimation.stop();
        }
    }
}
