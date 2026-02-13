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
    property var scalePresets: [1.0, 1.25, 1.5, 1.75, 2.0]
    property int currentScaleIndex: 0
    property string currentOutput: "eDP-1"
    property real contentPreferredWidth: 300 * Style.uiScaleRatio

    anchors.fill: parent

    Process {
        id: scaleProcess
        command: ["/usr/bin/niri", "msg", "output", "eDP-1", "scale", "1.0"]
    }

    Process {
        id: reloadProcess
        command: ["/usr/bin/niri", "msg", "action", "load-config-file"]
    }

    Rectangle {
        id: panelContainer
        anchors.fill: parent
        color: "transparent"

        ColumnLayout {
            anchors {
                fill: parent
                margins: 16
            }
            spacing: 8

            Text {
                text: "Display Scale"
                color: Color.mOnSurface
                font.pixelSize: 14
                font.weight: Font.Bold
            }

            Text {
                text: "Current scale: " + root.scalePresets[root.currentScaleIndex].toFixed(2) + "x"
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
                        height: 40

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

            NButton {
                Layout.fillWidth: true
                height: 40
                text: "Reload Niri Config"

                onClicked: {
                    console.log("Reload config clicked")
                    reloadNiriConfig()
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
}
