import QtQuick 2.12
import QtQuick.Layouts 1.12

Rectangle {
    id: root

    property var target: {}
    property var prayerData: []
    property int currentSeconds: 0
    property alias progressColor: progressBar.color

    color: "transparent"

    Rectangle {
        color: "#000"
        opacity: 0.6
        anchors.fill: parent
    }

    Rectangle {
        id: progressBar

        function _width() {
            return Math.round(root.width / 86400 * root.currentSeconds);
        }

        color: "#333"
        height: parent.height
        width: _width()
    }

    Repeater {
        model: root.prayerData.length

        Rectangle {
            function _color() {
                var targetData = root.target || {},
                    targetIndex = targetData.index || -1;

                if (index === targetIndex) return "#F00";
                else if (targetIndex === 6 && index === 0) return "#F00";
                else return "#CCC";
            }

            function _width() {
                var data = root.prayerData[index],
                    screenWidth = root.width,
                    segmentLength = data.finish - data.start || 300;
                return Math.round(screenWidth / 86400 * segmentLength);
            }

            function _x() {
                var data = root.prayerData[index],
                    screenWidth = root.width;
                return Math.round(screenWidth / 86400 * data.start);
            }

            color: _color()
            height: parent.height
            width: _width()
            x: _x()
        }
    }
}