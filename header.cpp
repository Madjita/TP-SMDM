#include "header.h"
#include <QIODevice>
#include <QTextStream>
#include <QValidator>

QString LocalIP();

header::header()
{
    myIP=LocalIP();

    //UDP-сокеты
    //*******************************************************************************

    udpsocket65510=new QUdpSocket(this);//соккет для чтения IP
    udpsocket65510->bind(QHostAddress(myIP),65510);
    connect(udpsocket65510,SIGNAL(readyRead()),this, SLOT(readIP()));

    udpsocket65400=new QUdpSocket(this); //соккет для получения информ ции о р зрешении р боты с пультом
    udpsocket65400->bind(QHostAddress(myIP),65400);
    connect(udpsocket65400,SIGNAL(readyRead()),this, SLOT(selection_pult_ok()));

    udpsocket65500=new QUdpSocket(this);  //для з писи в пульт нового IP из UI
    udpsocket65500->bind(QHostAddress(IPaddrPLATA),65500);



    udpsocket65521=new QUdpSocket(this);//соккет для подключения генер тор  (К5) к К1 или К2
    udpsocket65521->bind(QHostAddress(IPaddrPLATA),65521);

    udpsocket65520=new QUdpSocket(this);//соккет для подключения  н лиз тор  (К6) к К3 или К4
    udpsocket65520->bind(QHostAddress(IPaddrPLATA),65520);

    udpsocket65533=new QUdpSocket(this); //соккет н  включение портов реле К1
    udpsocket65533->bind(QHostAddress(IPaddrPLATA),65533);

    udpsocket65534=new QUdpSocket(this); //соккет для получения информ ции о состоянии ножек контроллер  реле К1
    udpsocket65534->bind(QHostAddress(myIP),65534);
    //connect(udpsocket65534,SIGNAL(readyRead()),this, SLOT(readDatagram_rele(int)));
    connect(udpsocket65534,SIGNAL(readyRead()),this, SLOT(readDatagramK1()));

    udpsocket65531=new QUdpSocket(this); //соккет н  включение портов реле К2
    udpsocket65531->bind(QHostAddress(IPaddrPLATA),65531);

    udpsocket65528=new QUdpSocket(this); //соккет для получения информ ции о состоянии ножек контроллер  реле К2
    udpsocket65528->bind(QHostAddress(myIP),65528);
    //connect(udpsocket65528,SIGNAL(readyRead()),this, SLOT(readDatagram_rele(int)));
    connect(udpsocket65528,SIGNAL(readyRead()),this, SLOT(readDatagramK2()));

    udpsocket65526=new QUdpSocket(this); //соккет н  включение портов реле К3
    udpsocket65526->bind(QHostAddress(IPaddrPLATA),65526);

    udpsocket65525=new QUdpSocket(this); //соккет для получения информ ции о состоянии ножек контроллер  реле К3
    udpsocket65525->bind(QHostAddress(myIP),65525);
    //connect(udpsocket65525,SIGNAL(readyRead()),this, SLOT(readDatagram_rele(int)));
    connect(udpsocket65525,SIGNAL(readyRead()),this, SLOT(readDatagramK3()));

    udpsocket65523=new QUdpSocket(this); //соккет н  включение портов реле К4
    udpsocket65523->bind(QHostAddress(IPaddrPLATA),65523);

    udpsocket65522=new QUdpSocket(this); //соккет для получения информ ции о состоянии ножек контроллер  реле К4
    udpsocket65522->bind(QHostAddress(myIP),65522);
    //connect(udpsocket65522,SIGNAL(readyRead()),this, SLOT(readDatagram_rele(int)));
    connect(udpsocket65522,SIGNAL(readyRead()),this, SLOT(readDatagramK4()));

    noup[0] = (char)noupint[0];
    noup[1] = (char)noupint[1];
    noup[2] = (char)noupint[2];

    for(int i=0; i<10; i++)
    {
    list_k1.append("");
    list_k2.append("");
    list_k3.append("");
    list_k4.append("");
    }

    IPfromFILE();
}

header::~header()
{

}



QString LocalIP()                    //функция чтения своего IP (с фильтр цией IPv6)
{
   QString LocIP;
   QList<QHostAddress> addr = QNetworkInterface::allAddresses();

    if(addr.first().toString().count() < 16)
    {
        LocIP = addr.first().toString();
    }
    else
    {
        LocIP = addr.value(1).toString();
    }

   return LocIP;
}

char IPfromQStringtochar(QString str)//функция преобр зов ния строки в м ссив 4 char'ов (предн зн чен  для IP- дрес )
{
    char c[3] = {'.','.','.'};
    char result;
    int b[3]={0};
    int j=0;

        strncpy(c, qPrintable(str), sizeof(c));

        for (int i = 0; i<3; i++)
            {
                if (c[i]!=0)
                {
                    j++;
                    c[i] = c[i]-48;
                }
            }
        if (j==3)
        {
            b[0]=c[0]*100;
            b[1]=c[1]*10;
            b[2]=c[2];
        }
        if (j==2)
        {
            b[0]=c[0]*10;
            b[1]=c[1];
        }
        if (j==1)
        {
            b[0]=c[0];
        }

        result=(char)(b[0]+b[1]+b[2]);

   return result;
}




void header::zapros_readip()
{
      //myIP = LocalIP();

      emit myIP_QML_ChangeQML(myIP);

      QStringList listIPfromFunction;
      listIPfromFunction = myIP.split('.');

      myIPchar[0]=IPfromQStringtochar(listIPfromFunction[0]);
      myIPchar[1]=IPfromQStringtochar(listIPfromFunction[1]);
      myIPchar[2]=IPfromQStringtochar(listIPfromFunction[2]);
      myIPchar[3]=IPfromQStringtochar(listIPfromFunction[3]);

     char data[10] = {0} ;

     data[0] = noup[0];
     data[1] = noup[1];
     data[2] = noup[2];

     data[6] = myIPchar[0];
     data[7] = myIPchar[1];
     data[8] = myIPchar[2];
     data[9] = myIPchar[3];

     udpsocket65533->bind(65511);
     udpsocket65533->writeDatagram(data,10,QHostAddress("255.255.255.255"),65511); //21

    //IPfromFILE();

}

void header::readIP()              //считыв ние текущего IP- дрес  пульт  и вывод его в соответствующее текстовое поле
{
  while(udpsocket65510->hasPendingDatagrams())
  {

        QByteArray datagram;
        datagram.resize(udpsocket65510->pendingDatagramSize());
        QHostAddress sender;
        quint16 senderPort;
        udpsocket65510->readDatagram(datagram.data(),datagram.size(),&sender,&senderPort);



            int tmp=0;
            QString result = "";
            for ( int i = 0; i<4; i++)
                {
                tmp = (unsigned char) datagram[i];
                result.append(QString::number(tmp));
                if (i!=3)
                    {
                        result.append(".");
                    }
                }

        if (list.contains(result)==false)          //если т кого IP ещё не было
        {
            int m = list.indexOf(lastIP);

            if (m==-1)
            {
                list.append(result);               //доб вляет текущее зн чение в QVector
            }
            else
            {
                list.replace(m,result);            //з меняет ст рое зн чение новым
            }
        }

        flag_combobox=list.indexOf(result);
        if (flag_combobox==-1)
        {
            flag_combobox=0;
        }
        emit flag_combobox_QML_ChangeQML(flag_combobox);


        emit listIP_PULT_QML_ChangeQML(list);

  }
}

void header::miganie()
{
    udpsocket65533->bind(65455);
    udpsocket65533->writeDatagram(noup,3,QHostAddress(currentIPinComboBox),65455);
}

void header::dHCP()
{
    lastIP=currentIPinComboBox;
    udpsocket65533->bind(60000);
    udpsocket65533->writeDatagram(noup,3,QHostAddress(currentIPinComboBox),60000);
}

void header::selection_pult()
{
    myIP = LocalIP();

    emit myIP_QML_ChangeQML(myIP);

    QStringList listIPfromFunction;
    listIPfromFunction = myIP.split('.');

    selection[0]=IPfromQStringtochar(listIPfromFunction[0]);
    selection[1]=IPfromQStringtochar(listIPfromFunction[1]);
    selection[2]=IPfromQStringtochar(listIPfromFunction[2]);
    selection[3]=IPfromQStringtochar(listIPfromFunction[3]);

    //vibran_pult = 1;
    udpsocket65533->bind(65401);
    udpsocket65533->writeDatagram(selection,4,QHostAddress(currentIPinComboBox),65401);
}

void header::selection_pult_ok()
{
    while(udpsocket65400->hasPendingDatagrams())
      {

      QByteArray datagram;
      datagram.resize(udpsocket65400->pendingDatagramSize());
      QHostAddress sender;
      quint16 senderPort;
      udpsocket65400->readDatagram(datagram.data(),datagram.size(),&sender,&senderPort);

      char a[4];

          for(int i=0;i<=3;i++)
          {
          a[i]=datagram[i];
          }

        if((a[0]==selection[0]) & (a[1]==selection[1]) & (a[2]==selection[2]) & (a[3]==selection[3]))
        {
        flag=1;

        IPaddrPLATA = currentIPinComboBox;

        emit signal_perekl(flag);

         qDebug () << " selection_pult_ok";

        IPvFILE();
        }
    }

}




void header::generatorON(int rele)
{
    char a[5];
 if(rele==1)
 {
     a[3]=0;
     a[4]=1;
 }

 else if(rele==2)
 {
     a[3]=1;
     a[4]=0;
 }

 else
 {
     a[3]=0;
     a[4]=0;
 }

 a[0]=noup[0];
 a[1]=noup[1];
 a[2]=noup[2];

 udpsocket65521->writeDatagram(a,5,QHostAddress(IPaddrPLATA),65521);

}

void header::analizatorON(int rele)
{
    char a[5];
 if(rele==1)
 {
     a[3]=0;
     a[4]=1;
 }

 else if(rele==2)
 {
     a[3]=1;
     a[4]=0;
 }

 else
 {
     a[3]=0;
     a[4]=0;
 }

 a[0]=noup[0];
 a[1]=noup[1];
 a[2]=noup[2];

 udpsocket65520->writeDatagram(a,5,QHostAddress(IPaddrPLATA),65520);

}

void header::rele_portON(QStringList polojenie, int rele)
{
    QString temp;
    char a[13];
    char c[10];

    for(int i=0; i<10; i++)
    {
        temp.append(polojenie[i]);
    }
 strncpy(c, qPrintable(temp), sizeof(c));

  a[0]=noup[0];
  a[1]=noup[1];
  a[2]=noup[2];
  for(int i=0; i<10; i++)
  {
      a[i+3]=c[i];
      a[i+3]=a[i+3]-48;
  }

  if(rele==1)
  {
      udpsocket65533->bind(65533);
      udpsocket65533->writeDatagram(a,13,QHostAddress(IPaddrPLATA),65533); //включение портов К1
  }
  if(rele==2)
    udpsocket65531->writeDatagram(a,13,QHostAddress(IPaddrPLATA),65531); //включение портов К2
  if(rele==3)
    udpsocket65526->writeDatagram(a,13,QHostAddress(IPaddrPLATA),65526); //включение портов К3
  if(rele==4)
    udpsocket65523->writeDatagram(a,13,QHostAddress(IPaddrPLATA),65523); //включение портов К4
}

void header::zaprosSOST_rele(int rele)
{
    if(rele==1)
    {
        udpsocket65533->bind(65532);
        udpsocket65533->writeDatagram(noup,3,QHostAddress(IPaddrPLATA),65532);
        rele_seichas=1;
    }
    if(rele==2)
    {
        udpsocket65533->bind(65529);
        udpsocket65533->writeDatagram(noup,3,QHostAddress(IPaddrPLATA),65529);
        rele_seichas=2;
    }
    if(rele==3)
    {
        udpsocket65533->bind(65527);
        udpsocket65533->writeDatagram(noup,3,QHostAddress(IPaddrPLATA),65527);
        rele_seichas=3;
    }
    if(rele==4)
    {
        udpsocket65533->bind(65524);
        udpsocket65533->writeDatagram(noup,3,QHostAddress(IPaddrPLATA),65524);
        rele_seichas=4;
    }
}

void header::readDatagram_rele(int rele)
{
    if (rele==1)
    {
        //this->thread()->msleep(10);
        while(udpsocket65534->hasPendingDatagrams())
        {
            QByteArray datagram;
            datagram.resize(udpsocket65534->pendingDatagramSize());
            QHostAddress sender;
            quint16 senderPort;
            udpsocket65534->readDatagram(datagram.data(),datagram.size(),&sender,&senderPort);

            for(int i=0;i<10;i++)
            {
                 list_k1[i]=QString::number(datagram[i],16);
            }
        }
        emit list_k1_QML_ChangeQML(list_k1);
    }
    if (rele==2)
    {
        while(udpsocket65528->hasPendingDatagrams())
        {
            QByteArray datagram;
            datagram.resize(udpsocket65528->pendingDatagramSize());
            QHostAddress sender;
            quint16 senderPort;
            udpsocket65528->readDatagram(datagram.data(),datagram.size(),&sender,&senderPort);

            for(int i=0;i<10;i++)
            {
                 list_k2[i]=QString::number(datagram[i],16);
            }
        }
        emit list_k2_QML_ChangeQML(list_k2);
    }
    if (rele==3)
    {
        while(udpsocket65525->hasPendingDatagrams())
        {
            QByteArray datagram;
            datagram.resize(udpsocket65525->pendingDatagramSize());
            QHostAddress sender;
            quint16 senderPort;
            udpsocket65525->readDatagram(datagram.data(),datagram.size(),&sender,&senderPort);

            for(int i=0;i<10;i++)
            {
                 list_k3[i]=QString::number(datagram[i],16);
            }
        }
        emit list_k3_QML_ChangeQML(list_k3);
    }
    if (rele==4)
    {
        while(udpsocket65522->hasPendingDatagrams())
        {
            QByteArray datagram;
            datagram.resize(udpsocket65522->pendingDatagramSize());
            QHostAddress sender;
            quint16 senderPort;
            udpsocket65522->readDatagram(datagram.data(),datagram.size(),&sender,&senderPort);

            for(int i=0;i<10;i++)
            {
                 list_k4[i]=QString::number(datagram[i],16);
            }
        }
        emit list_k4_QML_ChangeQML(list_k4);
    }
}

void header::readDatagramK1()
{
    while(udpsocket65534->hasPendingDatagrams())
    {
        QByteArray datagram;
        datagram.resize(udpsocket65534->pendingDatagramSize());
        QHostAddress sender;
        quint16 senderPort;
        udpsocket65534->readDatagram(datagram.data(),datagram.size(),&sender,&senderPort);

        for(int i=0;i<10;i++)
        {
             list_k1[i]=QString::number(datagram[i],16);
        }
    }
    emit list_k1_QML_ChangeQML(list_k1);
    emit signal_prishlo_sost_K1();
}

void header::readDatagramK2()
{

    while(udpsocket65528->hasPendingDatagrams())
    {
        QByteArray datagram;
        datagram.resize(udpsocket65528->pendingDatagramSize());
        QHostAddress sender;
        quint16 senderPort;
        udpsocket65528->readDatagram(datagram.data(),datagram.size(),&sender,&senderPort);

        for(int i=0;i<10;i++)
        {
             list_k2[i]=QString::number(datagram[i],16);
        }
    }
    emit list_k2_QML_ChangeQML(list_k2);
    emit signal_prishlo_sost_K2();
}

void header::readDatagramK3()
{

    while(udpsocket65525->hasPendingDatagrams())
    {
        QByteArray datagram;
        datagram.resize(udpsocket65525->pendingDatagramSize());
        QHostAddress sender;
        quint16 senderPort;
        udpsocket65525->readDatagram(datagram.data(),datagram.size(),&sender,&senderPort);

        for(int i=0;i<10;i++)
        {
             list_k3[i]=QString::number(datagram[i],16);
        }
    }
    emit list_k3_QML_ChangeQML(list_k3);
    emit signal_prishlo_sost_K3();
}

void header::readDatagramK4()
{

    while(udpsocket65522->hasPendingDatagrams())
    {
        QByteArray datagram;
        datagram.resize(udpsocket65522->pendingDatagramSize());
        QHostAddress sender;
        quint16 senderPort;
        udpsocket65522->readDatagram(datagram.data(),datagram.size(),&sender,&senderPort);

        for(int i=0;i<10;i++)
        {
             list_k4[i]=QString::number(datagram[i],16);
        }
    }
    emit list_k4_QML_ChangeQML(list_k4);
    emit signal_prishlo_sost_K4();
}

void header::setIP(QString ip_from_textbox)
{
    lastIP=currentIPinComboBox;
    QString str = ip_from_textbox;

    char ipresult[10] = {0};
    char GW[4] = {0};
    char check[4] = {0};


    QRegExp rx("((1{0,1}[0-9]{0,2}|2[0-4]{1,1}[0-9]{1,1}|25[0-5]{1,1})\\.){3,3}(1{0,1}[0-9]{0,2}|2[0-4]{1,1}[0-9]{1,1}|25[0-5]{1,1})");
    QRegExpValidator v(rx,0);
    QString validresult = "";
    int pos=0;
    validresult = v.validate(str,pos);

    QStringList listIPfromFunction;
    listIPfromFunction = lastIP.split('.');

    GW[0]=IPfromQStringtochar(listIPfromFunction[0]);
    GW[1]=IPfromQStringtochar(listIPfromFunction[1]);
    GW[2]=IPfromQStringtochar(listIPfromFunction[2]);
    GW[3]=IPfromQStringtochar(listIPfromFunction[3]);

    listIPfromFunction = str.split('.');

    if ((listIPfromFunction.length()==4))
    {
        check[0]=IPfromQStringtochar(listIPfromFunction[0]);
        check[1]=IPfromQStringtochar(listIPfromFunction[1]);
        check[2]=IPfromQStringtochar(listIPfromFunction[2]);
        check[3]=IPfromQStringtochar(listIPfromFunction[3]);
    }

    if((GW[0]==check[0])&(GW[1]==check[1])&("\002"==validresult)) //проверк  н  пустое поле и н  корректный форм т  дрес 
    {

    ipresult[0]=noup[0];
    ipresult[1]=noup[1];
    ipresult[2]=noup[2];
    ipresult[3]=check[0];
    ipresult[4]=check[1];
    ipresult[5]=check[2];
    ipresult[6]=check[3];
    ipresult[7]=0;
    ipresult[8]=0;
    ipresult[9]=0;
    //udpsocket65500->bind(65500);
    udpsocket65500->writeDatagram(ipresult,10,QHostAddress(IPaddrPLATA),65500);
    udpsocket65500->writeDatagram(ipresult,10,QHostAddress(IPaddrPLATA),65500);
    udpsocket65500->writeDatagram(ipresult,10,QHostAddress(IPaddrPLATA),65500);


    if (list.contains(str)==false)     //если т кого IP ещё не было
    {
    int i = list.indexOf(lastIP);
    if (i==-1)
    {
        list.append(str);              //доб вляет текущее зн чение в QVector
    }
    else
    {
        list.replace(i,str);           //з меняет ст рое зн чение новым
    }
    }




    SetIPdone=true;

    flag_combobox=list.indexOf(str);
    if (flag_combobox==-1)
    {
        flag_combobox=0;
    }
    emit flag_combobox_QML_ChangeQML(flag_combobox);


    emit listIP_PULT_QML_ChangeQML(list);


    flag=0;
    emit signal_obratnogo_perekl(flag);

    }
}

void header::IPvFILE()
{
    QFile file("lastIPfile.txt");
    QTextStream stream(&file);
    if(file.open(QIODevice::WriteOnly | QIODevice::Text))
    {
            stream << IPaddrPLATA;
    }
    file.close();
}

void header::IPfromFILE()
{
    QString IPfromFILE = "";
    QFile file("lastIPfile.txt");
    if(file.open(QIODevice::ReadOnly | QIODevice::Text))
    {
       IPfromFILE = file.readLine();
       if (list.contains(IPfromFILE)==false)          //если т кого IP ещё не было
       {

           int m = list.indexOf(lastIP);

           if (m==-1)
           {
               list.append(IPfromFILE);               //доб вляет текущее зн чение в QStringList
           }
           else
           {
               list.replace(m,IPfromFILE);            //з меняет ст рое зн чение новым
           }

            emit listIP_PULT_QML_ChangeQML(list);
       }
    }
}




/*
void header::closeEvent(QCloseEvent *event)
{
    osvobodit_pult();                  //освободить пульт из р боты перед з крытием
    event->accept();
}
*/

void header::osvobodit_pult()
{
    udpsocket65533->bind(65533);
    udpsocket65533->writeDatagram(noup,3,QHostAddress(IPaddrPLATA),55666);
}











void header::current_IP(int id)
{
    currentIPinComboBox=list[id];
    emit currentIPinComboBox_QML_ChangeQML(currentIPinComboBox);
}




const QStringList &header::listIP_PULT_readQML() const
{
    return list;
}

const QString &header::myIP_readQML() const
{
    return myIP;
}

const QString &header::currentIPinComboBox_readQML() const
{
    return currentIPinComboBox;
}

const QString &header::newIP_readQML() const
{
    return newIP;
}

const int &header::flag_combobox_readQML() const
{
    return flag_combobox;
}





const QStringList &header::list_k1_readQML() const
{
    return list_k1;
}

void header::list_k1_writeQML(QStringList GetList)
{
     list_k1 = GetList;

     qDebug() <<"list_k1 =" <<  list_k1;

     emit list_k1_QML_ChangeQML(list_k1);
}

const QStringList &header::list_k2_readQML() const
{
    return list_k2;
}

void header::list_k2_writeQML(QStringList GetList)
{
     list_k2 = GetList;

     qDebug() <<"list_k2 =" <<  list_k2;

     emit list_k2_QML_ChangeQML(list_k2);
}

const QStringList &header::list_k3_readQML() const
{
    return list_k3;
}

void header::list_k3_writeQML(QStringList GetList)
{
     list_k3 = GetList;

     qDebug() <<"list_k3 =" <<  list_k3;

     emit list_k3_QML_ChangeQML(list_k3);
}

const QStringList &header::list_k4_readQML() const
{
    return list_k4;
}

void header::list_k4_writeQML(QStringList GetList)
{
     list_k4 = GetList;

     qDebug() <<"list_k4 =" <<  list_k4;

     emit list_k4_QML_ChangeQML(list_k4);
}
