import QtQuick
import QtQuick.Layouts
import QtQuick.Controls

import Quickshell
import qs.Commons
import qs.Widgets
import qs.Services.UI

Item {
    implicitHeight: settingsColumn.implicitHeight + 32

    ColumnLayout {
        id: settingsColumn
        anchors.fill: parent
        anchors.margins: 16
        spacing: 16

        GroupBox {
            title: "Scale Presets"
            Layout.fillWidth: true

            ColumnLayout {
                anchors.fill: parent
                spacing: 8

                Text {
                    text: "Configure which scale values appear in the quick toggle menu."
                    color: palette.text
                    font.pixelSize: 11
                    wrapMode: Text.WordWrap
                }

                RowLayout {
                    spacing: 8

                    Text {
                        text: "Scale 1:"
                        color: palette.mid
                        font.pixelSize: 10
                    }

                    SpinBox {
                        id: scale1
                        from: 1
                        to: 300
                        value: 100
                        stepSize: 5

                        textFromValue: (value) => (value / 100).toFixed(2) + "x"
                        valueFromText: (text) => {
                            let num = parseFloat(text)
                            return Math.round(num * 100)
                        }
                    }

                    Item { Layout.fillWidth: true }
                }

                RowLayout {
                    spacing: 8

                    Text {
                        text: "Scale 2:"
                        color: palette.mid
                        font.pixelSize: 10
                    }

                    SpinBox {
                        id: scale2
                        from: 1
                        to: 300
                        value: 125
                        stepSize: 5

                        textFromValue: (value) => (value / 100).toFixed(2) + "x"
                        valueFromText: (text) => {
                            let num = parseFloat(text)
                            return Math.round(num * 100)
                        }
                    }

                    Item { Layout.fillWidth: true }
                }

                RowLayout {
                    spacing: 8

                    Text {
                        text: "Scale 3:"
                        color: palette.mid
                        font.pixelSize: 10
                    }

                    SpinBox {
                        id: scale3
                        from: 1
                        to: 300
                        value: 150
                        stepSize: 5

                        textFromValue: (value) => (value / 100).toFixed(2) + "x"
                        valueFromText: (text) => {
                            let num = parseFloat(text)
                            return Math.round(num * 100)
                        }
                    }

                    Item { Layout.fillWidth: true }
                }

                RowLayout {
                    spacing: 8

                    Text {
                        text: "Scale 4:"
                        color: palette.mid
                        font.pixelSize: 10
                    }

                    SpinBox {
                        id: scale4
                        from: 1
                        to: 300
                        value: 175
                        stepSize: 5

                        textFromValue: (value) => (value / 100).toFixed(2) + "x"
                        valueFromText: (text) => {
                            let num = parseFloat(text)
                            return Math.round(num * 100)
                        }
                    }

                    Item { Layout.fillWidth: true }
                }

                RowLayout {
                    spacing: 8

                    Text {
                        text: "Scale 5:"
                        color: palette.mid
                        font.pixelSize: 10
                    }

                    SpinBox {
                        id: scale5
                        from: 1
                        to: 300
                        value: 200
                        stepSize: 5

                        textFromValue: (value) => (value / 100).toFixed(2) + "x"
                        valueFromText: (text) => {
                            let num = parseFloat(text)
                            return Math.round(num * 100)
                        }
                    }

                    Item { Layout.fillWidth: true }
                }
            }
        }

        GroupBox {
            title: "Output Configuration"
            Layout.fillWidth: true

            ColumnLayout {
                anchors.fill: parent
                spacing: 8

                RowLayout {
                    spacing: 8

                    Text {
                        text: "Primary Output:"
                        color: palette.mid
                        font.pixelSize: 10
                    }

                    ComboBox {
                        id: outputSelector
                        model: ["eDP-1", "HDMI-1", "DP-1", "DP-2", "Custom"]
                        currentIndex: 0
                    }

                    Item { Layout.fillWidth: true }
                }

                Text {
                    text: "Select the monitor output to control. Run 'niri-msg outputs' to see available outputs."
                    color: palette.mid
                    font.pixelSize: 9
                    wrapMode: Text.WordWrap
                }
            }
        }

        Item { Layout.fillHeight: true }
    }
}
