#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>

#include "header.h"





int main(int argc, char *argv[])
{
    QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);

    QGuiApplication app(argc, argv);


    header* w = new header();


    QQmlApplicationEngine engine;

    engine.rootContext()->setContextProperty("w",w);

    engine.load(QUrl(QLatin1String("qrc:/main.qml")));


    emit w->signal_lol("Hellow World!");

 // int lol =  app.exec();
 // if( app.closingDown())


//  if(app.exec() == 0)
//  {
//        w->osvobodit_pult();
//  }


    return app.exec();
}
