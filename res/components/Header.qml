import QtQuick 2.12
import QtQuick.Layouts 1.12
import "../fonts/SourceSansPro" as SSP

Rectangle {
    id: root

    property var target: {}
    property int currentSeconds: 0
    property string date
    property string clock
	property string fontColor
	property string mainColor
	property string accentColor

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
			if (diffMinutes === 0) {
				countdown = `${diffHours} jam lagi`;
			} else {
				countdown = `${diffHours} jam ${diffMinutes} menit lagi`;
			}
		} else if (diffMinutes > 0) {
			if (diffSeconds === 0) {
				countdown = `${diffMinutes} menit lagi`;
			} else {
				countdown = `${diffMinutes} menit ${diffSeconds} detik lagi`;
			}
		} else {
			countdown = `${diffSeconds} detik lagi`;
		}

        return `${targetName} ${countdown}`;
    }

    color: "transparent"
	implicitHeight: content.height + (_paddingSize() * 2)

    Rectangle {
        opacity: 0.7
        color: root.mainColor
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
			function _color() {
				if (root.fontColor === "#FFF") return "#FF0";
				else return "#00F";
			}

			text: root.clock
            color: _color()
            verticalAlignment: Text.AlignVCenter
            Layout.fillHeight: true
			font.bold: true
			font.family: SSP.Fonts.regular
			font.pointSize: root._dateFontSize()
        }

        Text {
			text: root.date
            color: root.fontColor
            verticalAlignment: Text.AlignVCenter
            Layout.fillWidth: true
            Layout.fillHeight: true
			font.family: SSP.Fonts.semiBold
			font.pointSize: root._dateFontSize()
        }

        Text {
            color: root.fontColor
            text: root._countdownText()
            verticalAlignment: Text.AlignVCenter
            Layout.fillHeight: true
			font.family: SSP.Fonts.semiBold
			font.pointSize: root._countdownFontSize()
        }
    }
}