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
            //visibility = Window.Maximized
            x = 0
            y = 0
            minimumWidth = 640
            minimumHeight = 480
        }

        // Update Current Car Position on the map with the last known
        if(DataManager.currentCar.coordinates.latitude !== 0.0 || DataManager.currentCar.coordinates.longitude !== 0.0)
            map.addCarIcon(DataManager.currentCar.coordinates)
    }

    /*
     * CONTENTS
    */
    Rectangle
    {
        id: appBackground
        visible: true
        anchors.fill: parent
        color: "transparent"

        /*
         * MAP
         */
        // "Open Street Map" Plugin
        Plugin
        {
            id: osmPlugin
            name: "osm"
            //PluginParameter { name: "osm.mapping.highdpi_tiles"; value: "true" }
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
                map.addMapItem(myPosition)
            }

            // Set the car position in the map
            function addCarIcon(coordinates)
            {
                DataManager.updateCurrentCar(coordinates)
                map.addMapItem(myCar)
            }

            // Center on functions
            function centerMapOnMyPosition()
            {
                map.center = myPosition.coordinate

                // Call to restart geolocation, necessary in case the app started with the device localization disabled
                DataManager.deviceLocation.restart()
            }
            function centerMapOnMyCar()
            {
                map.center = myCar.coordinate
            }
        }


        /*
         * MAP ICONS
         */
        // Current position Icon
        MapQuickItem
        {
            id: myPosition
            coordinate: DataManager.deviceLocation.coordinates
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

            Connections
            {
                target: DataManager
                function onDeviceLocationChanged()
                {
                    myPosition.coordinate = DataManager.deviceLocation.coordinates
                    map.addMyPositionIcon(myPosition.coordinate)
                    //console.log("Direction: " + DataManager.deviceLocation.directionIsValid + ", " + DataManager.deviceLocation.direction)
                }
            }
        }

        // Car Icon
        MapQuickItem
        {
            id: myCar
            coordinate: DataManager.currentCar.coordinates
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

        /*
         * MAP FOOTER COVER
           Simple black rectangle at the bottom to hide the unavoidable map footer
         */
        Rectangle
        {
            id: footerCover
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.bottom: parent.bottom
            width: parent.width
            height: 25
            color: Qt.rgba(0/255, 0/255, 0/255, 1.0)
        }

        /*
         * BOTTOM TOOL BAR
         */
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
                            icon.source: "qrc:/resources/glasses_my_position.png"
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
                            icon.source: "qrc:/resources/glasses_car.png"
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
                            icon.source: "qrc:/resources/set_car_in_my_position.png"
                            icon.height: height * 0.75
                            icon.width: width * 0.75
                            opacity: 1.0
                            palette { button: Qt.rgba(255/255, 255/255, 255/255, 0.4) }

                            onClicked:
                            {
                                map.addCarIcon(myPosition.coordinate)
                            }
                        }
                    }
                }
            }

        }
    }//background
}
