import QtQuick 2.12
import QtQuick.Layouts 1.12
import "../fonts/SourceSansPro" as SSP

Rectangle {
	id: root

	property string name
	property string adhan
	property string iqamah
	property string bgColor
	property string fontColor
	property double parentWidth
	
	function _paddingSize() {
		var padding = Math.round(parentWidth / 1600 * 12);
		return padding >= 8 ? padding : 8;
	}

	function _nameFontSize() {
        return Math.round(parentWidth / 1600 * 15) || 15;
	}

	function _adhanFontSize() {
        return Math.round(parentWidth / 1600 * 38) || 38;
	}

	function _iqamahFontSize() {
        return Math.round(parentWidth / 1600 * 21) || 21;
	}

    color: "transparent"
	implicitWidth: content.width + (_paddingSize() * 2)
	implicitHeight: content.height + (_paddingSize() * 2)

    Rectangle {
        opacity: 0.7
        color: root.bgColor
		anchors.fill: parent
    }

	ColumnLayout {
		id: content

        spacing: 0
		anchors.top: parent.top
		anchors.left: parent.left
		anchors.margins: root._paddingSize()

		Text {
			text: root.name
			color: root.fontColor
			Layout.fillWidth: true
			horizontalAlignment: Text.AlignHCenter
			font.family: SSP.Fonts.semiBold
			font.pointSize: root._nameFontSize()
		}

		Text {
			text: root.adhan
			color: root.fontColor
			Layout.fillWidth: true
			horizontalAlignment: Text.AlignHCenter
			font.bold: true
			font.family: SSP.Fonts.regular
			font.pointSize: root._adhanFontSize()
		}

		Text {
			text: `[${root.iqamah}]`
			color: root.fontColor
			Layout.fillWidth: true
			horizontalAlignment: Text.AlignHCenter
			font.family: SSP.Fonts.semiBold
			font.pointSize: root._iqamahFontSize()
		}
	}
}