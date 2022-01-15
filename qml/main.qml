import QtQuick.Window 2.3
import QtQuick 2.15
import QtQuick.Controls 2.15
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

    // Design definitions
    property int zoomMin:   18
    property int zoomMax:   1
    property int heightMin: 50
    property int heightMax: 100
    property int iconsSize: heightMin + (heightMax - heightMin) * (map.zoomLevel - zoomMin) / (zoomMax - zoomMin)
    property real toolBarHeightFactor: 0.10

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
            minimumWidth = 640
            minimumHeight = 480
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
            //PluginParameter { name: "osm.mapping.highdpi_tiles"; value: "true" }
        }

        // Currente device position
        PositionSource
        {
            id: src
            updateInterval: 1000
            active: true
            preferredPositioningMethods: PositionSource.AllPositioningMethods

            onPositionChanged:
            {
                var coord = src.position.coordinate;
                console.log("[PositionSource] Current Coordinate:", coord.longitude, coord.latitude);
                map.addMyPositionIcon(coord)
            }
        }

        // Map item
        Map
        {
            id: map
            anchors.fill: parent
            plugin: osmPlugin
            center: QtPositioning.coordinate(37.3861, -5.9926) // Seville, La Giralda
            zoomLevel: 15
            maximumZoomLevel: 17.90 // Avoid text size of street names gets too small

            // Mouse/Finger handler
            MouseArea
            {
                anchors.fill: parent
                acceptedButtons: Qt.RightButton | Qt.LeftButton
                onDoubleClicked:
                {
                    console.log("DoubleClicked at coordinate: " + map.toCoordinate(Qt.point(mouse.x, mouse.y)))
                    map.addCarIcon(map.toCoordinate(Qt.point(mouse.x, mouse.y)))
                }
                onPressAndHold:
                {
                    console.log("PressAndHold at coordinate: " + map.toCoordinate(Qt.point(mouse.x, mouse.y)))
                    map.addCarIcon(map.toCoordinate(Qt.point(mouse.x, mouse.y)))
                }
            }

            // Set the car position in the map
            function addMyPositionIcon(coordinates)
            {
                myPosition.coordinate = coordinates
                map.addMapItem(myPosition)
            }

            // Set the car position in the map
            function addCarIcon(coordinates)
            {
                myCar.coordinate = coordinates
                map.addMapItem(myCar)
            }

            // Center on functions
            function centerMapOnMyPosition()
            {
                map.center = myPosition.coordinate
            }
            function centerMapOnMyCar()
            {
                map.center = myCar.coordinate
            }
        }

        // Current position Icon
        MapQuickItem
        {
            id: myPosition
            coordinate: QtPositioning.coordinate(0.0, 0.0)
            sourceItem: Rectangle
            {
                id: myPositionImg
                opacity: 0.5
                height: iconsSize / 2
                width: height
                radius: height*0.5
                color: "blue"

            }
            anchorPoint.x: myPositionImg.width/2
            anchorPoint.y: myPositionImg.height/2
        }

        // Car Icon
        MapQuickItem
        {
            id: myCar
            coordinate: QtPositioning.coordinate(37.3861, -5.9926)
            sourceItem: Image
            {
                id: myCarImg
                source: "qrc:/resources/car.png"
                opacity: 0.7
                height: iconsSize
                fillMode: Image.PreserveAspectFit
            }
            anchorPoint.x: myCarImg.width/2
            anchorPoint.y: myCarImg.height/2
        }

        Rectangle
        {
            id: footerCover
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.bottom: parent.bottom
            width: parent.width
            height: 25
            color: Qt.rgba(0/255, 0/255, 0/255, 1.0)
        }

        Rectangle
        {
            id: toolBar
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.bottom: footerCover.top
            width: parent.width
            height: parent.height * toolBarHeightFactor
            color: Qt.rgba(0/255, 0/255, 0/255, 0.3)

            ScrollView
            {
                id: buttonsScrollView
                anchors.fill: parent
                ScrollBar.horizontal.policy: ScrollBar.AlwaysOff
                ScrollBar.vertical.policy: ScrollBar.AlwaysOff
                clip: true

                Row
                {
                    spacing: 10
                    height: parent.height
                    anchors.verticalCenter: parent.verticalCenter
                    Rectangle
                    {
                        id: someSpace
                        anchors.verticalCenter: parent.verticalCenter
                        width: parent.spacing
                        height: toolBar.height
                        color: "transparent"
                    }
                    Rectangle
                    {
                        anchors.verticalCenter: parent.verticalCenter
                        height: toolBar.height
                        width: height
                        color: "transparent"

                        RoundButton
                        {
                            anchors.centerIn: parent
                            height: parent.height * 0.9
                            width: height
                            icon.color: "transparent"
                            icon.source: "qrc:/resources/my_position.png"
                            icon.height: height * 0.75
                            icon.width: width * 0.75
                            opacity: 1.0
                            palette { button: Qt.rgba(255/255, 255/255, 255/255, 0.4) }

                            onClicked:
                            {
                                map.centerMapOnMyPosition()
                            }
                        }
                    }
                    Rectangle
                    {
                        anchors.verticalCenter: parent.verticalCenter
                        height: toolBar.height
                        width: height
                        color: "transparent"

                        RoundButton
                        {
                            anchors.centerIn: parent
                            height: parent.height * 0.9
                            width: height
                            icon.color: "transparent"
                            icon.source: "qrc:/resources/car.png"
                            icon.height: height * 0.75
                            icon.width: width * 0.75
                            opacity: 1.0
                            palette { button: Qt.rgba(255/255, 255/255, 255/255, 0.4) }

                            onClicked:
                            {
                                map.centerMapOnMyCar()
                            }
                        }
                    }
                }
            }

        }
    }//background
}
