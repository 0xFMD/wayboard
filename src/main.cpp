#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include <QQuickItem>
#include <QQuickWindow>

#include "../include/compositor.hpp"
#include "../include/launcher.hpp"

int main(int argc, char* argv[]) {
    QGuiApplication       app(argc, argv);
    QQmlApplicationEngine engine;

    Launcher              launcher;

    engine.rootContext()->setContextProperty("launcher", &launcher);
    engine.load(QUrl::fromLocalFile("qml/Main.qml"));

    QQuickWindow* qWindow = qobject_cast<QQuickWindow*>(engine.rootObjects().first());

    if (!qWindow)
        return -1;

    QQuickItem* board = qWindow->findChild<QQuickItem*>("board");

    if (!board)
        return -1;

    Compositor compositor(qWindow, board, "wayboard-0");
    return app.exec();
}
