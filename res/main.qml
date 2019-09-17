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
                        time: data.start,
                    };
                    break
                }

                if (seconds < data.finish) {
                    target = {
                        index: i,
                        name: `Iqamah ${data.name}`,
                        time: data.finish,
                    };
                    break
                }
            }

            // Send data to header
            header.target = target;
            header.currentSeconds = seconds;
            header.clock = clock;

            // Send data to footer
            footer.target = target;
            footer.currentSeconds = seconds;
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