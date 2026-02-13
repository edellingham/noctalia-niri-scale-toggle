import QtQuick
import QtQuick.Layouts
import QtQuick.Controls

import Quickshell
import Quickshell.Io
import qs.Commons
import qs.Widgets
import qs.Services.UI

Item {
    id: root

    property var pluginApi: null
    property string section: ""

    // Configuration
    property var scalePresets: [1.0, 1.25, 1.5, 1.75, 2.0, 2.25, 2.5]
    property real currentScaleValue: 1.0
    property int currentScaleIndex: 0
    property string currentOutput: "eDP-1"
    property real contentPreferredWidth: 300 * Style.uiScaleRatio

    anchors.fill: parent

    Component.onCompleted: {
        console.log("Panel.qml loaded")
        console.log("pluginApi:", pluginApi)
        console.log("pluginSettings:", pluginApi?.pluginSettings)
        // Load saved scale from settings
        if (pluginApi?.pluginSettings?.lastScale !== undefined) {
            currentScaleValue = pluginApi.pluginSettings.lastScale
            console.log("Restored scale from settings:", currentScaleValue)
        } else {
            console.log("No saved scale found in settings")
        }
    }

    Process {
        id: scaleProcess
        command: ["/usr/bin/niri", "msg", "output", "eDP-1", "scale", "1.0"]
    }

    Process {
        id: reloadProcess
        command: ["/usr/bin/niri", "msg", "action", "load-config-file"]
    }

    Process {
        id: syncProcess
        command: ["/bin/bash", "-c", "niri msg outputs | grep -A 20 'eDP-1' | grep scale | head -1 | grep -o '[0-9.]*' | head -1"]
    }

    Rectangle {
        id: panelContainer
        anchors.fill: parent
        color: "transparent"

        ColumnLayout {
            anchors {
                fill: parent
                margins: 8
            }
            spacing: 4

            Text {
                text: "Display Scale"
                color: Color.mOnSurface
                font.pixelSize: 14
                font.weight: Font.Bold
            }

            Text {
                text: "Current scale: " + root.currentScaleValue.toFixed(2) + "x"
                color: Color.mOnSurfaceVariant
                font.pixelSize: 12
            }

            ColumnLayout {
                Layout.fillWidth: true
                spacing: 4

                Repeater {
                    model: root.scalePresets.length

                    NButton {
                        Layout.fillWidth: true
                        height: 32

                        text: root.scalePresets[index].toFixed(2) + "x (" +
                              Math.round(root.scalePresets[index] * 100) + "%)"

                        onClicked: {
                            console.log("Selected scale:", root.scalePresets[index])
                            applyScale(root.scalePresets[index])
                            root.currentScaleIndex = index
                        }
                    }
                }
            }

            Rectangle {
                Layout.fillWidth: true
                height: 1
                color: Color.mOutline
            }

            RowLayout {
                Layout.fillWidth: true
                spacing: 4

                NButton {
                    Layout.fillWidth: true
                    height: 32
                    text: "Reload Config"

                    onClicked: {
                        console.log(">>> RELOAD CONFIG BUTTON CLICKED")
                        reloadNiriConfig()
                        console.log(">>> Reload function returned")
                    }
                }

                NButton {
                    Layout.fillWidth: true
                    height: 32
                    text: "Sync Scale"

                    onClicked: {
                        console.log("Sync scale clicked")
                        syncCurrentScale()
                    }
                }
            }

            Item {
                Layout.fillHeight: true
            }
        }
    }

    // Functions
    function applyScale(scale) {
        console.log(">>> applyScale() called with scale:", scale)
        console.log(">>> Setting currentScaleValue to:", scale)
        currentScaleValue = scale
        console.log(">>> currentScaleValue is now:", currentScaleValue)

        // Save to plugin settings for persistence
        console.log(">>> Checking pluginApi:", pluginApi)
        console.log(">>> Checking pluginSettings:", pluginApi?.pluginSettings)
        if (pluginApi?.pluginSettings) {
            console.log(">>> Saving scale to pluginSettings")
            pluginApi.pluginSettings.lastScale = scale
            console.log(">>> Saved! pluginSettings.lastScale =", pluginApi.pluginSettings.lastScale)
        } else {
            console.log(">>> pluginSettings not available!")
        }

        // Update the command with the new scale value
        console.log(">>> Setting scaleProcess command")
        scaleProcess.command = ["/usr/bin/niri", "msg", "output", currentOutput, "scale", scale.toString()]
        console.log(">>> Command:", scaleProcess.command)
        scaleProcess.running = true
        console.log(">>> scaleProcess.running set to true")
    }

    function reloadNiriConfig() {
        console.log(">>> reloadNiriConfig() called")
        console.log(">>> About to set reloadProcess.running = true")
        reloadProcess.running = true
        console.log(">>> reloadProcess.running set to true")
    }

    function syncCurrentScale() {
        console.log(">>> syncCurrentScale() called")
        console.log(">>> About to set syncProcess.running = true")
        syncProcess.running = true
        console.log(">>> syncProcess.running set to true")
    }
}
