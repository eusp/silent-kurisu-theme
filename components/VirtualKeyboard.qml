import QtQuick
import QtQuick.VirtualKeyboard
import QtQuick.Effects

Item {
    id: virtualKeyboard
    anchors.left: parent.left
    anchors.right: parent.right
    anchors.bottom: parent.bottom
    
    height: root.virtualKeyboardVisible ? keyboardContainer.height + 20 : 0
    z: 100 // Ensure it sits on top of all other components

    Rectangle {
        id: keyboardContainer
        width: Math.min(parent.width * 0.6, 900) // Prevent it from being infinitely wide/tall
        height: inputPanel.height + 2 // Let the keyboard define its own natural height
        anchors.horizontalCenter: parent.horizontalCenter
        
        color: "#0a0a0f"
        opacity: root.virtualKeyboardVisible ? 0.95 : 0.0
        border.color: "#5d5dff"
        border.width: 1
        radius: 0
        clip: true
        
        // Add a subtle glow/shadow to match the rest of the UI
        layer.enabled: true
        layer.effect: MultiEffect {
            shadowEnabled: true
            shadowColor: "#5d5dff"
            shadowBlur: 0.8
            shadowHorizontalOffset: 0
            shadowVerticalOffset: 0
        }

        InputPanel {
            id: inputPanel
            width: parent.width - 4
            anchors.centerIn: parent
            
            // This makes sure the keyboard isn't active/stealing focus when hidden
            active: root.virtualKeyboardVisible
            
            // Tint and CLIP the default keyboard to match our rounded theme
            layer.enabled: true
            layer.effect: MultiEffect {
                colorization: 0.6
                colorizationColor: "#2b2bff"
            }
        }

        Behavior on y {
            NumberAnimation {
                duration: 350
                easing.type: Easing.OutQuart
            }
        }
        
        Behavior on opacity {
            NumberAnimation {
                duration: 250
            }
        }

        y: root.virtualKeyboardVisible ? -20 : virtualKeyboard.height + 100
    }
}
