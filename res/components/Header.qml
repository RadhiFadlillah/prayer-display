import QtQuick 2.12
import QtQuick.Layouts 1.12
import "../fonts/SourceSansPro" as SSP

Rectangle {
    id: root

    property var target: {}
    property int currentSeconds: 0
    property alias date: txtDate.text
    property alias clock: txtClock.text
    property alias dateColor: txtDate.color
    property alias clockColor: txtClock.color

    function _fontSize() {
        return Math.round(height / 50 * 15) || 15;
    }

    function _countdownText() {
        var targetData = target || {},
            targetName = targetData.name || "",
            targetTime = targetData.seconds || 0;
        
        if (targetName === "" || targetTime === 0) return "";

        // Calculate countdown
        var diffSeconds = targetTime - currentSeconds,
            diffMinutes = Math.floor(diffSeconds / 60),
            diffHours = Math.floor(diffSeconds / 3600),
            countdown;

        if (diffHours > 0) countdown = `${diffHours} jam lagi`;
        else if (diffMinutes > 0) countdown = `${diffMinutes} menit lagi`;
        else countdown = `${diffSeconds} detik lagi`;

        return `${targetName} ${countdown}`;
    }

    color: "transparent"

    Rectangle {
        color: "#000"
        opacity: 0.6
        anchors.fill: parent
    }

    RowLayout {
        spacing: 0
        anchors { fill: parent; leftMargin: 16; rightMargin: 16 }

        Text {
            id: txtClock

            color: "yellow"
            rightPadding: 16
            verticalAlignment: Text.AlignVCenter
            Layout.fillHeight: true
            font { bold: true; family: SSP.Fonts.regular; pointSize: root._fontSize() }
        }

        Text {
            id: txtDate

            color: "#FFF"
            verticalAlignment: Text.AlignVCenter
            Layout.fillWidth: true
            Layout.fillHeight: true
            font { family: SSP.Fonts.semiBold; pointSize: root._fontSize() }
        }

        Text {
            leftPadding: 8
            color: txtDate.color
            text: root._countdownText()
            verticalAlignment: Text.AlignVCenter
            Layout.fillHeight: true
            font { family: SSP.Fonts.semiBold; pointSize: root._fontSize() }
        }
    }
}