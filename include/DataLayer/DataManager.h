#ifndef DATAMANAGER_H
#define DATAMANAGER_H

#include <QObject>
#include <QDebug>

#include "Constants.h"
#include "Car.h"
#include "DeviceGeolocation.h"
#include "Database.h"

using namespace std;

class DataManager : public QObject
{
  Q_OBJECT

public:

  // Constructor
  DataManager();

  // Destuctor
  ~DataManager();

  // QML Properties
  Q_PROPERTY(Car* currentCar READ currentCar NOTIFY currentCarChanged)
  Q_PROPERTY(DeviceGeolocation* deviceLocation READ deviceLocation NOTIFY deviceLocationChanged)

  // QML Invokable properties getters
  Car* currentCar() {return _current_car;}
  DeviceGeolocation* deviceLocation() {return _device_location;}

  // QML Invokable properties setters
  Q_INVOKABLE void updateCurrentCar(QGeoCoordinate coordinates);

signals:

  // QML Properties signals
  void currentCarChanged();
  void deviceLocationChanged();

private:

  // Variables
  Database* _database;
  Car* _current_car;
  DeviceGeolocation* _device_location;

  // Aux functions

};

#endif // DATAMANAGER_H
