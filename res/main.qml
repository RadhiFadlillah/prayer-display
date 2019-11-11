import QtQuick 2.12
import QtQuick.Layouts 1.12
import BackEnd 1.0
import "components" as Components
import "fonts/SourceSansPro" as SSP

Rectangle {
    id: root

    color: "#000"

    Timer {
        interval: 1000
        running: true
        onTriggered: backEnd.start()
    }

    BackEnd {
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

			if (seconds === target.seconds) {
				backEnd.playBeep();
			}

            // Set header data
            header.target = target;
            header.currentSeconds = seconds;
            header.clock = clock;

			// Set footer data
            footer.target = target;
        }

        function _onImageChanged(jsonData) {
			var slide = JSON.parse(jsonData);

            imageSlides.imagePath = slide.path;

			header.mainColor = slide.headerMain;
			header.fontColor = slide.headerFont;
			header.accentColor = slide.headerAccent;

			footer.fontColor = slide.footerFont;
			footer.mainColor = slide.footerMain;
			footer.accentColor = slide.footerAccent;
        }

        onDateChanged: (date, prayer) => _onDateChanged(date, prayer)
        onClockChanged: (clock, seconds) => _onClockChanged(clock, seconds)
        onImageChanged: (filePath) => _onImageChanged(filePath)
    }

    MouseArea {
        anchors.fill: parent
        enabled: true
        cursorShape: Qt.BlankCursor
		onPressed: {backEnd.playBeep()}
    }

    Components.ImageSlides {
        id: imageSlides

        screenWidth: root.width
        screenHeight: root.height
    }

    Components.Header {
        id: header

		anchors.top: parent.top
		anchors.left: parent.left
		anchors.right: parent.right
    }

    Components.Footer {
        id: footer

		anchors.left: parent.left
		anchors.bottom: parent.bottom
		anchors.right: parent.right
    }
}