#ifndef DEVICEGEOLOCATION_H
#define DEVICEGEOLOCATION_H

#include <QObject>
#include <QDebug>
#include <QGeoPositionInfoSource>

class DeviceGeolocation : public QObject
{
    Q_OBJECT

public:

    // Constructor
    DeviceGeolocation(QObject *parent = 0);

    // Destuctor
    ~DeviceGeolocation();

    // QML Properties
    Q_PROPERTY(QDateTime date READ date NOTIFY dateChanged)
    Q_PROPERTY(QGeoCoordinate coordinates READ coordinates NOTIFY coordinatesChanged)
    Q_PROPERTY(bool directionIsValid READ directionIsValid NOTIFY directionIsValidChanged)
    Q_PROPERTY(double direction READ direction NOTIFY directionChanged)

    // QML properties getters
    QDateTime date() {return _date;}
    QGeoCoordinate coordinates() {return _coordinates;}
    bool directionIsValid() {return _direction_is_valid;}
    double direction() {return _direction;}

    // QML Invokable properties setters
    Q_INVOKABLE void restart();

private slots:

    // Callback to receive the QGeoPositionInfo
    void positionUpdated(const QGeoPositionInfo &info);

signals:

    // QML properties signals
    void dateChanged();
    void coordinatesChanged();
    void directionIsValidChanged();
    void directionChanged();
    void updated();

private:

    // Sink point
    QGeoPositionInfoSource *_source;
    bool _active = false;

    // Extracted data
    QDateTime _date;
    QGeoCoordinate _coordinates;
    bool _direction_is_valid = false;
    double _direction; // degrees, clockwise from North
};

#endif // DEVICEGEOLOCATION_H
