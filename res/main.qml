import QtQuick 2.12
import QtQuick.Layouts 1.12
import BackEnd 1.0 as BackEnd
import "fonts/SourceSansPro" as SSP

Rectangle {
    id: root

    color: "cyan"
    Component.onCompleted: backEnd.start()

    BackEnd.Display {
        id: backEnd

        property var prayerData: []
        property int currentSeconds: 0
        property int currentTarget: -1
        property bool targetIsIqamah: false

        function _onDateChanged(date, jsonPrayerData) {
            // Show date
            txtDate.text = date;

            // Save prayer data
            backEnd.prayerData = JSON.parse(jsonPrayerData);
        }

        function _onClockChanged(clock, seconds) {
            // Show clock
            txtClock.text = clock;

            // Save data
            currentSeconds = seconds;

            // Get current target
            var targetIndex = -1,
                isIqamah = false;

            for (var i = 0; i < prayerData.length; i++) {
                if (currentSeconds < prayerData[i].start) {
                    targetIndex = i;
                    break;
                }

                if (currentSeconds < prayerData[i].finish) {
                    targetIndex = i;
                    isIqamah = true;
                    break;
                }
            }

            backEnd.currentTarget = targetIndex;
            backEnd.targetIsIqamah = isIqamah;
        }

        onDateChanged: (date, prayer) => _onDateChanged(date, prayer)
        onClockChanged: (clock, seconds) => _onClockChanged(clock, seconds)
    }

    Rectangle {
        id: header

        function _height() {
            var screenHeight = root.height;
            return screenHeight / 900 * 50;
        }

        height: _height()
        color: "black"
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.right: parent.right

        RowLayout {
            spacing: 0
            anchors.fill: parent
            anchors.leftMargin: 16
            anchors.rightMargin: 16

            Text {
                id: txtClock

                function _pointSize() {
                    return header.height / 50 * 15 || 15;
                }

                Layout.fillHeight: true
                text: "15:04:05"
                color: "yellow"
                rightPadding: 8
                font.weight: Font.Bold
                font.family: "Ubuntu Mono"
                font.pointSize: _pointSize()
                verticalAlignment: Text.AlignVCenter
            }

            Text {
                id: txtDate

                function _pointSize() {
                    return header.height / 50 * 15 || 15;
                }

                Layout.fillWidth: true
                Layout.fillHeight: true
                text: "Senin, 9 September 2019 M / 9 Muharram 1441 H"
                color: "#FFF"
                font.family: SSP.Fonts.semiBold
                font.pointSize: _pointSize()
                verticalAlignment: Text.AlignVCenter
            }

            Text {
                id: txtCountdown

                function _text() {
                    if (backEnd.currentTarget === -1) return "";

                    // Get target name
                    var target = backEnd.prayerData[backEnd.currentTarget],
                        targetName = target.name;

                    // Calculate countdown
                    var targetTime = backEnd.targetIsIqamah ? target.finish : target.start,
                        diffSeconds = targetTime - backEnd.currentSeconds,
                        diffMinutes = Math.round(diffSeconds / 60),
                        diffHours = Math.round(diffSeconds / 3600),
                        countdown;

                    if (diffHours > 0) countdown = `${diffHours} jam lagi`;
                    else if (diffMinutes > 0) countdown = `${diffMinutes} menit lagi`;
                    else countdown = `${diffSeconds} detik lagi`;

                    return `${targetName} ${countdown}`;
                }

                function _pointSize() {
                    return header.height / 50 * 15 || 15;
                }

                leftPadding: 8
                color: "#FFF"
                text: _text()
                font.family: SSP.Fonts.semiBold
                font.pointSize: _pointSize()
                verticalAlignment: Text.AlignVCenter
                Layout.fillHeight: true
            }
        }
    }

    Rectangle {
        id: footer

        function _height() {
            var screenHeight = root.height;
            return screenHeight / 900 * 30;
        }

        height: _height()
        color: "black"
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: parent.bottom

        Rectangle {
            function _width() {
                var screenWidth = root.width;
                return screenWidth / (24*60*60) * backEnd.currentSeconds;
            }

            color: "#333"
            height: parent.height
            width: _width()
        }

        Repeater {
            model: backEnd.prayerData.length

            Rectangle {
                function _color() {
                    if (index === backEnd.currentTarget) return "#F00";
                    else if (backEnd.currentTarget === 6 && index === 0) return "#F00";
                    else return "#CCC";
                }

                function _width() {
                    var data = backEnd.prayerData[index],
                        screenWidth = root.width,
                        segmentLength = data.finish - data.start || 300;
                    return screenWidth / (24*60*60) * segmentLength;
                }

                function _x() {
                    var data = backEnd.prayerData[index],
                        screenWidth = root.width;
                    return screenWidth / (24*60*60) * data.start;
                }

                color: _color()
                height: parent.height
                width: _width()
                x: _x()
            }
        }
    }
}