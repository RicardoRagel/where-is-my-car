#include "Car.h"

Car::Car()
{
    qDebug() << "(Car) Creating new object ...";
    _coordinates.setLatitude(0.0);
    _coordinates.setLongitude(0.0);
    _coordinates.setAltitude(0.0);
}

Car::~Car()
{

}

/** *********************************
 *  QML Invokable properties setters
 ** ********************************/
void Car::setCoordinates(QGeoCoordinate coordinates)
{
    qDebug() << "Updating car coordinates to: " << coordinates;
    _coordinates = coordinates;
    emit coordinatesChanged();
}



