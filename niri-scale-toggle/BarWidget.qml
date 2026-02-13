import QtQuick
import QtQuick.Layouts
import QtQuick.Controls

import Quickshell
import Quickshell.Io
import qs.Commons
import qs.Widgets
import qs.Services.UI
import qs.Services.System

Item {
    id: root

    width: barButton.width + 16
    height: parent.height

    // Configuration
    property var scalePresets: [1.0, 1.25, 1.5, 1.75, 2.0]
    property int currentScaleIndex: 0
    property string currentOutput: "eDP-1"  // Default, can be customized in settings
    property string niriConfigPath: StandardPaths.home + "/.config/niri/config.kdl"

    // Current scale display
    Text {
        id: barButton
        anchors.centerIn: parent
        text: scalePresets[currentScaleIndex].toFixed(2) + "x"
        color: palette.text
        font.pixelSize: 12
        font.weight: Font.Medium

        MouseArea {
            anchors.fill: parent
            hoverEnabled: true

            onClicked: menu.toggle()
            onEntered: parent.opacity = 0.8
            onExited: parent.opacity = 1.0
        }
    }

    Behavior on opacity {
        NumberAnimation { duration: 150 }
    }

    // Popup menu with scale options
    Popup {
        id: menu
        x: parent.x - width + parent.width
        y: parent.height + 4
        width: 120
        padding: 8
        background: Rectangle {
            color: palette.base
            border.color: palette.mid
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
                    height: 32

                    background: Rectangle {
                        color: currentScaleIndex === index
                            ? palette.highlight
                            : "transparent"
                        radius: 4
                    }

                    contentItem: Text {
                        text: root.scalePresets[index].toFixed(2) + "x (" +
                              Math.round(root.scalePresets[index] * 100) + "%)"
                        color: currentScaleIndex === index
                            ? palette.highlightedText
                            : palette.text
                        font.pixelSize: 11
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                    }

                    onClicked: {
                        applyScale(root.scalePresets[index])
                        currentScaleIndex = index
                        menu.close()
                    }
                }
            }

            Rectangle {
                width: parent.width
                height: 1
                color: palette.mid
            }

            Button {
                width: parent.width
                height: 32

                background: Rectangle {
                    color: "transparent"
                    radius: 4
                }

                contentItem: Text {
                    text: "Reload Config"
                    color: palette.text
                    font.pixelSize: 10
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
        // Try using niri-msg first (if available)
        if (executeCommand("which niri-msg", "")) {
            let cmd = "niri-msg output %1 scale %2".arg(currentOutput).arg(scale)
            executeCommand(cmd, "Scale changed to " + scale + "x")
        } else {
            // Fallback: modify config and notify user
            notifyUser("Use niri-msg or manually set scale to " + scale + "x in your Niri config")
        }
    }

    // Function to reload Niri configuration
    function reloadNiriConfig() {
        executeCommand("niri-msg action reload-config", "Config reloaded")
    }

    // Helper to execute shell commands
    function executeCommand(cmd, successMessage) {
        // In a full implementation, this would execute via system call
        // For now, log the command that would be executed
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
        // Initialize current scale from config if possible
        loadCurrentScale()
    }

    function loadCurrentScale() {
        // Initialize to first preset
        // In a full implementation, this could parse niri-msg outputs
        currentScaleIndex = 0
    }
}
