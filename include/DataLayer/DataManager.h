#ifndef DATAMANAGER_H
#define DATAMANAGER_H

#include <QObject>
#include <QDebug>

#include "Constants.h"
#include "Car.h"
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

  // QML Invokable properties getters
  Car* currentCar() {return _current_car;}

  // QML Invokable properties setters
  Q_INVOKABLE void updateCurrentCar(QGeoCoordinate coordinates);

signals:

  // QML Properties signals
  void currentCarChanged();

private:

  // Variables
  Car* _current_car;
  Database* _database;

  // Aux functions

};

#endif // DATAMANAGER_H
