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

	function _paddingSize() {
		var padding = Math.round(width / 1600 * 12);
		return padding >= 8 ? padding : 8;
	}

	function _dateFontSize() {
        var fs = Math.round(width / 1600 * 16);
		return fs >= 12 ? fs : 12;
	}

	function _countdownFontSize() {
        var fs = Math.round(width / 1600 * 22);
		return fs >= 15 ? fs : 15;
	}

    function _countdownText() {
        var targetData = target || {},
            targetName = targetData.name || "",
            targetTime = targetData.seconds || 0;
        
        if (targetName === "" || targetTime === 0) return "";

        // Calculate countdown
		var diffSeconds = targetTime - currentSeconds,
			diffMinutes = 0, 
			diffHours = 0, 
			countdown = 0;
		
		if (diffSeconds >= 3600) {
			diffHours = Math.floor(diffSeconds / 3600);
			diffMinutes = Math.floor((diffSeconds - diffHours * 3600) / 60);
			diffSeconds = diffSeconds - diffHours * 3600 - diffMinutes * 60;
		} else if (diffSeconds >= 60) {
			diffMinutes = Math.floor(diffSeconds / 60);
			diffSeconds = diffSeconds - diffMinutes * 60;
		}

        if (diffHours > 0) {
			countdown = `${diffHours} jam ${diffMinutes} menit lagi`;
		} else if (diffMinutes > 0) {
			countdown = `${diffMinutes} menit ${diffSeconds} detik lagi`;
		} else {
			countdown = `${diffSeconds} detik lagi`;
		}

        return `${targetName} ${countdown}`;
    }

    color: "transparent"
	implicitHeight: content.height + (_paddingSize() * 2)

    Rectangle {
        color: "#000"
        opacity: 0.6
		anchors.fill: parent
    }

    RowLayout {
		id: content

		width: root.width
        spacing: root._paddingSize()
		anchors.top: parent.top
		anchors.left: parent.left
		anchors.right: parent.right
		anchors.margins: root._paddingSize()

        Text {
            id: txtClock

            color: "yellow"
            verticalAlignment: Text.AlignVCenter
            Layout.fillHeight: true
			font.bold: true
			font.family: SSP.Fonts.regular
			font.pointSize: root._dateFontSize()
        }

        Text {
            id: txtDate

            color: "#FFF"
            verticalAlignment: Text.AlignVCenter
            Layout.fillWidth: true
            Layout.fillHeight: true
			font.family: SSP.Fonts.semiBold
			font.pointSize: root._dateFontSize()
        }

        Text {
            color: txtDate.color
            text: root._countdownText()
            verticalAlignment: Text.AlignVCenter
            Layout.fillHeight: true
			font.family: SSP.Fonts.semiBold
			font.pointSize: root._countdownFontSize()
        }
    }
}