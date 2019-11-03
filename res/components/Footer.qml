import QtQuick 2.12
import QtQuick.Layouts 1.12

Rectangle {
    id: root

    property var target: {}
    property var prayerData: []

	function _spacingSize() {
		var spacing = Math.round(width / 1600 * 8);
		return spacing >= 8 ? spacing : 8;
	}

    color: "transparent"
	height: content.height

	RowLayout {
		id: content

		width: root.width
		spacing: root._spacingSize()
		anchors.left: parent.left
		anchors.right: parent.right
		anchors.verticalCenter: parent.verticalCenter

		Rectangle {
			color: "transparent"
            Layout.fillWidth: true
            Layout.fillHeight: true
			Layout.preferredWidth: 1
		}

		Repeater {
			model: root.prayerData.slice(0, 6)

			PrayerTime {
				name: modelData.name
				adhan: modelData.adhan
				iqamah: modelData.iqamah
				parentWidth: root.width
				color: "yellow"
			}
		}

		Rectangle {
			color: "transparent"
            Layout.fillWidth: true
            Layout.fillHeight: true
			Layout.preferredWidth: 1
		}
	}
}