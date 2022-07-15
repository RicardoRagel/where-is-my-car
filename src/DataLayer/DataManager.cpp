#include "DataManager.h"

/** *********************************
 *  DataManager Initizalization
 ** ********************************/

DataManager::DataManager()
{

  qDebug() << "(DataManager) Initialization ...";

  // Init DataBase
  _database = new Database();
  _database->init();

  // Init current device location
  _device_location = new DeviceGeolocation(this);
  connect(_device_location, SIGNAL(updated()), this, SIGNAL(deviceLocationChanged()));

  // Init current car position to the last one known
  _current_car = new Car();
  Car* db_current_car = _database->getCurrentCar();
  if(db_current_car->coordinates().latitude() != 0.0 || db_current_car->coordinates().latitude() != 0.0)
  {
    _current_car = db_current_car;
    emit currentCarChanged();
  }

}

DataManager::~DataManager()
{

}

/** *********************************
 *  QML Invokable properties setters
 ** ********************************/


/** *********************************
 *  QML Invokable standalone functions
 ** ********************************/
void DataManager::updateCurrentCar(QGeoCoordinate coordinates)
{
    _current_car->setCoordinates(coordinates);
    _database->saveCurrentCar(_current_car);
    emit currentCarChanged();
}

/** *********************************
 *  QML Updaters
 ** ********************************/

/** *********************************
 *  Auxiliar functions
 ** ********************************/
