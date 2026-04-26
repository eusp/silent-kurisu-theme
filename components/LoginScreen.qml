import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import SddmComponents
import QtQuick.Effects

Item {
    id: loginScreen
    signal close
    signal toggleLayoutPopup

    state: "normal"
    property bool stateChanging: false
    function safeStateChange(newState) { // This is probably overkill, but whatever
        if (!stateChanging) {
            stateChanging = true;
            state = newState;
            stateChanging = false;
        }
    }
    onStateChanged: {
        if (state === "normal") {
            resetFocus();
        }
    }

    readonly property alias password: password
    readonly property alias loginButton: loginButton
    readonly property alias loginContainer: loginContainer


    property bool foundUsers: userModel.count > 0

    // Login info
    property int sessionIndex: 0
    property int userIndex: 0
    property string userName: ""
    property string userRealName: ""
    property string userIcon: ""
    property bool userNeedsPassword: true

    function login() {
        var user = foundUsers ? userName : userInput.text;
        if (user && user !== "") {
            safeStateChange("authenticating");
            sddm.login(user, password.text, sessionIndex);
        } else {
            loginMessage.warn(textConstants.promptUser || "Enter your user!", "error");
        }
    }
    Connections {
        function onLoginSucceeded() {
            loginContainer.scale = 0.0;
        }
        function onLoginFailed() {
            safeStateChange("normal");
            loginMessage.warn(textConstants.loginFailed || "Login failed", "error");
            password.text = "";
        }
        function onInformationMessage(message) {
            loginMessage.warn(message, "error");
        }
        target: sddm
    }

    // FIX: Critical connections memory leak prevention?
    Component.onDestruction: {
        if (typeof connections !== 'undefined') {
            connections.target = null;
        }
    }

    function updateCapsLock() {
        if (root.capsLockOn && loginScreen.state !== "authenticating") {
            loginMessage.warn(textConstants.capslockWarning || "Caps Lock is on", "warning");
        } else {
            loginMessage.clear();
        }
    }

    function resetFocus() {
        if (!enabled) return;
        if (!loginScreen.foundUsers) {
            userInput.input.forceActiveFocus();
        } else {
            if (loginScreen.userNeedsPassword) {
                password.input.forceActiveFocus();
            } else {
                loginButton.forceActiveFocus();
            }
        }
    }

    Item {
        id: loginContainer
        width: userSelector.width
        height: childrenRect.height
        scale: 0.5 // Initial animation

        Behavior on scale {
            enabled: true
            NumberAnimation {
                duration: 200
            }
        }

        // LoginArea position
        Component.onCompleted: {
            anchors.horizontalCenter = parent.horizontalCenter;
            anchors.verticalCenter = parent.verticalCenter;

            if (!loginScreen.foundUsers) {
                userSelector.visible = false;
                noUsersLoginArea.visible = true;
            }
        }

        Item {
            id: noUsersLoginArea
            width: 200 * 1.0 + (loginButton.visible ? 36 * 1.0 + 0 : 0)
            height: childrenRect.height
            visible: false

            Text {
                id: noUsersMessage
                anchors {
                    top: parent.top
                }
                width: parent.width
                text: "SDDM could not find any user. Type your username below:"
                wrapMode: Text.Wrap
                horizontalAlignment: Text.AlignHCenter
                color: "#ff1a4d"
                font.pixelSize: 12
                font.family: "RedHatDisplay"
            }

            Input {
                id: userInput
                anchors {
                    top: noUsersMessage.bottom
                topMargin: 8
                }
                width: parent.width
                icon: "../icons/user-default.svg"
                placeholder: (textConstants && textConstants.userName) ? textConstants.userName : "Password"
                isPassword: false
                splitBorderRadius: false
                enabled: loginScreen.state !== "authenticating"
                onAccepted: {
                    loginScreen.login();
                }
            }

            Component.onCompleted: {
                anchors.bottom = loginLayout.top;
                if (true) { // Was root.loginAreaPosition check
                    anchors.horizontalCenter = parent.horizontalCenter;
                }
            }
        }

        UserSelector {
            id: userSelector
            listUsers: loginScreen.state === "selectingUser"
            enabled: loginScreen.state !== "authenticating"
            visible: false
            activeFocusOnTab: true
            orientation: "horizontal"
            width: loginScreen.width - (-1) * 2
            height: 0
            onOpenUserList: {
                safeStateChange("selectingUser");
            }
            onCloseUserList: {
                safeStateChange("normal");
                loginScreen.resetFocus(); // resetFocus with escape even if the selector is not open
            }
            onUserChanged: (index, name, realName, icon, needsPassword) => {
                if (loginScreen.foundUsers) {
                    loginScreen.userIndex = index;
                    loginScreen.userName = name;
                    loginScreen.userRealName = realName;
                    loginScreen.userIcon = icon;
                    loginScreen.userNeedsPassword = needsPassword;
                }
            }

            Component.onCompleted: {
                anchors.top = parent.top;
            }
        }

        Item {
            id: loginLayout
            height: activeUserName.height + 8 + loginArea.height
            width: loginArea.width > activeUserName.width ? loginArea.width : activeUserName.width

            // LoginArea alignment
            
	    Rectangle {
	        anchors.fill: parent
	        
	        anchors.leftMargin: -20
		anchors.rightMargin: -20
		anchors.bottomMargin: -20
		anchors.topMargin: -15
	        
	        color: "#0a0a0f"
	        opacity: 0.75
	        radius: 16

	        layer.enabled: true
		layer.effect: MultiEffect {
		    shadowEnabled: true
		    shadowColor: "#5d5dff"
		    shadowBlur: 0.6
		    shadowHorizontalOffset: 0
		    shadowVerticalOffset: 0
		}
	   }

	    Component.onCompleted: {
                anchors.top = userSelector.bottom;
                anchors.topMargin = 8;
                anchors.horizontalCenter = parent.horizontalCenter;
            }

            Text {
                id: activeUserName
                font.family: "RedHatDisplay"
                font.weight: 700
                font.pixelSize: 15
                color: "#e0e0ff"
                text: loginScreen.userRealName || loginScreen.userName || ""
                visible: loginScreen.foundUsers
                bottomPadding: 5

                Component.onCompleted: {
                    anchors.top = parent.top;
                    anchors.horizontalCenter = parent.horizontalCenter;
                }
            }

            RowLayout {
                id: loginArea
                height: 36
                spacing: 0
                visible: loginScreen.state !== "authenticating"

                Component.onCompleted: {
                    anchors.top = activeUserName.bottom;
                    anchors.topMargin = 8;
                    anchors.horizontalCenter = parent.horizontalCenter;
                }

                Input {
                    id: password
                    Layout.alignment: Qt.AlignHCenter
                    enabled: loginScreen.state === "normal"
                    visible: loginScreen.userNeedsPassword || !loginScreen.foundUsers
                    icon: "../icons/password.svg"
                    placeholder: (textConstants && textConstants.password) ? textConstants.password : "Password"
                    isPassword: true
                    splitBorderRadius: true
                    onAccepted: {
                        loginScreen.login();
                    }
                }

                IconButton {
                    id: loginButton
                    Layout.alignment: Qt.AlignHCenter
                    Layout.preferredWidth: width // Fix button not resizing when label updates
                    height: password.height
                    visible: !true || !loginScreen.userNeedsPassword
                    enabled: loginScreen.state !== "selectingUser" && loginScreen.state !== "authenticating"
                    activeFocusOnTab: true
                    icon: "../icons/arrow-right.svg"
                    label: textConstants.login ? textConstants.login : "Login"
                    showLabel: true && !loginScreen.userNeedsPassword
                    tooltipText: !false && (!true || loginScreen.userNeedsPassword) ? (textConstants.login || "Login") : ""
                    iconSize: 16
                    fontFamily: "RedHatDisplay"
                    fontSize: 12
                    fontWeight: 600
                    contentColor: "#5d5dff"
                    activeContentColor: "#050505"
                    backgroundColor: "#5d5dff"
                    backgroundOpacity: 0.0
                    activeBackgroundColor: "#5d5dff"
                    activeBackgroundOpacity: 1.0
                    borderSize: 1
                    borderColor: "#5d5dff"
                    borderRadiusLeft: password.visible ? 0 : 10
                    borderRadiusRight: 10
                    onClicked: {
                        loginScreen.login();
                    }

                    Behavior on x {
                    enabled: true
                    NumberAnimation {
                        duration: 150
                    }
                    }
                }
            }

            Spinner {
                id: spinner
                visible: loginScreen.state === "authenticating"
                opacity: visible ? 1.0 : 0.0

                Component.onCompleted: {
                    anchors.top = activeUserName.bottom;
                    anchors.topMargin = 8;
                    anchors.horizontalCenter = parent.horizontalCenter;
                }
            }

            Text {
                id: loginMessage
                property bool capslockWarning: false
                font.pixelSize: 11
                font.family: "RedHatDisplay"
                font.weight: 400
                color: "#a0a0ff"
                visible: text !== "" && loginScreen.state !== "authenticating" && (capslockWarning ? loginScreen.userNeedsPassword : true)
                opacity: visible ? 1.0 : 0.0
                anchors.top: loginArea.bottom
                anchors.topMargin: visible ? 8 : 0

                Component.onCompleted: {
                    if (root.capsLockOn)
                        loginMessage.warn(textConstants.capslockWarning || "Caps Lock is on", "warning");

                    anchors.horizontalCenter = parent.horizontalCenter;
                }

                Behavior on anchors.topMargin {
                    enabled: true
                    NumberAnimation {
                        duration: 150
                    }
                }

                function warn(message, type) {
                    clear();
                    text = message;
                    color = type === "error" ? "#ff1a4d" : (type === "warning" ? "#ffe066" : "#a0a0ff");
                    if (message === (textConstants.capslockWarning || "Caps Lock is on"))
                        capslockWarning = true;
                }

                function clear() {
                    text = "";
                    capslockWarning = false;
                }
            }
        }
    }

    MenuArea {}

    Keys.onPressed: function (event) {
        if (event.key === Qt.Key_Escape) {
            if (loginScreen.state === "authenticating") {
                event.accepted = false;
                return;
            }
            if (true) { // Was root.lockScreenDisplay
                loginScreen.close();
            }
            password.text = "";
        } else if (event.key === Qt.Key_CapsLock) {
            root.capsLockOn = !root.capsLockOn;
        }
        event.accepted = true;
    }

    MouseArea {
        id: closeUserSelectorMouseArea
        z: -1
        anchors.fill: parent
        hoverEnabled: true
        onClicked: {
            if (loginScreen.state === "selectingUser") {
                safeStateChange("normal");
            }
        }
        onWheel: event => {
            if (loginScreen.state === "selectingUser") {
                if (event.angleDelta.y < 0) {
                    userSelector.nextUser();
                } else {
                    userSelector.prevUser();
                }
            }
        }
    }
}
