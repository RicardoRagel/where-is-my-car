#include "Database.h"

Database::Database()
{

}

Database::~Database()
{
    _q_file->close();
}

bool Database::init()
{
    _folder = QStandardPaths::writableLocation(QStandardPaths::AppDataLocation);
    qDebug() << "(Database) App data loaded and saved to: " << _folder;

    _q_file = new QFile(_folder + "/" + _filename);
    if(!_q_file->exists())
    {
        qDebug() << "(Database) Database doesn't exists at " << _q_file->fileName() << ", generating a new one";

        // Create directory if needed
        QDir dir;
        if (!dir.exists(_folder))
        {
            if(!dir.mkpath(_folder))
            {
                qDebug() << "(Database) ERROR creating directory";
                return false;
            }
        }

        // Create file
        if(!_q_file->open(QFile::ReadWrite))
        {
            qDebug() << "(Database) ERROR creating file";
            return false;
        }
        else
        {
            initJsonFile();
            _q_file->close();
        }
    }
    else
    {
        qDebug() << "(Database) Database already exists at " << _q_file->fileName();
    }

    return true; // Database File created successfully
}

void Database::initJsonFile()
{
    QJsonObject json_obj_current_car;
    json_obj_current_car.insert("latitude", "0.0");
    json_obj_current_car.insert("longitude", "0.0");

    QJsonObject json_obj;
    json_obj.insert("current_car", json_obj_current_car);
    QJsonDocument doc(json_obj);

    qDebug() << "(Database) Current Database: " << doc;
    _q_file->write(doc.toJson());
}

bool Database::saveCurrentCar(Car *current_car)
{
    qDebug() << "(Database) Updating Current Car position: " << current_car->coordinates();

    // Open as "Truncate" to erase content before writting
    if(!_q_file->open(QFile::ReadWrite|QFile::Truncate))
    {
        qDebug() << "(Database) ERROR openning";
        return false;
    }
    else
    {
        // Read complete JSON
        QJsonDocument doc = QJsonDocument().fromJson(_q_file->readAll());
        QJsonObject json_obj = doc.object();

        // Modify "current_car" field
        QJsonObject json_obj_current_car = json_obj.find("current_car").value().toObject();
        json_obj_current_car["latitude"] = current_car->coordinates().latitude();
        json_obj_current_car["longitude"] = current_car->coordinates().longitude();
        json_obj.remove("current_car");
        json_obj.insert("current_car", json_obj_current_car);

        // Save new JSON
        doc = QJsonDocument(json_obj);
        _q_file->write(doc.toJson());
        _q_file->close();
    }

    return true;
}

Car* Database::getCurrentCar()
{
    Car* result = new Car;
    if(!_q_file->open(QFile::ReadOnly))
    {
        qDebug() << "(Database) ERROR openning";
    }
    else
    {
        // Read complete JSON
        QJsonDocument doc = QJsonDocument().fromJson(_q_file->readAll());
        QJsonObject json_obj = doc.object();
        QJsonObject json_obj_current_car = json_obj.find("current_car").value().toObject();
        result->setCoordinates(QGeoCoordinate(json_obj_current_car["latitude"].toDouble(),
                                             json_obj_current_car["longitude"].toDouble(),
                                             0.0));
        _q_file->close();

    }
    return result;
}
