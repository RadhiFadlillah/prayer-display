import QtQuick 2.12
import QtQuick.Layouts 1.12
import BackEnd 1.0 as BackEnd
import "components" as Components
import "fonts/SourceSansPro" as SSP

Rectangle {
    id: root

    color: "cyan"
    Component.onCompleted: backEnd.start()

    BackEnd.Display {
        id: backEnd

        property var prayerData: []

        function _onDateChanged(date, jsonPrayerData) {
            // Save prayer data
            backEnd.prayerData = JSON.parse(jsonPrayerData);

            // Send data to components
            header.date = date;
            footer.prayerData = backEnd.prayerData;
        }

        function _onClockChanged(clock, seconds) {
            // Get current target
            var target = {};
            for (var i = 0; i < prayerData.length; i++) {
                var data = prayerData[i];

                if (seconds < data.start) {
                    target = {
                        index: i,
                        name: data.name,
                        time: data.adhan,
                        seconds: data.start,
                    };
                    break
                }

                if (seconds < data.finish) {
                    target = {
                        index: i,
                        name: `Iqamah ${data.name}`,
                        time: data.iqamah,
                        seconds: data.finish,
                    };
                    break
                }
            }

            // Set header data
            header.target = target;
            header.currentSeconds = seconds;
            header.clock = clock;

            // Set footer data
            footer.target = target;
            footer.currentSeconds = seconds;

            // Set tooltip data
            var targetPrayer = prayerData[target.index],
                targetLength = targetPrayer.finish - targetPrayer.start || 300,
                targetX = Math.round(root.width / 86400 * targetPrayer.start),
                targetWidth = Math.round(root.width / 86400 * targetLength);
            
            tooltip.title = target.name;
            tooltip.value = target.time;
            tooltip.x = targetX - (tooltip.width / 2) + (targetWidth / 2);
        }

        onDateChanged: (date, prayer) => _onDateChanged(date, prayer)
        onClockChanged: (clock, seconds) => _onClockChanged(clock, seconds)
    }

    Components.Header {
        id: header

        function _height() {
            var screenHeight = root.height;
            return screenHeight / 900 * 50;
        }

        color: "black"
        anchors { top: parent.top; left: parent.left; right: parent.right }
        height: _height()
    }

    Components.Tooltip {
        id: tooltip

        x: 100
        y: root.height - footer.height - height - 16
        screenWidth: root.width
        screenHeight: root.height
    }

    Components.Footer {
        id: footer

        function _height() {
            var screenHeight = root.height;
            return screenHeight / 900 * 30;
        }

        color: "black"
        anchors { left: parent.left; right: parent.right; bottom: parent.bottom }
        height: _height()
    }
}