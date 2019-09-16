import QtQuick 2.12
import QtQuick.Window 2.13
import QtQuick.Layouts 1.12
import BackEnd 1.0 as BackEnd
import "fonts/SourceSansPro" as SSP

Rectangle {
    color: "red"
    Component.onCompleted: backEnd.start()

    BackEnd.Display {
        id: backEnd

        function _onDateChanged(date) {
            txtDate.text = date;
        }

        function _onClockChanged(clock) {
            txtClock.text = clock;
        }

        onDateChanged: (date) => _onDateChanged(date)
        onClockChanged: (clock) => _onClockChanged(clock)
    }

    Rectangle {
        id: header

        function _height() {
            var screenHeight = Screen.desktopAvailableHeight;
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
                id: txtDate

                function _pointSize() {
                    return header.height / 50 * 15;
                }

                Layout.fillWidth: true
                Layout.fillHeight: true
                text: "Senin, 9 September 2019 M / 9 Muharram 1441 H"
                color: "#FFF"
                font.weight: Font.DemiBold
                font.family: SSP.Fonts.semiBold
                font.pointSize: _pointSize()
                verticalAlignment: Text.AlignVCenter
            }

            Text {
                id: txtClock

                function _pointSize() {
                    return header.height / 50 * 17;
                }

                Layout.fillHeight: true
                text: "15:04:05"
                color: "#FFF"
                font.weight: Font.Bold
                font.family: "Ubuntu Mono"
                font.pointSize: _pointSize()
                verticalAlignment: Text.AlignVCenter
            }
        }
    }

    Rectangle {
        id: footer

        function _height() {
            var screenHeight = Screen.desktopAvailableHeight;
            return screenHeight / 900 * 30;
        }

        height: _height()
        color: "yellow"
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: parent.bottom
    }
}