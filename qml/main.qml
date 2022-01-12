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

    // Windows Configuration
    title: qsTr(Constants.appTitle)
    visible: true
    visibility : Window.Maximized
    x: 0
    y: 0
    minimumWidth: Screen.width * 0.25
    minimumHeight: Screen.height * 0.25

    // Manage the app starup
    Component.onCompleted:
    {
        // nothing for now
    }

    /*
        CONTENTS DIVIDED IN A SPLITVIEW
    */
    Rectangle
    {
        id: appBackground
        visible: true
        anchors.fill: parent
        color: "transparent"

        // Open Street Map Plugin
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

            MouseArea
            {
                anchors.fill: parent
                acceptedButtons: Qt.RightButton
                onClicked:
                {
                    console.log("Right-clicked at " + mouse.x + ", " + mouse.y)
                    console.log("To coordinate: " + map.toCoordinate(Qt.point(mouse.x, mouse.y)))
                    my_car.coordinate = map.toCoordinate(Qt.point(mouse.x, mouse.y))
                    map.addMapItem(my_car)
                }
            }

            onZoomLevelChanged:
            {
                console.log("Zoom level changed: " + zoomLevel)
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
