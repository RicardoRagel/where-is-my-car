#ifndef WhereIsMyCarApp_H
#define WhereIsMyCarApp_H

#include <QApplication>
#include <QQmlApplicationEngine>
#include <QDebug>
#include <QQmlEngine>
#include <QtQml>
#include <QIcon>

#include "Constants.h"
#include "DataManager.h"
#include "QmlObjectListModel.h"

using namespace std;

class WhereIsMyCarApp : public QApplication
{
  Q_OBJECT

public:

  WhereIsMyCarApp(int& argc, char* argv[]);

  ~WhereIsMyCarApp();

  void initCommon(void);

  Constants* constants() { return _constants; }
  DataManager* dataManager() { return _dataManager; }
  QQmlApplicationEngine* qmlEngine() { return _qmlAppEngine; }

  bool loadQmlEngine(void);

  static WhereIsMyCarApp* _app;

private:

  Constants* _constants;                // Constant Manager (accesible from C++ and QML)
  DataManager* _dataManager;            // Data Manager ((accesible from C++ and QML))
  QQmlApplicationEngine* _qmlAppEngine; // QML Engine Handler
  QObject* _rootQmlObject(void);
};

#endif // WhereIsMyCarApp_H
