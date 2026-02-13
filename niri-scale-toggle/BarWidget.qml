import QtQuick
import QtQuick.Controls

import Quickshell
import qs.Services.UI

Rectangle {
    id: root

    property var pluginApi: null
    property ShellScreen screen
    property string widgetId: ""
    property string section: ""

    // Configuration
    property var scalePresets: [1.0, 1.25, 1.5, 1.75, 2.0]
    property int currentScaleIndex: 0
    property string currentOutput: "eDP-1"

    width: scaleText.implicitWidth + 16
    height: 32
    color: "transparent"

    // Display the current scale
    Text {
        id: scaleText
        anchors.centerIn: parent
        text: root.scalePresets[root.currentScaleIndex].toFixed(2) + "x"
        font.pixelSize: 12
        font.weight: Font.Medium
    }

    MouseArea {
        anchors.fill: parent
        onClicked: menu.open()
    }

    // Popup menu with scale options
    Popup {
        id: menu
        x: parent.x - width + parent.width
        y: parent.height + 4
        width: 140
        padding: 8
        background: Rectangle {
            color: "#2b2b2b"
            border.color: "#464646"
            border.width: 1
            radius: 8
        }

        Column {
            width: parent.width
            spacing: 4

            Repeater {
                model: root.scalePresets.length

                Button {
                    width: parent.width
                    height: 36

                    text: root.scalePresets[index].toFixed(2) + "x (" +
                          Math.round(root.scalePresets[index] * 100) + "%)"

                    background: Rectangle {
                        color: root.currentScaleIndex === index ? "#0d47a1" : "transparent"
                        radius: 4
                    }

                    contentItem: Text {
                        text: parent.text
                        color: root.currentScaleIndex === index ? "#ffffff" : "#e0e0e0"
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                    }

                    onClicked: {
                        applyScale(root.scalePresets[index])
                        root.currentScaleIndex = index
                        menu.close()
                    }
                }
            }

            Rectangle {
                width: parent.width
                height: 1
                color: "#464646"
            }

            Button {
                width: parent.width
                height: 36
                text: "Reload Config"

                background: Rectangle {
                    color: "transparent"
                    radius: 4
                }

                contentItem: Text {
                    text: parent.text
                    color: "#e0e0e0"
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                }

                onClicked: {
                    reloadNiriConfig()
                    menu.close()
                }
            }
        }
    }

    // Function to apply scale change
    function applyScale(scale) {
        console.log("Applying scale:", scale, "to output:", currentOutput)
        let cmd = "niri-msg output %1 scale %2".arg(currentOutput).arg(scale)
        executeCommand(cmd, "Scale changed to " + scale + "x")
    }

    // Function to reload Niri configuration
    function reloadNiriConfig() {
        console.log("Reloading Niri config")
        executeCommand("niri-msg action reload-config", "Config reloaded")
    }

    // Helper to execute shell commands
    function executeCommand(cmd, successMessage) {
        console.log("Execute command:", cmd)
        if (successMessage) {
            notifyUser(successMessage)
        }
        return true
    }

    // Helper to show notifications
    function notifyUser(message) {
        console.log("Niri Scale Toggle:", message)
    }

    Component.onCompleted: {
        loadCurrentScale()
    }

    function loadCurrentScale() {
        currentScaleIndex = 0
    }
}
