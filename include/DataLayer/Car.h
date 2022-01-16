#ifndef CAR_H
#define CAR_H

#include <QObject>
#include <QDebug>
#include <QGeoCoordinate>

class Car : public QObject
{
    Q_OBJECT

public:

    // Constructor
    Car();

    // Destuctor
    ~Car();

    // QML properties declarations
    Q_PROPERTY(QGeoCoordinate coordinates READ coordinates WRITE setCoordinates NOTIFY coordinatesChanged)

    // QML properties getters
    QGeoCoordinate coordinates() {return _coordinates;}

    // QML Invokable properties setters
    Q_INVOKABLE void setCoordinates(QGeoCoordinate coordinates);

signals:

    // QML properties signals
    void coordinatesChanged();

private:

    QGeoCoordinate _coordinates;
};

#endif // CAR_H
