import QtQuick 2.12
import QtQuick.Layouts 1.12
import QtQuick.Shapes 1.12
import "../fonts/SourceSansPro" as SSP

Rectangle {
    id: root

    property int screenWidth
    property int screenHeight
    property alias title: txtTitle.text
    property alias value: txtValue.text

    function _titleSize() {
        var titleSize = Math.round(screenHeight / 900 * 10);
        return titleSize > 10 ? titleSize : 10;
    }

    function _valueSize() {
        var valueSize = Math.round(screenHeight / 900 * 25);
        return valueSize > 25 ? valueSize : 25;
    }

    function _arrowWidth() {
        var arrowWidth = Math.round(tooltip.width / 96 * 30);
        return arrowWidth;
    }

    function _halfArrowWidth() {
        return Math.round(_arrowWidth() / 2);
    }

    color: "transparent"
    width: columnTooltip.width + 16
    height: columnTooltip.height + _halfArrowWidth() + 16

    Rectangle {
        radius: 8
        color: "#000"
        opacity: 0.75
        anchors { fill: parent; bottomMargin: _halfArrowWidth() }
    }

    Shape {
        opacity: 0.75

        ShapePath {
            fillColor: "#000"
            strokeWidth: -1
            startY: tooltip.height - tooltip._halfArrowWidth()
            startX: Math.round((tooltip.width - tooltip._arrowWidth()) / 2)
            PathLine { relativeY: 0; relativeX: tooltip._arrowWidth() }
            PathLine { relativeY: tooltip._halfArrowWidth(); relativeX: -tooltip._halfArrowWidth() }
        }
    }

    ColumnLayout {
        id: columnTooltip

        spacing: 0
        anchors.top: parent.top
        anchors.topMargin: 8
        anchors.horizontalCenter: parent.horizontalCenter

        Text {
            id: txtTitle

            color: "#FFF"
            Layout.fillWidth: true
            horizontalAlignment: Text.AlignHCenter
            font { family: SSP.Fonts.regular; pointSize: tooltip._titleSize() }
        }

        Text {
            id: txtValue

            color: "#FFF"
            Layout.fillWidth: true
            horizontalAlignment: Text.AlignHCenter
            font { family: SSP.Fonts.semiBold; pointSize: 25 }
        }
    }
}