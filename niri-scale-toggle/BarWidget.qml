import QtQuick
import QtQuick.Layouts
import QtQuick.Controls

import Noctalia.Shell

PanelItem {
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
        color: Noctalia.colors.foreground
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
            color: Noctalia.colors.surface
            border.color: Noctalia.colors.surfaceVariant
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
                            ? Noctalia.colors.primary
                            : "transparent"
                        radius: 4
                    }

                    contentItem: Text {
                        text: root.scalePresets[index].toFixed(2) + "x (" +
                              Math.round(root.scalePresets[index] * 100) + "%)"
                        color: currentScaleIndex === index
                            ? Noctalia.colors.onPrimary
                            : Noctalia.colors.foreground
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
                color: Noctalia.colors.surfaceVariant
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
                    color: Noctalia.colors.onSurface
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
        try {
            let process = Noctalia.Process.create()
            process.start("/bin/bash", ["-c", cmd])
            process.waitForFinished()

            if (successMessage && process.exitCode === 0) {
                notifyUser(successMessage)
            }

            return process.exitCode === 0
        } catch (e) {
            console.warn("Command execution failed:", cmd, e)
            return false
        }
    }

    // Helper to show notifications
    function notifyUser(message) {
        Noctalia.notify({
            title: "Niri Scale Toggle",
            body: message,
            urgency: "normal",
            timeout: 2000
        })
    }

    Component.onCompleted: {
        // Initialize current scale from config if possible
        loadCurrentScale()
    }

    function loadCurrentScale() {
        // Try to read current scale from niri-msg status
        try {
            let process = Noctalia.Process.create()
            process.start("/bin/bash", ["-c", "niri-msg outputs"])
            process.waitForFinished()

            // For now, default to first preset
            // In a full implementation, parse the output to find current scale
            currentScaleIndex = 0
        } catch (e) {
            console.warn("Could not determine current scale")
        }
    }
}
