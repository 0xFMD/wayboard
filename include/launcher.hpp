#ifndef __LAUNCHER_H__
#define __LAUNCHER_H__

#include <filesystem>
#include <fstream>
#include <string.h>

#include <QObject>
#include <QProcess>
#include <QProcessEnvironment>
#include <QString>
#include <QVariantList>

struct App_t {
    std::string name;
    std::string icon;
    std::string exec;
};

class Launcher : public QObject {
    Q_OBJECT

  public:
    Q_INVOKABLE QVariantList list_apps();
    Q_INVOKABLE void         launch(QString command);
};

#endif