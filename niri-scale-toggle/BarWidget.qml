import QtQuick
import QtQuick.Layouts
import Quickshell
import qs.Commons
import qs.Widgets
import qs.Services.UI
import qs.Services.System

NIconButton {
    id: root

    property var pluginApi: null
    property ShellScreen screen
    property string widgetId: ""
    property string section: ""

    // Configuration
    property var scalePresets: [1.0, 1.25, 1.5, 1.75, 2.0]
    property int currentScaleIndex: 0
    property string currentOutput: "eDP-1"

    // Icon settings
    icon: "view-fullscreen"
    tooltipText: scalePresets[currentScaleIndex].toFixed(2) + "x - Click to adjust scale"
    tooltipDirection: BarService.getTooltipDirection()
    baseSize: Style.capsuleHeight
    applyUiScale: false
    customRadius: Style.radiusL
    colorBg: Style.capsuleColor
    colorFg: Color.mOnSurface
    colorBgHover: Color.mHover
    colorFgHover: Color.mOnHover
    colorBorder: "transparent"
    colorBorderHover: "transparent"

    border.color: Style.capsuleBorderColor
    border.width: Style.capsuleBorderWidth

    onClicked: {
        console.log("Scale button clicked, opening panel")
        pluginApi.openPanel(root.screen, this)
    }

    Component.onCompleted: {
        console.log("Niri Scale Toggle BarWidget loaded")
    }
}
