#ifndef DATABASE_H
#define DATABASE_H

#include <QObject>
#include <QDebug>
#include <QString>
#include <QDir>
#include <QFile>
#include <QStandardPaths>
#include <QJsonDocument>
#include <QJsonObject>
#include <QJsonArray>
#include <Car.h>

#endif // DATABASE_H

class Database : public QObject
{
    Q_OBJECT

public:

    // Constructor
    Database();

    // Destuctor
    ~Database();

    // Initialization
    bool init();

    // Update car position
    bool saveCurrentCar(Car* current_car);

    // Get current car
    Car* getCurrentCar();

private:

    QString _filename = "where_is_my_car_database.json";
    QString _folder;
    QFile* _q_file;

    // Init (give format) to the JSON database file
    void initJsonFile();
};
