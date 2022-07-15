#include <DeviceGeolocation.h>

DeviceGeolocation::DeviceGeolocation(QObject *parent):QObject(parent)
{
    // Init geolocation source
    _source = QGeoPositionInfoSource::createDefaultSource(this);

    if(_source)
    {
        qDebug() << "(DeviceGeolocation) Device Geolocation initizialised correctly";
        _source->setUpdateInterval(1000);
        _source->setPreferredPositioningMethods(QGeoPositionInfoSource::AllPositioningMethods);
        connect(_source, SIGNAL(positionUpdated(QGeoPositionInfo)), this, SLOT(positionUpdated(QGeoPositionInfo)));
        _source->startUpdates();
        _active = true;
    }
    else
    {
        qDebug() << "(DeviceGeolocation) ERROR: Device Geolocation not valid";
    }
}

DeviceGeolocation::~DeviceGeolocation()
{

}

void DeviceGeolocation::restart()
{
    if(_source)
        _source->startUpdates();
}

void DeviceGeolocation::positionUpdated(const QGeoPositionInfo &info)
{
    if(info.isValid())
    {
        _date = info.timestamp();
        _coordinates = info.coordinate();
        emit dateChanged();
        emit coordinatesChanged();

        if(info.hasAttribute(QGeoPositionInfo::Direction))
        {
            _direction = info.attribute(QGeoPositionInfo::Direction);
            _direction_is_valid = true;
            emit directionIsValidChanged();
            emit directionChanged();
        }
        else
        {
            _direction_is_valid = false;
            emit directionIsValidChanged();
        }

        qDebug() << "(DeviceGeolocation) Position updated";
        emit updated();
    }
}
