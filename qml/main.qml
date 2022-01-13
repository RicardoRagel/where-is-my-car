import QtQuick 2.14
import QtQuick.Window 2.3
import QtQuick.Controls 1.4
import QtLocation 5.6
import QtPositioning 5.6

// Import C++ data handlers
import DataManager 1.0
import Constants 1.0

// Import other project QML scripts

// App Window
ApplicationWindow
{
    id: root

    // Car icon size constants
    property int zoomMin:   18
    property int zoomMax:   1
    property int heightMin: 50
    property int heightMax: 100

    // Manage the app starup
    Component.onCompleted:
    {
        // Windows Configuration
        title = qsTr(Constants.appTitle)
        visible = true
        if(Qt.platform.os !== "android")
        {
            visibility = Window.Maximized
            x = 0
            y = 0
            minimumWidth = Screen.width * 0.25
            minimumHeight = Screen.height * 0.25
        }
    }

    /*
        CONTENTS
    */
    Rectangle
    {
        id: appBackground
        visible: true
        anchors.fill: parent
        color: "transparent"

        // "Open Street Map" Plugin
        Plugin
        {
            id: osmPlugin
            name: "osm"
        }

        // Map item
        Map
        {
            id: map
            anchors.fill: parent
            plugin: osmPlugin
            center: QtPositioning.coordinate(37.3861, -5.9926) // Seville, La Giralda
            zoomLevel: 15

            // Mouse handler for Linux, Windows, ...
            MouseArea
            {
                anchors.fill: parent
                acceptedButtons: Qt.RightButton | Qt.LeftButton
                onDoubleClicked:
                {
                    console.log("Right-clicked at coordinate: " + map.toCoordinate(Qt.point(mouse.x, mouse.y)))
                    map.addCarIcon(map.toCoordinate(Qt.point(mouse.x, mouse.y)))
                }
            }

            // Fingers handler for Android, iOS, ...
            TapHandler
            {
                acceptedDevices: PointerDevice.Finger
                onDoubleTapped:
                {
                    console.log("Double-tapped at coordinate: " + map.toCoordinate(Qt.point(eventPoint.position.x, eventPoint.position.y)))
                    map.addCarIcon(map.toCoordinate(Qt.point(eventPoint.position.x, eventPoint.position.y)))
                }
            }

            function addCarIcon(coordinates)
            {
                my_car.coordinate = coordinates
                map.addMapItem(my_car)
            }
        }

        // Car Icon
        MapQuickItem
        {
            id: my_car
            coordinate: QtPositioning.coordinate(37.3861, -5.9926)
            sourceItem: Image
            {
                id: image
                source: "qrc:/resources/car.png"
                opacity: 0.7
                height: heightMin + (heightMax - heightMin) * (map.zoomLevel - zoomMin) / (zoomMax - zoomMin)
                fillMode: Image.PreserveAspectFit
            }
            anchorPoint.x: image.width/2
            anchorPoint.y: image.height/2
        }
    }//background
}
