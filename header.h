#ifndef HEADER_H
#define HEADER_H
#include <QtNetwork>
#include <QObject>

class header : public QObject
{
    Q_OBJECT

public:
   explicit header();

    ~header();

    QString IPaddrPLATA  = "";
    QString myIP = "";
    QString lastIP = "111.111.111.111";
    char vibran_pult = 0;
    char myIPchar[4] = {0, 0, 0, 0};
    char selection[4] = {0, 0, 0, 0};
    int noupint[3] = {0, 222, 173};
    char noup[3] = {0, 0, 0};
    bool SetIPdone = false;
    QStringList list;
    QString currentIPinComboBox;
    QString newIP="";

    QStringList list_k1;
    QStringList list_k2;
    QStringList list_k3;
    QStringList list_k4;

    int flag = 0;
    int flag_combobox=0;
    int rele_seichas;

    Q_PROPERTY(QStringList listIP_PULT_QML  READ listIP_PULT_readQML NOTIFY listIP_PULT_QML_ChangeQML)
    const QStringList & listIP_PULT_readQML() const;

    Q_PROPERTY(QString myIP_QML  READ myIP_readQML NOTIFY myIP_QML_ChangeQML)
    const QString & myIP_readQML() const;

   Q_PROPERTY(QString newIP_QML  READ newIP_readQML NOTIFY newIP_QML_ChangeQML)
   const QString & newIP_readQML() const;

   Q_PROPERTY(QString currentIPinComboBox_QML  READ currentIPinComboBox_readQML NOTIFY currentIPinComboBox_QML_ChangeQML)
   const QString & currentIPinComboBox_readQML() const;

   Q_PROPERTY(int flag_combobox_QML  READ flag_combobox_readQML NOTIFY flag_combobox_QML_ChangeQML)
   const int & flag_combobox_readQML() const;



   Q_PROPERTY(QStringList list_k1_QML  READ list_k1_readQML WRITE list_k1_writeQML NOTIFY list_k1_QML_ChangeQML)
   const QStringList & list_k1_readQML() const;

    void  list_k1_writeQML(QStringList);

   Q_PROPERTY(QStringList list_k2_QML  READ list_k2_readQML WRITE list_k2_writeQML NOTIFY list_k2_QML_ChangeQML)
   const QStringList & list_k2_readQML() const;

    void  list_k2_writeQML(QStringList);

    Q_PROPERTY(QStringList list_k3_QML  READ list_k3_readQML WRITE list_k3_writeQML NOTIFY list_k3_QML_ChangeQML)
    const QStringList & list_k3_readQML() const;

     void  list_k3_writeQML(QStringList);

    Q_PROPERTY(QStringList list_k4_QML  READ list_k4_readQML WRITE list_k4_writeQML NOTIFY list_k4_QML_ChangeQML)
    const QStringList & list_k4_readQML() const;

     void  list_k4_writeQML(QStringList);


signals:

   void list_k1_QML_ChangeQML(QStringList);

   void list_k2_QML_ChangeQML(QStringList);

   void list_k3_QML_ChangeQML(QStringList);

   void list_k4_QML_ChangeQML(QStringList);

    void listIP_PULT_QML_ChangeQML(QStringList);

    void myIP_QML_ChangeQML(QString);

    void currentIPinComboBox_QML_ChangeQML(QString);

    void newIP_QML_ChangeQML(QString);

    void flag_combobox_QML_ChangeQML(int);


    void signal_lol(QString hellow);

    void signal_perekl(int flajok);
    void signal_obratnogo_perekl(int flajok);

    void signal_prishlo_sost_K1();
    void signal_prishlo_sost_K2();
    void signal_prishlo_sost_K3();
    void signal_prishlo_sost_K4();

public slots:

    void rele_portON(QStringList, int);

    void generatorON(int);

    void analizatorON(int);

    void zaprosSOST_rele(int);

    void readDatagram_rele(int);

    void readDatagramK1();

    void readDatagramK2();

    void readDatagramK3();

    void readDatagramK4();

    void zapros_readip();

    void readIP();

    void setIP(QString);

    void selection_pult();

    void selection_pult_ok();

    void miganie();

    void dHCP();

    void current_IP(int);

    void IPvFILE();

    void IPfromFILE();

    //void closeEvent(QCloseEvent *event);

    void osvobodit_pult();

public:
    QUdpSocket *udpsocket65533;
    QUdpSocket *udpsocket65534;
    QUdpSocket *udpsocket65531;
    QUdpSocket *udpsocket65528;
    QUdpSocket *udpsocket65525;
    QUdpSocket *udpsocket65526;
    QUdpSocket *udpsocket65523;
    QUdpSocket *udpsocket65522;
    QUdpSocket *udpsocket65521;
    QUdpSocket *udpsocket65520;
    QUdpSocket *udpsocket65510;
    QUdpSocket *udpsocket65400;
    QUdpSocket *udpsocket65500;
};




#endif // HEADER_H
