#ifndef LOLOCHKA_H
#define LOLOCHKA_H

#include <QObject>

class lolochka : public QObject
{
    Q_OBJECT
public:
    explicit lolochka(QObject *parent = 0);

signals:

public slots:
};

#endif // LOLOCHKA_H