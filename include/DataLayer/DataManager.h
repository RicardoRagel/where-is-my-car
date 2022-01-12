#ifndef DATAMANAGER_H
#define DATAMANAGER_H

#include <QObject>
#include <QDebug>
#include <QString>
#include <QDir>

#include "Constants.h"

// QmlObjectListModel Class, imported from the QGroundControl Project to manage easily QObject derived classes from both QML and C++ sides
#include "QmlObjectListModel.h"

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

signals:

  // QML Properties signals

private:

  // Variables

  // Aux functions

};

#endif // DATAMANAGER_H
