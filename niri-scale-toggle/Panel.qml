import QtQuick
import QtQuick.Layouts
import QtQuick.Controls

import Quickshell
import qs.Commons
import qs.Widgets
import qs.Services.UI

ColumnLayout {
    id: root

    property var pluginApi: null
    property string section: ""

    // Configuration
    property var scalePresets: [1.0, 1.25, 1.5, 1.75, 2.0]
    property int currentScaleIndex: 0
    property string currentOutput: "eDP-1"

    spacing: 8
    padding: 16

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

    // Functions
    function applyScale(scale) {
        console.log("Applying scale:", scale, "to output:", currentOutput)
        let cmd = "niri-msg output %1 scale %2".arg(currentOutput).arg(scale)
        executeCommand(cmd, "Scale changed to " + scale + "x")
    }

    function reloadNiriConfig() {
        console.log("Reloading Niri config")
        executeCommand("niri-msg action reload-config", "Config reloaded")
    }

    function executeCommand(cmd, successMessage) {
        console.log("Execute command:", cmd)
        if (successMessage) {
            console.log("Success:", successMessage)
        }
    }
}
