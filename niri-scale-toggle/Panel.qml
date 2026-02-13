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
        // Load saved scale from settings
        if (pluginApi?.pluginSettings?.lastScale !== undefined) {
            currentScaleValue = pluginApi.pluginSettings.lastScale
            console.log("Restored scale from settings:", currentScaleValue)
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
                        console.log("Reload config clicked")
                        reloadNiriConfig()
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
        console.log("Applying scale:", scale, "to output:", currentOutput)
        currentScaleValue = scale
        // Save to plugin settings for persistence
        if (pluginApi?.pluginSettings) {
            pluginApi.pluginSettings.lastScale = scale
            console.log("Saved scale to settings:", scale)
        }
        // Update the command with the new scale value
        scaleProcess.command = ["/usr/bin/niri", "msg", "output", currentOutput, "scale", scale.toString()]
        console.log("Executing:", scaleProcess.command)
        scaleProcess.running = true
    }

    function reloadNiriConfig() {
        console.log("Reloading Niri config")
        console.log("Executing reload command")
        reloadProcess.running = true
    }

    function syncCurrentScale() {
        console.log("Syncing current scale from Niri")
        // Run niri msg outputs and extract the scale value for eDP-1
        syncProcess.running = true
        console.log("Scale sync initiated - it will be updated in the background")
    }
}
