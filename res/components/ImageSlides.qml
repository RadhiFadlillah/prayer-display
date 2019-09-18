import QtQuick 2.12

Rectangle {
    id: root

    property int screenWidth
    property int screenHeight
    property string imagePath

    function _onImagePathChanged() {
        // Create image
        var newImage = Qt.createComponent("ImageSlide.qml");
        var obj = newImage.createObject(root, {
            source: `file:///${root.imagePath}`,
            width: root.screenWidth,
            height: root.screenHeight,
        });

        if (root.children.length > 1) {
            root.children[0].destroy();
        }
    }

    onImagePathChanged: _onImagePathChanged()
}