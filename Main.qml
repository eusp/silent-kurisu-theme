import "."
import QtQuick
import SddmComponents
import QtQuick.Effects
import QtMultimedia
import "components"

Item {
    id: root

    property bool virtualKeyboardVisible: false
    property bool capsLockOn: false
    Component.onCompleted: {
        if (keyboard)
            capsLockOn = keyboard.capsLock;
    }
    onCapsLockOnChanged: {
        loginScreen.updateCapsLock();
    }

    state: "lockState"

    TextConstants {
        id: textConstants
    }

    states: [
        State {
            name: "lockState"
            PropertyChanges {
                target: lockScreen
                opacity: 1.0
                y: 0
            }
            PropertyChanges {
                target: loginScreen
                opacity: 0.0
                y: mainFrame.height
            }
            PropertyChanges {
                target: loginScreen.loginContainer
                scale: 0.5
            }
            PropertyChanges {
                target: backgroundEffect
                blurMax: 32
                brightness: 0.0
                saturation: 0.0
            }
        },
        State {
            name: "loginState"
            PropertyChanges {
                target: lockScreen
                opacity: 0.0
                y: -mainFrame.height
            }
            PropertyChanges {
                target: loginScreen
                opacity: 1.0
                y: 0
            }
            PropertyChanges {
                target: loginScreen.loginContainer
                scale: 1.0
            }
            PropertyChanges {
                target: backgroundEffect
                blurMax: 0
                brightness: 0.0
                saturation: 0.0
            }
        }
    ]
    transitions: Transition {
        enabled: true
        PropertyAnimation {
            duration: 150
            properties: "opacity"
        }
        PropertyAnimation {
            duration: 400
            properties: "blurMax,y"
            easing.type: Easing.InOutQuad
        }
        PropertyAnimation {
            duration: 400
            properties: "brightness"
        }
        PropertyAnimation {
            duration: 400
            properties: "saturation"
        }
    }

    Item {
        id: mainFrame
        property variant geometry: screenModel.geometry(screenModel.primary)
        x: geometry.x
        y: geometry.y
        width: geometry.width
        height: geometry.height

        // AnimatedImage { // `.gif`s are seg faulting with multi monitors... QT/SDDM issue?
        Image {
            // Background
            id: backgroundImage
            property string tsource: root.state === "lockState" ? "kurisu.mp4" : "rei.mp4"

            property bool isVideo: {
                if (!tsource || tsource.toString().length === 0)
                    return false;
                var parts = tsource.toString().split(".");
                if (parts.length === 0)
                    return false;
                var ext = parts[parts.length - 1];
                return ["avi", "mp4", "mov", "mkv", "m4v", "webm"].indexOf(ext) !== -1;
            }
            property bool displayColor: root.state === "lockState" && false || root.state === "loginState" && false
            property string placeholder: "kurisu.png" // Idea stolen from astronaut-theme. Not a fan of it, but works...

            anchors.fill: parent
            source: !isVideo ? "backgrounds/" + tsource : ""
            cache: true
            mipmap: true
            fillMode: Image.PreserveAspectCrop

            function updateVideo() {
                if (isVideo && tsource.toString().length > 0) {
                    backgroundVideo.source = Qt.resolvedUrl("backgrounds/" + tsource);

                    if (placeholder.length > 0)
                        source = "backgrounds/" + placeholder;
                }
            }

            onSourceChanged: {
                updateVideo();
            }
            Component.onCompleted: {
                updateVideo();
            }
            onStatusChanged: {
                if (status === Image.Error) {
                    if (source !== "backgrounds/default.jpg" && source !== "") {
                        source = "backgrounds/default.jpg";
                    } else if (source === "backgrounds/default.jpg") {
                        // If even default fails, show color background
                        displayColor = true;
                    }
                }
            }

            Rectangle {
                id: backgroundColor
                anchors.fill: parent
                anchors.margins: 0
                color: root.state === "lockState" && false ? "#050505" : (root.state === "loginState" && false ? "#050505" : "black")
                visible: parent.displayColor || (backgroundVideo.visible && parent.placeholder.length === 0)
            }

            // TODO: This is slow af. Removing the property bindings and doing everything at startup should help.
            Video {
                id: backgroundVideo
                anchors.fill: parent
                visible: parent.isVideo && !parent.displayColor
                enabled: visible
                autoPlay: false
                loops: MediaPlayer.Infinite
                muted: true
                fillMode: VideoOutput.PreserveAspectCrop

                onSourceChanged: {
                    if (source && source.toString().length > 0) {
                        backgroundVideo.play();
                    }
                }
                onErrorOccurred: function (error) {
                    if (error !== MediaPlayer.NoError && (!backgroundImage.placeholder || backgroundImage.placeholder.length === 0)) {
                        backgroundImage.displayColor = true;
                    }
                }
            }

            // Overkill, but fine...
            Component.onDestruction: {
                if (backgroundVideo) {
                    backgroundVideo.stop();
                    backgroundVideo.source = "";
                }
            }
        }
        MultiEffect {
            // Background effects
            id: backgroundEffect
            source: backgroundImage
            anchors.fill: parent
            blurEnabled: backgroundImage.visible && blurMax > 0
            blur: blurMax > 0 ? 1.0 : 0.0
            autoPaddingEnabled: false
        }

        Item {
            id: screenContainer
            anchors.fill: parent
            anchors.top: parent.top

            LockScreen {
                id: lockScreen
                z: root.state === "lockState" ? 2 : 1 // Fix tooltips from the login screen showing up on top of the lock screen.
                width: parent.width
                height: parent.height
                focus: root.state === "lockState"
                enabled: root.state === "lockState"
                onLoginRequested: {
                    root.state = "loginState";
                    loginScreen.resetFocus();
                }
            }
            LoginScreen {
                id: loginScreen
                z: root.state === "loginState" ? 2 : 1
                width: parent.width
                height: parent.height
                enabled: root.state === "loginState"
                opacity: 0.0
                onClose: {
                    root.state = "lockState";
                }
            }
        }
        
        VirtualKeyboard {
            id: virtualKeyboardPlugin
        }
    }
}

