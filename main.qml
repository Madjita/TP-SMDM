import QtQuick 2.7
import QtQuick.Controls 2.0
import QtQuick.Layouts 1.0

import "js/global.js" as Global

ApplicationWindow
{
    width: 800
    visible: true
    height: 600
    title: qsTr("Пульт ТП-СМДМ УЭ2.705.156")

    onClosing:
    {
        w.osvobodit_pult();
    }



    SwipeView
    {
        id: swipeView
        width: 800
        height: 500
        anchors.bottomMargin: 0
        anchors.fill: parent
        currentIndex: tabBar.currentIndex

        onCurrentIndexChanged:
        {
             if(  Global.flag__rezresh_perekl_swipeview ==1 )
             {
                    //swipeView.currentIndex =  0;//тут вместо 0 переменная с цпп, которая отслеживает флаг на какой страницк сейчас нужно быть
                    Global.flag__rezresh_perekl_swipeview = 0;

             }
             else
             {
                  swipeView.currentIndex =  Global.flag__tekushii_swipeview;
                 //Global.flag__rezresh_perekl_swipeview = 0;
             }
        }

        Page
        {
            id: page1
            x: 0
            y: 0
            width: 800
            height: 600
            font.family: "Times New Roman"
            font.pointSize: 12






            GridLayout {
                id: table_ip
                x: 440
                anchors.right: parent.right
                anchors.rightMargin: 0
                anchors.top: parent.top
                anchors.topMargin: 0
                columnSpacing: 0
                rowSpacing: 0
                rows: 2
                columns: 2

                TextField {
                    id: textmyIP
                    text: qsTr("IP-адрес текущего компьютера")
                    Layout.preferredHeight: 40
                    Layout.preferredWidth: 240
                    leftPadding: 6
                    font.bold: true
                    font.pointSize: 12
                    font.family: "Times New Roman"
                    horizontalAlignment: Text.AlignHCenter
                    readOnly: true
                }

                TextField
                {
                    id: ipMY
                    text: qsTr(w.myIP_QML)
                    Layout.preferredWidth: 120
                    leftPadding: 6
                    topPadding: 6
                    horizontalAlignment: Text.AlignHCenter
                    font.bold: true
                    font.pointSize: 12
                    font.family: "Times New Roman"
                    readOnly: true
                }

                TextField {
                    id: textpultIP
                    text: qsTr("IP-адрес текущего пульта")
                    Layout.preferredHeight: 40
                    Layout.preferredWidth: 240
                    leftPadding: 6
                    font.bold: true
                    font.pointSize: 12
                    horizontalAlignment: Text.AlignHCenter
                    font.family: "Times New Roman"
                    readOnly: true
                }

                TextField
                {
                    id: ipPULT
                    text: qsTr(w.currentIPinComboBox_QML)
                    Layout.preferredWidth: 120
                    leftPadding: 6
                    font.family: "Times New Roman"
                    font.bold: true
                    font.pointSize: 12
                    horizontalAlignment: Text.AlignHCenter
                    readOnly: true
                }
            }

            GridLayout {
                id: buttons
                x: 320
                y: 100
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.verticalCenter: parent.verticalCenter
                columnSpacing: 5
                rowSpacing: 10
                rows: 5
                columns: 1

                Button
                {
                    id: search
                    x: 20
                    width: 120
                    text: qsTr("Найти пульты")
                    Layout.maximumWidth: 65535
                    Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                    Layout.preferredWidth: -1
                    font.family: "Times New Roman"
                    font.pointSize: 12

                    onClicked:
                    {
                        w.zapros_readip();

                        /*
                    var hellow = "Hellow";

                    var mass = [10,12,"213123"];

                    console.log(hellow);

                    console.log(mass);
                    */
                        //    ipMY.text = qsTr(w.myIP_QML); вариант 1
                    }



                }

                ComboBox
                {
                    id:comboBox
                    enabled: false
                    Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                    Layout.preferredWidth: 160
                    rightPadding: 6
                    leftPadding: 6
                    padding: 6
                    textRole: ""
                    currentIndex: -1
                    font.family: "Times New Roman"
                    font.pointSize: 12

                    model:  w.listIP_PULT_QML



                    onCurrentTextChanged:
                    {
                        w.current_IP(comboBox.currentIndex);
                        comboBox.enabled=true;
                        diode.enabled=true;
                        regDHCP.enabled=true;
                        work.enabled=true;
                    }

                    onModelChanged:
                    {
                        comboBox.currentIndex  = w.flag_combobox_QML;
                        swipeView.setCurrentIndex(0);
                    }
                }

                Button
                {
                    id: diode
                    x: 25
                    text: qsTr("Моргнуть")
                    enabled: false
                    Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                    Layout.preferredWidth: 110
                    font.family: "Times New Roman"
                    font.pointSize: 12

                    onClicked:
                    {
                        w.miganie();
                    }
                }

                Button
                {
                    id: regDHCP
                    x: 5
                    text: qsTr("DHCP-регистрация")
                    enabled: false
                    Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                    font.family: "Times New Roman"
                    font.pointSize: 12

                    onClicked:
                    {
                        w.dHCP();
                    }
                }

                Button
                {
                    id: work
                    x: 25
                    text: qsTr("Работа")
                    enabled: false
                    Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                    Layout.preferredWidth: 110
                    font.family: "Times New Roman"
                    font.pointSize: 12

                    onClicked:
                    {
                        w.selection_pult();
                    }

                    Connections
                    {
                        target: w

                        onSignal_perekl:
                        {
                            //console.log(flajok);

                            Global.flag__rezresh_perekl_swipeview = 1;
                            Global.flag__tekushii_swipeview=1;


                            swipeView.setCurrentIndex(flajok);
                            w.zaprosSOST_rele(1);
                            w.zaprosSOST_rele(2);
                            w.zaprosSOST_rele(3);
                            w.zaprosSOST_rele(4);
                            k1.enabled=true;
                            k2.enabled=true;
                            k3.enabled=true;
                            k4.enabled=true;
                            comboBox.enabled=false;
                            diode.enabled=false;
                            regDHCP.enabled=false;
                            work.enabled=false;
                        }
                    }

                }
            }

        }










        Page
        {
            id: page2
            x: 800
            y: 0
            width: 800
            height: 600

            GridLayout {
                id: layout_gen
                x: 65
                y: 45
                width: 270
                height: 420
                anchors.verticalCenter: parent.verticalCenter
                anchors.horizontalCenterOffset: -200
                anchors.horizontalCenter: parent.horizontalCenter
                columns: 2

                GroupBox {
                    id: k5
                    x: 64
                    y: 0
                    width: 140
                    height: 64
                    Layout.fillHeight: false
                    Layout.fillWidth: false
                    Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                    Layout.columnSpan: 2
                    Layout.preferredHeight: 64
                    Layout.preferredWidth: 140
                    spacing: 5
                    padding: 12
                    title: qsTr("      Генератор")
                    font.family: "Times New Roman"
                    font.pointSize: 12

                    RadioButton {
                        id: k1
                        x: -12
                        y: -12
                        width: 70
                        text: qsTr("K1")
                        enabled: false
                        font.family: "Times New Roman"
                        font.pointSize: 12
                        onClicked:
                        {
                            w.generatorON(1);
                            w.zaprosSOST_rele(1);

                            //w.readDatagram_rele(1);

                            k1_1.enabled=true;
                            k1_2.enabled=true;
                            k1_3.enabled=true;
                            k1_4.enabled=true;
                            k1_5.enabled=true;
                            k1_6.enabled=true;
                            k1_7.enabled=true;
                            k1_8.enabled=true;
                            k1_9.enabled=true;
                            k1_10.enabled=true;
                        }


                        Connections
                        {
                            target: w

                            onSignal_prishlo_sost_K1:
                            {
                                var list_string  = [];
                                list_string  = w.list_k1_QML;


                                if(list_string[0] == 1)
                                {
                                    k1_1.checked = true;
                                }
                                else
                                {
                                    k1_1.checked= false;
                                }

                                if(list_string[1] ==1)
                                {
                                    k1_2.checked=true;
                                }
                                else
                                {
                                    k1_2.checked=false;
                                }

                                if(list_string[2]==1)
                                {
                                    k1_3.checked = true;
                                }
                                else
                                {
                                    k1_3.checked= false;
                                }

                                if(list_string[3] == 1)
                                {
                                    k1_4.checked=true;
                                }
                                else
                                {
                                    k1_4.checked=false;
                                }

                                if(list_string[4] == 1)
                                {
                                    k1_5.checked=true;
                                }
                                else
                                {
                                    k1_5.checked=false;
                                }

                                if(list_string[5]==1)
                                {
                                    k1_6.checked = true;
                                }
                                else
                                {
                                    k1_6.checked= false;
                                }

                                if(list_string[6] == 1)
                                {
                                    k1_7.checked=true;
                                }
                                else
                                {
                                    k1_7.checked=false;
                                }

                                if(list_string[7]==1)
                                {
                                    k1_8.checked = true;
                                }
                                else
                                {
                                    k1_8.checked= false;
                                }

                                if(list_string[8] == 1)
                                {
                                    k1_9.checked=true;
                                }
                                else
                                {
                                    k1_9.checked=false;
                                }

                                if(list_string[9] == 1)
                                {
                                    k1_10.checked=true;
                                }
                                else
                                {
                                    k1_10.checked=false;
                                }

                                //console.log(list_string);
                            }
                        }




                    }

                    RadioButton {
                        id: k2
                        x: 58
                        y: -12
                        width: 70
                        text: qsTr("K2")
                        enabled: false
                        font.family: "Times New Roman"
                        font.pointSize: 12
                        onClicked:
                        {
                            w.generatorON(2);
                            w.zaprosSOST_rele(2);

                            //w.readDatagram_rele(2);

                            k2_1.enabled=true;
                            k2_2.enabled=true;
                            k2_3.enabled=true;
                            k2_4.enabled=true;
                            k2_5.enabled=true;
                            k2_6.enabled=true;
                            k2_7.enabled=true;
                            k2_8.enabled=true;
                            k2_9.enabled=true;
                            k2_10.enabled=true;
                        }

                        Connections
                        {
                            target: w

                            onSignal_prishlo_sost_K2:
                            {
                                var list_string  = [];
                                list_string  = w.list_k2_QML;

                                if(list_string[0] == 1)
                                {
                                    k2_1.checked = true;
                                }
                                else
                                {
                                    k2_1.checked= false;
                                }

                                if(list_string[1] ==1)
                                {
                                    k2_2.checked=true;
                                }
                                else
                                {
                                    k2_2.checked=false;
                                }

                                if(list_string[2]==1)
                                {
                                    k2_3.checked = true;
                                }
                                else
                                {
                                    k2_3.checked= false;
                                }

                                if(list_string[3] == 1)
                                {
                                    k2_4.checked=true;
                                }
                                else
                                {
                                    k2_4.checked=false;
                                }

                                if(list_string[4] == 1)
                                {
                                    k2_5.checked=true;
                                }
                                else
                                {
                                    k2_5.checked=false;
                                }

                                if(list_string[5]==1)
                                {
                                    k2_6.checked = true;
                                }
                                else
                                {
                                    k2_6.checked= false;
                                }

                                if(list_string[6] == 1)
                                {
                                    k2_7.checked=true;
                                }
                                else
                                {
                                    k2_7.checked=false;
                                }

                                if(list_string[7]==1)
                                {
                                    k2_8.checked = true;
                                }
                                else
                                {
                                    k2_8.checked= false;
                                }

                                if(list_string[8] == 1)
                                {
                                    k2_9.checked=true;
                                }
                                else
                                {
                                    k2_9.checked=false;
                                }

                                if(list_string[9] == 1)
                                {
                                    k2_10.checked=true;
                                }
                                else
                                {
                                    k2_10.checked=false;
                                }

                                //console.log(list_string);
                            }
                        }
                    }
                }

                GridLayout {
                    id: gen
                    x: 2
                    y: 70
                    width: 270
                    height: 350
                    rows: 2
                    columns: 4

                    ColumnLayout {
                        id: gen_k_k1
                        x: 0
                        Layout.columnSpan: 2

                        Switch {
                            id: k1_1
                            text: qsTr("Порт 1")
                            enabled: false
                            Layout.preferredHeight: 30
                            Layout.preferredWidth: 130
                            font.family: "Times New Roman"
                            font.pointSize: 12
                            onClicked:
                            {
                                var list_checked = [] ;

                                if(k1_1.checked)
                                {
                                    list_checked.push("1");
                                }
                                else
                                {
                                    list_checked.push("0");
                                }
                                if(k1_2.checked)
                                {
                                    list_checked.push("1");
                                }
                                else
                                {
                                    list_checked.push("0");
                                }
                                if(k1_3.checked)
                                {
                                    list_checked.push("1");
                                }
                                else
                                {
                                    list_checked.push("0");
                                }
                                if(k1_4.checked)
                                {
                                    list_checked.push("1");
                                }
                                else
                                {
                                    list_checked.push("0");
                                }
                                if(k1_5.checked)
                                {
                                    list_checked.push("1");
                                }
                                else
                                {
                                    list_checked.push("0");
                                }
                                if(k1_6.checked)
                                {
                                    list_checked.push("1");
                                }
                                else
                                {
                                    list_checked.push("0");
                                }
                                if(k1_7.checked)
                                {
                                    list_checked.push("1");
                                }
                                else
                                {
                                    list_checked.push("0");
                                }
                                if(k1_8.checked)
                                {
                                    list_checked.push("1");
                                }
                                else
                                {
                                    list_checked.push("0");
                                }
                                if(k1_9.checked)
                                {
                                    list_checked.push("1");
                                }
                                else
                                {
                                    list_checked.push("0");
                                }
                                if(k1_10.checked)
                                {
                                    list_checked.push("1");
                                }
                                else
                                {
                                    list_checked.push("0");
                                }

                                w.list_k1_QML = list_checked;

                                //console.log(w.list_k1_QML);

                                w.rele_portON(list_checked,1);

                            }
                        }

                        Switch {
                            id: k1_2
                            text: qsTr("Порт 2")
                            enabled: false
                            Layout.preferredHeight: 30
                            Layout.preferredWidth: 130
                            font.pointSize: 12
                            font.family: "Times New Roman"
                            onClicked:
                            {
                                var list_checked = [] ;

                                if(k1_1.checked)
                                {
                                    list_checked.push("1");
                                }
                                else
                                {
                                    list_checked.push("0");
                                }
                                if(k1_2.checked)
                                {
                                    list_checked.push("1");
                                }
                                else
                                {
                                    list_checked.push("0");
                                }
                                if(k1_3.checked)
                                {
                                    list_checked.push("1");
                                }
                                else
                                {
                                    list_checked.push("0");
                                }
                                if(k1_4.checked)
                                {
                                    list_checked.push("1");
                                }
                                else
                                {
                                    list_checked.push("0");
                                }
                                if(k1_5.checked)
                                {
                                    list_checked.push("1");
                                }
                                else
                                {
                                    list_checked.push("0");
                                }
                                if(k1_6.checked)
                                {
                                    list_checked.push("1");
                                }
                                else
                                {
                                    list_checked.push("0");
                                }
                                if(k1_7.checked)
                                {
                                    list_checked.push("1");
                                }
                                else
                                {
                                    list_checked.push("0");
                                }
                                if(k1_8.checked)
                                {
                                    list_checked.push("1");
                                }
                                else
                                {
                                    list_checked.push("0");
                                }
                                if(k1_9.checked)
                                {
                                    list_checked.push("1");
                                }
                                else
                                {
                                    list_checked.push("0");
                                }
                                if(k1_10.checked)
                                {
                                    list_checked.push("1");
                                }
                                else
                                {
                                    list_checked.push("0");
                                }

                                w.list_k1_QML = list_checked;

                                //console.log(w.list_k1_QML);

                                w.rele_portON(list_checked,1);

                            }
                        }

                        Switch {
                            id: k1_3
                            text: qsTr("Порт 3")
                            enabled: false
                            Layout.preferredHeight: 30
                            Layout.preferredWidth: 130
                            font.pointSize: 12
                            font.family: "Times New Roman"
                            onClicked:
                            {
                                var list_checked = [] ;

                                if(k1_1.checked)
                                {
                                    list_checked.push("1");
                                }
                                else
                                {
                                    list_checked.push("0");
                                }
                                if(k1_2.checked)
                                {
                                    list_checked.push("1");
                                }
                                else
                                {
                                    list_checked.push("0");
                                }
                                if(k1_3.checked)
                                {
                                    list_checked.push("1");
                                }
                                else
                                {
                                    list_checked.push("0");
                                }
                                if(k1_4.checked)
                                {
                                    list_checked.push("1");
                                }
                                else
                                {
                                    list_checked.push("0");
                                }
                                if(k1_5.checked)
                                {
                                    list_checked.push("1");
                                }
                                else
                                {
                                    list_checked.push("0");
                                }
                                if(k1_6.checked)
                                {
                                    list_checked.push("1");
                                }
                                else
                                {
                                    list_checked.push("0");
                                }
                                if(k1_7.checked)
                                {
                                    list_checked.push("1");
                                }
                                else
                                {
                                    list_checked.push("0");
                                }
                                if(k1_8.checked)
                                {
                                    list_checked.push("1");
                                }
                                else
                                {
                                    list_checked.push("0");
                                }
                                if(k1_9.checked)
                                {
                                    list_checked.push("1");
                                }
                                else
                                {
                                    list_checked.push("0");
                                }
                                if(k1_10.checked)
                                {
                                    list_checked.push("1");
                                }
                                else
                                {
                                    list_checked.push("0");
                                }

                                w.list_k1_QML = list_checked;

                                //console.log(w.list_k1_QML);

                                w.rele_portON(list_checked,1);

                            }
                        }

                        Switch {
                            id: k1_4
                            text: qsTr("Порт 4")
                            enabled: false
                            Layout.preferredHeight: 30
                            Layout.preferredWidth: 130
                            font.pointSize: 12
                            font.family: "Times New Roman"
                            onClicked:
                            {
                                var list_checked = [] ;

                                if(k1_1.checked)
                                {
                                    list_checked.push("1");
                                }
                                else
                                {
                                    list_checked.push("0");
                                }
                                if(k1_2.checked)
                                {
                                    list_checked.push("1");
                                }
                                else
                                {
                                    list_checked.push("0");
                                }
                                if(k1_3.checked)
                                {
                                    list_checked.push("1");
                                }
                                else
                                {
                                    list_checked.push("0");
                                }
                                if(k1_4.checked)
                                {
                                    list_checked.push("1");
                                }
                                else
                                {
                                    list_checked.push("0");
                                }
                                if(k1_5.checked)
                                {
                                    list_checked.push("1");
                                }
                                else
                                {
                                    list_checked.push("0");
                                }
                                if(k1_6.checked)
                                {
                                    list_checked.push("1");
                                }
                                else
                                {
                                    list_checked.push("0");
                                }
                                if(k1_7.checked)
                                {
                                    list_checked.push("1");
                                }
                                else
                                {
                                    list_checked.push("0");
                                }
                                if(k1_8.checked)
                                {
                                    list_checked.push("1");
                                }
                                else
                                {
                                    list_checked.push("0");
                                }
                                if(k1_9.checked)
                                {
                                    list_checked.push("1");
                                }
                                else
                                {
                                    list_checked.push("0");
                                }
                                if(k1_10.checked)
                                {
                                    list_checked.push("1");
                                }
                                else
                                {
                                    list_checked.push("0");
                                }

                                w.list_k1_QML = list_checked;

                                //console.log(w.list_k1_QML);

                                w.rele_portON(list_checked,1);

                            }
                        }

                        Switch {
                            id: k1_5
                            text: qsTr("Порт 5")
                            enabled: false
                            Layout.preferredHeight: 30
                            Layout.preferredWidth: 130
                            font.pointSize: 12
                            font.family: "Times New Roman"
                            onClicked:
                            {
                                var list_checked = [] ;

                                if(k1_1.checked)
                                {
                                    list_checked.push("1");
                                }
                                else
                                {
                                    list_checked.push("0");
                                }
                                if(k1_2.checked)
                                {
                                    list_checked.push("1");
                                }
                                else
                                {
                                    list_checked.push("0");
                                }
                                if(k1_3.checked)
                                {
                                    list_checked.push("1");
                                }
                                else
                                {
                                    list_checked.push("0");
                                }
                                if(k1_4.checked)
                                {
                                    list_checked.push("1");
                                }
                                else
                                {
                                    list_checked.push("0");
                                }
                                if(k1_5.checked)
                                {
                                    list_checked.push("1");
                                }
                                else
                                {
                                    list_checked.push("0");
                                }
                                if(k1_6.checked)
                                {
                                    list_checked.push("1");
                                }
                                else
                                {
                                    list_checked.push("0");
                                }
                                if(k1_7.checked)
                                {
                                    list_checked.push("1");
                                }
                                else
                                {
                                    list_checked.push("0");
                                }
                                if(k1_8.checked)
                                {
                                    list_checked.push("1");
                                }
                                else
                                {
                                    list_checked.push("0");
                                }
                                if(k1_9.checked)
                                {
                                    list_checked.push("1");
                                }
                                else
                                {
                                    list_checked.push("0");
                                }
                                if(k1_10.checked)
                                {
                                    list_checked.push("1");
                                }
                                else
                                {
                                    list_checked.push("0");
                                }

                                w.list_k1_QML = list_checked;

                                //console.log(w.list_k1_QML);

                                w.rele_portON(list_checked,1);

                            }
                        }

                        Switch {
                            id: k1_6
                            text: qsTr("Порт 6")
                            enabled: false
                            Layout.preferredHeight: 30
                            Layout.preferredWidth: 130
                            font.pointSize: 12
                            font.family: "Times New Roman"
                            onClicked:
                            {
                                var list_checked = [] ;

                                if(k1_1.checked)
                                {
                                    list_checked.push("1");
                                }
                                else
                                {
                                    list_checked.push("0");
                                }
                                if(k1_2.checked)
                                {
                                    list_checked.push("1");
                                }
                                else
                                {
                                    list_checked.push("0");
                                }
                                if(k1_3.checked)
                                {
                                    list_checked.push("1");
                                }
                                else
                                {
                                    list_checked.push("0");
                                }
                                if(k1_4.checked)
                                {
                                    list_checked.push("1");
                                }
                                else
                                {
                                    list_checked.push("0");
                                }
                                if(k1_5.checked)
                                {
                                    list_checked.push("1");
                                }
                                else
                                {
                                    list_checked.push("0");
                                }
                                if(k1_6.checked)
                                {
                                    list_checked.push("1");
                                }
                                else
                                {
                                    list_checked.push("0");
                                }
                                if(k1_7.checked)
                                {
                                    list_checked.push("1");
                                }
                                else
                                {
                                    list_checked.push("0");
                                }
                                if(k1_8.checked)
                                {
                                    list_checked.push("1");
                                }
                                else
                                {
                                    list_checked.push("0");
                                }
                                if(k1_9.checked)
                                {
                                    list_checked.push("1");
                                }
                                else
                                {
                                    list_checked.push("0");
                                }
                                if(k1_10.checked)
                                {
                                    list_checked.push("1");
                                }
                                else
                                {
                                    list_checked.push("0");
                                }

                                w.list_k1_QML = list_checked;

                                //console.log(w.list_k1_QML);

                                w.rele_portON(list_checked,1);

                            }
                        }

                        Switch {
                            id: k1_7
                            text: qsTr("Порт 7")
                            enabled: false
                            Layout.preferredHeight: 30
                            Layout.preferredWidth: 130
                            font.pointSize: 12
                            font.family: "Times New Roman"
                            onClicked:
                            {
                                var list_checked = [] ;

                                if(k1_1.checked)
                                {
                                    list_checked.push("1");
                                }
                                else
                                {
                                    list_checked.push("0");
                                }
                                if(k1_2.checked)
                                {
                                    list_checked.push("1");
                                }
                                else
                                {
                                    list_checked.push("0");
                                }
                                if(k1_3.checked)
                                {
                                    list_checked.push("1");
                                }
                                else
                                {
                                    list_checked.push("0");
                                }
                                if(k1_4.checked)
                                {
                                    list_checked.push("1");
                                }
                                else
                                {
                                    list_checked.push("0");
                                }
                                if(k1_5.checked)
                                {
                                    list_checked.push("1");
                                }
                                else
                                {
                                    list_checked.push("0");
                                }
                                if(k1_6.checked)
                                {
                                    list_checked.push("1");
                                }
                                else
                                {
                                    list_checked.push("0");
                                }
                                if(k1_7.checked)
                                {
                                    list_checked.push("1");
                                }
                                else
                                {
                                    list_checked.push("0");
                                }
                                if(k1_8.checked)
                                {
                                    list_checked.push("1");
                                }
                                else
                                {
                                    list_checked.push("0");
                                }
                                if(k1_9.checked)
                                {
                                    list_checked.push("1");
                                }
                                else
                                {
                                    list_checked.push("0");
                                }
                                if(k1_10.checked)
                                {
                                    list_checked.push("1");
                                }
                                else
                                {
                                    list_checked.push("0");
                                }

                                w.list_k1_QML = list_checked;

                                //console.log(w.list_k1_QML);

                                w.rele_portON(list_checked,1);

                            }
                        }

                        Switch {
                            id: k1_8
                            text: qsTr("Порт 8")
                            enabled: false
                            Layout.preferredHeight: 30
                            Layout.preferredWidth: 130
                            font.pointSize: 12
                            font.family: "Times New Roman"
                            onClicked:
                            {
                                var list_checked = [] ;

                                if(k1_1.checked)
                                {
                                    list_checked.push("1");
                                }
                                else
                                {
                                    list_checked.push("0");
                                }
                                if(k1_2.checked)
                                {
                                    list_checked.push("1");
                                }
                                else
                                {
                                    list_checked.push("0");
                                }
                                if(k1_3.checked)
                                {
                                    list_checked.push("1");
                                }
                                else
                                {
                                    list_checked.push("0");
                                }
                                if(k1_4.checked)
                                {
                                    list_checked.push("1");
                                }
                                else
                                {
                                    list_checked.push("0");
                                }
                                if(k1_5.checked)
                                {
                                    list_checked.push("1");
                                }
                                else
                                {
                                    list_checked.push("0");
                                }
                                if(k1_6.checked)
                                {
                                    list_checked.push("1");
                                }
                                else
                                {
                                    list_checked.push("0");
                                }
                                if(k1_7.checked)
                                {
                                    list_checked.push("1");
                                }
                                else
                                {
                                    list_checked.push("0");
                                }
                                if(k1_8.checked)
                                {
                                    list_checked.push("1");
                                }
                                else
                                {
                                    list_checked.push("0");
                                }
                                if(k1_9.checked)
                                {
                                    list_checked.push("1");
                                }
                                else
                                {
                                    list_checked.push("0");
                                }
                                if(k1_10.checked)
                                {
                                    list_checked.push("1");
                                }
                                else
                                {
                                    list_checked.push("0");
                                }

                                w.list_k1_QML = list_checked;

                                //console.log(w.list_k1_QML);

                                w.rele_portON(list_checked,1);

                            }
                        }

                        Switch {
                            id: k1_9
                            text: qsTr("Порт 9")
                            enabled: false
                            Layout.preferredHeight: 30
                            Layout.preferredWidth: 130
                            font.pointSize: 12
                            font.family: "Times New Roman"
                            onClicked:
                            {
                                var list_checked = [] ;

                                if(k1_1.checked)
                                {
                                    list_checked.push("1");
                                }
                                else
                                {
                                    list_checked.push("0");
                                }
                                if(k1_2.checked)
                                {
                                    list_checked.push("1");
                                }
                                else
                                {
                                    list_checked.push("0");
                                }
                                if(k1_3.checked)
                                {
                                    list_checked.push("1");
                                }
                                else
                                {
                                    list_checked.push("0");
                                }
                                if(k1_4.checked)
                                {
                                    list_checked.push("1");
                                }
                                else
                                {
                                    list_checked.push("0");
                                }
                                if(k1_5.checked)
                                {
                                    list_checked.push("1");
                                }
                                else
                                {
                                    list_checked.push("0");
                                }
                                if(k1_6.checked)
                                {
                                    list_checked.push("1");
                                }
                                else
                                {
                                    list_checked.push("0");
                                }
                                if(k1_7.checked)
                                {
                                    list_checked.push("1");
                                }
                                else
                                {
                                    list_checked.push("0");
                                }
                                if(k1_8.checked)
                                {
                                    list_checked.push("1");
                                }
                                else
                                {
                                    list_checked.push("0");
                                }
                                if(k1_9.checked)
                                {
                                    list_checked.push("1");
                                }
                                else
                                {
                                    list_checked.push("0");
                                }
                                if(k1_10.checked)
                                {
                                    list_checked.push("1");
                                }
                                else
                                {
                                    list_checked.push("0");
                                }

                                w.list_k1_QML = list_checked;

                                //console.log(w.list_k1_QML);

                                w.rele_portON(list_checked,1);

                            }
                        }

                        Switch {
                            id: k1_10
                            text: qsTr("Порт 10")
                            enabled: false
                            Layout.preferredHeight: 30
                            Layout.preferredWidth: 130
                            font.pointSize: 12
                            font.family: "Times New Roman"
                            onClicked:
                            {
                                var list_checked = [] ;

                                if(k1_1.checked)
                                {
                                    list_checked.push("1");
                                }
                                else
                                {
                                    list_checked.push("0");
                                }
                                if(k1_2.checked)
                                {
                                    list_checked.push("1");
                                }
                                else
                                {
                                    list_checked.push("0");
                                }
                                if(k1_3.checked)
                                {
                                    list_checked.push("1");
                                }
                                else
                                {
                                    list_checked.push("0");
                                }
                                if(k1_4.checked)
                                {
                                    list_checked.push("1");
                                }
                                else
                                {
                                    list_checked.push("0");
                                }
                                if(k1_5.checked)
                                {
                                    list_checked.push("1");
                                }
                                else
                                {
                                    list_checked.push("0");
                                }
                                if(k1_6.checked)
                                {
                                    list_checked.push("1");
                                }
                                else
                                {
                                    list_checked.push("0");
                                }
                                if(k1_7.checked)
                                {
                                    list_checked.push("1");
                                }
                                else
                                {
                                    list_checked.push("0");
                                }
                                if(k1_8.checked)
                                {
                                    list_checked.push("1");
                                }
                                else
                                {
                                    list_checked.push("0");
                                }
                                if(k1_9.checked)
                                {
                                    list_checked.push("1");
                                }
                                else
                                {
                                    list_checked.push("0");
                                }
                                if(k1_10.checked)
                                {
                                    list_checked.push("1");
                                }
                                else
                                {
                                    list_checked.push("0");
                                }

                                w.list_k1_QML = list_checked;

                                //console.log(w.list_k1_QML);

                                w.rele_portON(list_checked,1);

                            }
                        }
                    }

                    ColumnLayout {
                        id: gen_k_k2
                        x: 140
                        Layout.columnSpan: 2
                        Switch {
                            id: k2_1
                            text: qsTr("Порт 1")
                            enabled: false
                            font.pointSize: 12
                            Layout.preferredHeight: 30
                            font.family: "Times New Roman"
                            Layout.preferredWidth: 130
                            onClicked:
                            {
                                var list_checked = [] ;

                                if(k2_1.checked)
                                {
                                    list_checked.push("1");
                                }
                                else
                                {
                                    list_checked.push("0");
                                }
                                if(k2_2.checked)
                                {
                                    list_checked.push("1");
                                }
                                else
                                {
                                    list_checked.push("0");
                                }
                                if(k2_3.checked)
                                {
                                    list_checked.push("1");
                                }
                                else
                                {
                                    list_checked.push("0");
                                }
                                if(k2_4.checked)
                                {
                                    list_checked.push("1");
                                }
                                else
                                {
                                    list_checked.push("0");
                                }
                                if(k2_5.checked)
                                {
                                    list_checked.push("1");
                                }
                                else
                                {
                                    list_checked.push("0");
                                }
                                if(k2_6.checked)
                                {
                                    list_checked.push("1");
                                }
                                else
                                {
                                    list_checked.push("0");
                                }
                                if(k2_7.checked)
                                {
                                    list_checked.push("1");
                                }
                                else
                                {
                                    list_checked.push("0");
                                }
                                if(k2_8.checked)
                                {
                                    list_checked.push("1");
                                }
                                else
                                {
                                    list_checked.push("0");
                                }
                                if(k2_9.checked)
                                {
                                    list_checked.push("1");
                                }
                                else
                                {
                                    list_checked.push("0");
                                }
                                if(k2_10.checked)
                                {
                                    list_checked.push("1");
                                }
                                else
                                {
                                    list_checked.push("0");
                                }

                                w.list_k2_QML = list_checked;

                                //console.log(w.list_k2_QML);

                                w.rele_portON(list_checked,2);

                            }
                        }

                        Switch {
                            id: k2_2
                            text: qsTr("Порт 2")
                            enabled: false
                            font.pointSize: 12
                            Layout.preferredHeight: 30
                            font.family: "Times New Roman"
                            Layout.preferredWidth: 130
                            onClicked:
                            {
                                var list_checked = [] ;

                                if(k2_1.checked)
                                {
                                    list_checked.push("1");
                                }
                                else
                                {
                                    list_checked.push("0");
                                }
                                if(k2_2.checked)
                                {
                                    list_checked.push("1");
                                }
                                else
                                {
                                    list_checked.push("0");
                                }
                                if(k2_3.checked)
                                {
                                    list_checked.push("1");
                                }
                                else
                                {
                                    list_checked.push("0");
                                }
                                if(k2_4.checked)
                                {
                                    list_checked.push("1");
                                }
                                else
                                {
                                    list_checked.push("0");
                                }
                                if(k2_5.checked)
                                {
                                    list_checked.push("1");
                                }
                                else
                                {
                                    list_checked.push("0");
                                }
                                if(k2_6.checked)
                                {
                                    list_checked.push("1");
                                }
                                else
                                {
                                    list_checked.push("0");
                                }
                                if(k2_7.checked)
                                {
                                    list_checked.push("1");
                                }
                                else
                                {
                                    list_checked.push("0");
                                }
                                if(k2_8.checked)
                                {
                                    list_checked.push("1");
                                }
                                else
                                {
                                    list_checked.push("0");
                                }
                                if(k2_9.checked)
                                {
                                    list_checked.push("1");
                                }
                                else
                                {
                                    list_checked.push("0");
                                }
                                if(k2_10.checked)
                                {
                                    list_checked.push("1");
                                }
                                else
                                {
                                    list_checked.push("0");
                                }

                                w.list_k2_QML = list_checked;

                                //console.log(w.list_k2_QML);

                                w.rele_portON(list_checked,2);

                            }
                        }

                        Switch {
                            id: k2_3
                            text: qsTr("Порт 3")
                            enabled: false
                            font.pointSize: 12
                            Layout.preferredHeight: 30
                            font.family: "Times New Roman"
                            Layout.preferredWidth: 130
                            onClicked:
                            {
                                var list_checked = [] ;

                                if(k2_1.checked)
                                {
                                    list_checked.push("1");
                                }
                                else
                                {
                                    list_checked.push("0");
                                }
                                if(k2_2.checked)
                                {
                                    list_checked.push("1");
                                }
                                else
                                {
                                    list_checked.push("0");
                                }
                                if(k2_3.checked)
                                {
                                    list_checked.push("1");
                                }
                                else
                                {
                                    list_checked.push("0");
                                }
                                if(k2_4.checked)
                                {
                                    list_checked.push("1");
                                }
                                else
                                {
                                    list_checked.push("0");
                                }
                                if(k2_5.checked)
                                {
                                    list_checked.push("1");
                                }
                                else
                                {
                                    list_checked.push("0");
                                }
                                if(k2_6.checked)
                                {
                                    list_checked.push("1");
                                }
                                else
                                {
                                    list_checked.push("0");
                                }
                                if(k2_7.checked)
                                {
                                    list_checked.push("1");
                                }
                                else
                                {
                                    list_checked.push("0");
                                }
                                if(k2_8.checked)
                                {
                                    list_checked.push("1");
                                }
                                else
                                {
                                    list_checked.push("0");
                                }
                                if(k2_9.checked)
                                {
                                    list_checked.push("1");
                                }
                                else
                                {
                                    list_checked.push("0");
                                }
                                if(k2_10.checked)
                                {
                                    list_checked.push("1");
                                }
                                else
                                {
                                    list_checked.push("0");
                                }

                                w.list_k2_QML = list_checked;

                                //console.log(w.list_k2_QML);

                                w.rele_portON(list_checked,2);

                            }
                        }

                        Switch {
                            id: k2_4
                            text: qsTr("Порт 4")
                            enabled: false
                            font.pointSize: 12
                            Layout.preferredHeight: 30
                            font.family: "Times New Roman"
                            Layout.preferredWidth: 130
                            onClicked:
                            {
                                var list_checked = [] ;

                                if(k2_1.checked)
                                {
                                    list_checked.push("1");
                                }
                                else
                                {
                                    list_checked.push("0");
                                }
                                if(k2_2.checked)
                                {
                                    list_checked.push("1");
                                }
                                else
                                {
                                    list_checked.push("0");
                                }
                                if(k2_3.checked)
                                {
                                    list_checked.push("1");
                                }
                                else
                                {
                                    list_checked.push("0");
                                }
                                if(k2_4.checked)
                                {
                                    list_checked.push("1");
                                }
                                else
                                {
                                    list_checked.push("0");
                                }
                                if(k2_5.checked)
                                {
                                    list_checked.push("1");
                                }
                                else
                                {
                                    list_checked.push("0");
                                }
                                if(k2_6.checked)
                                {
                                    list_checked.push("1");
                                }
                                else
                                {
                                    list_checked.push("0");
                                }
                                if(k2_7.checked)
                                {
                                    list_checked.push("1");
                                }
                                else
                                {
                                    list_checked.push("0");
                                }
                                if(k2_8.checked)
                                {
                                    list_checked.push("1");
                                }
                                else
                                {
                                    list_checked.push("0");
                                }
                                if(k2_9.checked)
                                {
                                    list_checked.push("1");
                                }
                                else
                                {
                                    list_checked.push("0");
                                }
                                if(k2_10.checked)
                                {
                                    list_checked.push("1");
                                }
                                else
                                {
                                    list_checked.push("0");
                                }

                                w.list_k2_QML = list_checked;

                                //console.log(w.list_k2_QML);

                                w.rele_portON(list_checked,2);

                            }
                        }

                        Switch {
                            id: k2_5
                            text: qsTr("Порт 5")
                            enabled: false
                            font.pointSize: 12
                            Layout.preferredHeight: 30
                            font.family: "Times New Roman"
                            Layout.preferredWidth: 130
                            onClicked:
                            {
                                var list_checked = [] ;

                                if(k2_1.checked)
                                {
                                    list_checked.push("1");
                                }
                                else
                                {
                                    list_checked.push("0");
                                }
                                if(k2_2.checked)
                                {
                                    list_checked.push("1");
                                }
                                else
                                {
                                    list_checked.push("0");
                                }
                                if(k2_3.checked)
                                {
                                    list_checked.push("1");
                                }
                                else
                                {
                                    list_checked.push("0");
                                }
                                if(k2_4.checked)
                                {
                                    list_checked.push("1");
                                }
                                else
                                {
                                    list_checked.push("0");
                                }
                                if(k2_5.checked)
                                {
                                    list_checked.push("1");
                                }
                                else
                                {
                                    list_checked.push("0");
                                }
                                if(k2_6.checked)
                                {
                                    list_checked.push("1");
                                }
                                else
                                {
                                    list_checked.push("0");
                                }
                                if(k2_7.checked)
                                {
                                    list_checked.push("1");
                                }
                                else
                                {
                                    list_checked.push("0");
                                }
                                if(k2_8.checked)
                                {
                                    list_checked.push("1");
                                }
                                else
                                {
                                    list_checked.push("0");
                                }
                                if(k2_9.checked)
                                {
                                    list_checked.push("1");
                                }
                                else
                                {
                                    list_checked.push("0");
                                }
                                if(k2_10.checked)
                                {
                                    list_checked.push("1");
                                }
                                else
                                {
                                    list_checked.push("0");
                                }

                                w.list_k2_QML = list_checked;

                                //console.log(w.list_k2_QML);

                                w.rele_portON(list_checked,2);

                            }
                        }

                        Switch {
                            id: k2_6
                            text: qsTr("Порт 6")
                            enabled: false
                            font.pointSize: 12
                            Layout.preferredHeight: 30
                            font.family: "Times New Roman"
                            Layout.preferredWidth: 130
                            onClicked:
                            {
                                var list_checked = [] ;

                                if(k2_1.checked)
                                {
                                    list_checked.push("1");
                                }
                                else
                                {
                                    list_checked.push("0");
                                }
                                if(k2_2.checked)
                                {
                                    list_checked.push("1");
                                }
                                else
                                {
                                    list_checked.push("0");
                                }
                                if(k2_3.checked)
                                {
                                    list_checked.push("1");
                                }
                                else
                                {
                                    list_checked.push("0");
                                }
                                if(k2_4.checked)
                                {
                                    list_checked.push("1");
                                }
                                else
                                {
                                    list_checked.push("0");
                                }
                                if(k2_5.checked)
                                {
                                    list_checked.push("1");
                                }
                                else
                                {
                                    list_checked.push("0");
                                }
                                if(k2_6.checked)
                                {
                                    list_checked.push("1");
                                }
                                else
                                {
                                    list_checked.push("0");
                                }
                                if(k2_7.checked)
                                {
                                    list_checked.push("1");
                                }
                                else
                                {
                                    list_checked.push("0");
                                }
                                if(k2_8.checked)
                                {
                                    list_checked.push("1");
                                }
                                else
                                {
                                    list_checked.push("0");
                                }
                                if(k2_9.checked)
                                {
                                    list_checked.push("1");
                                }
                                else
                                {
                                    list_checked.push("0");
                                }
                                if(k2_10.checked)
                                {
                                    list_checked.push("1");
                                }
                                else
                                {
                                    list_checked.push("0");
                                }

                                w.list_k2_QML = list_checked;

                                //console.log(w.list_k2_QML);

                                w.rele_portON(list_checked,2);

                            }
                        }

                        Switch {
                            id: k2_7
                            text: qsTr("Порт 7")
                            enabled: false
                            font.pointSize: 12
                            Layout.preferredHeight: 30
                            font.family: "Times New Roman"
                            Layout.preferredWidth: 130
                            onClicked:
                            {
                                var list_checked = [] ;

                                if(k2_1.checked)
                                {
                                    list_checked.push("1");
                                }
                                else
                                {
                                    list_checked.push("0");
                                }
                                if(k2_2.checked)
                                {
                                    list_checked.push("1");
                                }
                                else
                                {
                                    list_checked.push("0");
                                }
                                if(k2_3.checked)
                                {
                                    list_checked.push("1");
                                }
                                else
                                {
                                    list_checked.push("0");
                                }
                                if(k2_4.checked)
                                {
                                    list_checked.push("1");
                                }
                                else
                                {
                                    list_checked.push("0");
                                }
                                if(k2_5.checked)
                                {
                                    list_checked.push("1");
                                }
                                else
                                {
                                    list_checked.push("0");
                                }
                                if(k2_6.checked)
                                {
                                    list_checked.push("1");
                                }
                                else
                                {
                                    list_checked.push("0");
                                }
                                if(k2_7.checked)
                                {
                                    list_checked.push("1");
                                }
                                else
                                {
                                    list_checked.push("0");
                                }
                                if(k2_8.checked)
                                {
                                    list_checked.push("1");
                                }
                                else
                                {
                                    list_checked.push("0");
                                }
                                if(k2_9.checked)
                                {
                                    list_checked.push("1");
                                }
                                else
                                {
                                    list_checked.push("0");
                                }
                                if(k2_10.checked)
                                {
                                    list_checked.push("1");
                                }
                                else
                                {
                                    list_checked.push("0");
                                }

                                w.list_k2_QML = list_checked;

                                //console.log(w.list_k2_QML);

                                w.rele_portON(list_checked,2);

                            }
                        }

                        Switch {
                            id: k2_8
                            text: qsTr("Порт 8")
                            enabled: false
                            font.pointSize: 12
                            Layout.preferredHeight: 30
                            font.family: "Times New Roman"
                            Layout.preferredWidth: 130
                            onClicked:
                            {
                                var list_checked = [] ;

                                if(k2_1.checked)
                                {
                                    list_checked.push("1");
                                }
                                else
                                {
                                    list_checked.push("0");
                                }
                                if(k2_2.checked)
                                {
                                    list_checked.push("1");
                                }
                                else
                                {
                                    list_checked.push("0");
                                }
                                if(k2_3.checked)
                                {
                                    list_checked.push("1");
                                }
                                else
                                {
                                    list_checked.push("0");
                                }
                                if(k2_4.checked)
                                {
                                    list_checked.push("1");
                                }
                                else
                                {
                                    list_checked.push("0");
                                }
                                if(k2_5.checked)
                                {
                                    list_checked.push("1");
                                }
                                else
                                {
                                    list_checked.push("0");
                                }
                                if(k2_6.checked)
                                {
                                    list_checked.push("1");
                                }
                                else
                                {
                                    list_checked.push("0");
                                }
                                if(k2_7.checked)
                                {
                                    list_checked.push("1");
                                }
                                else
                                {
                                    list_checked.push("0");
                                }
                                if(k2_8.checked)
                                {
                                    list_checked.push("1");
                                }
                                else
                                {
                                    list_checked.push("0");
                                }
                                if(k2_9.checked)
                                {
                                    list_checked.push("1");
                                }
                                else
                                {
                                    list_checked.push("0");
                                }
                                if(k2_10.checked)
                                {
                                    list_checked.push("1");
                                }
                                else
                                {
                                    list_checked.push("0");
                                }

                                w.list_k2_QML = list_checked;

                                //console.log(w.list_k2_QML);

                                w.rele_portON(list_checked,2);

                            }
                        }

                        Switch {
                            id: k2_9
                            text: qsTr("Порт 9")
                            enabled: false
                            font.pointSize: 12
                            Layout.preferredHeight: 30
                            font.family: "Times New Roman"
                            Layout.preferredWidth: 130
                            onClicked:
                            {
                                var list_checked = [] ;

                                if(k2_1.checked)
                                {
                                    list_checked.push("1");
                                }
                                else
                                {
                                    list_checked.push("0");
                                }
                                if(k2_2.checked)
                                {
                                    list_checked.push("1");
                                }
                                else
                                {
                                    list_checked.push("0");
                                }
                                if(k2_3.checked)
                                {
                                    list_checked.push("1");
                                }
                                else
                                {
                                    list_checked.push("0");
                                }
                                if(k2_4.checked)
                                {
                                    list_checked.push("1");
                                }
                                else
                                {
                                    list_checked.push("0");
                                }
                                if(k2_5.checked)
                                {
                                    list_checked.push("1");
                                }
                                else
                                {
                                    list_checked.push("0");
                                }
                                if(k2_6.checked)
                                {
                                    list_checked.push("1");
                                }
                                else
                                {
                                    list_checked.push("0");
                                }
                                if(k2_7.checked)
                                {
                                    list_checked.push("1");
                                }
                                else
                                {
                                    list_checked.push("0");
                                }
                                if(k2_8.checked)
                                {
                                    list_checked.push("1");
                                }
                                else
                                {
                                    list_checked.push("0");
                                }
                                if(k2_9.checked)
                                {
                                    list_checked.push("1");
                                }
                                else
                                {
                                    list_checked.push("0");
                                }
                                if(k2_10.checked)
                                {
                                    list_checked.push("1");
                                }
                                else
                                {
                                    list_checked.push("0");
                                }

                                w.list_k2_QML = list_checked;

                                //console.log(w.list_k2_QML);

                                w.rele_portON(list_checked,2);

                            }
                        }

                        Switch {
                            id: k2_10
                            text: qsTr("Порт 10")
                            enabled: false
                            font.pointSize: 12
                            Layout.preferredHeight: 30
                            font.family: "Times New Roman"
                            Layout.preferredWidth: 130
                            onClicked:
                            {
                                var list_checked = [] ;

                                if(k2_1.checked)
                                {
                                    list_checked.push("1");
                                }
                                else
                                {
                                    list_checked.push("0");
                                }
                                if(k2_2.checked)
                                {
                                    list_checked.push("1");
                                }
                                else
                                {
                                    list_checked.push("0");
                                }
                                if(k2_3.checked)
                                {
                                    list_checked.push("1");
                                }
                                else
                                {
                                    list_checked.push("0");
                                }
                                if(k2_4.checked)
                                {
                                    list_checked.push("1");
                                }
                                else
                                {
                                    list_checked.push("0");
                                }
                                if(k2_5.checked)
                                {
                                    list_checked.push("1");
                                }
                                else
                                {
                                    list_checked.push("0");
                                }
                                if(k2_6.checked)
                                {
                                    list_checked.push("1");
                                }
                                else
                                {
                                    list_checked.push("0");
                                }
                                if(k2_7.checked)
                                {
                                    list_checked.push("1");
                                }
                                else
                                {
                                    list_checked.push("0");
                                }
                                if(k2_8.checked)
                                {
                                    list_checked.push("1");
                                }
                                else
                                {
                                    list_checked.push("0");
                                }
                                if(k2_9.checked)
                                {
                                    list_checked.push("1");
                                }
                                else
                                {
                                    list_checked.push("0");
                                }
                                if(k2_10.checked)
                                {
                                    list_checked.push("1");
                                }
                                else
                                {
                                    list_checked.push("0");
                                }

                                w.list_k2_QML = list_checked;

                                //console.log(w.list_k2_QML);

                                w.rele_portON(list_checked,2);

                            }
                        }
                    }
                }
            }

            GridLayout {
                id: layout_analiz
                x: 465
                y: 45
                width: 270
                height: 420
                anchors.verticalCenter: parent.verticalCenter
                anchors.horizontalCenterOffset: 200
                anchors.horizontalCenter: parent.horizontalCenter

                GroupBox {
                    id: k6
                    x: 64
                    y: 0
                    width: 140
                    height: 64
                    font.pointSize: 12
                    Layout.columnSpan: 2
                    padding: 12
                    Layout.fillWidth: false
                    spacing: 5
                    Layout.preferredHeight: 64
                    Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                    Layout.fillHeight: false
                    font.family: "Times New Roman"
                    title: qsTr("    Анализатор")
                    Layout.preferredWidth: 140

                    RadioButton {
                        id: k3
                        x: -12
                        y: -12
                        width: 70
                        text: qsTr("K3")
                        enabled: false
                        font.pointSize: 12
                        font.family: "Times New Roman"
                        onClicked:
                        {
                            w.analizatorON(1);
                            w.zaprosSOST_rele(3);

                            //w.readDatagram_rele(3);

                            k3_1.enabled=true;
                            k3_2.enabled=true;
                            k3_3.enabled=true;
                            k3_4.enabled=true;
                            k3_5.enabled=true;
                            k3_6.enabled=true;
                            k3_7.enabled=true;
                            k3_8.enabled=true;
                            k3_9.enabled=true;
                            k3_10.enabled=true;
                        }

                        Connections
                        {
                            target: w

                            onSignal_prishlo_sost_K3:
                            {
                                var list_string  = [];
                                list_string  = w.list_k3_QML;

                                if(list_string[0] == 1)
                                {
                                    k3_1.checked = true;
                                }
                                else
                                {
                                    k3_1.checked= false;
                                }

                                if(list_string[1] ==1)
                                {
                                    k3_2.checked=true;
                                }
                                else
                                {
                                    k3_2.checked=false;
                                }

                                if(list_string[2]==1)
                                {
                                    k3_3.checked = true;
                                }
                                else
                                {
                                    k3_3.checked= false;
                                }

                                if(list_string[3] == 1)
                                {
                                    k3_4.checked=true;
                                }
                                else
                                {
                                    k3_4.checked=false;
                                }

                                if(list_string[4] == 1)
                                {
                                    k3_5.checked=true;
                                }
                                else
                                {
                                    k3_5.checked=false;
                                }

                                if(list_string[5]==1)
                                {
                                    k3_6.checked = true;
                                }
                                else
                                {
                                    k3_6.checked= false;
                                }

                                if(list_string[6] == 1)
                                {
                                    k3_7.checked=true;
                                }
                                else
                                {
                                    k3_7.checked=false;
                                }

                                if(list_string[7]==1)
                                {
                                    k3_8.checked = true;
                                }
                                else
                                {
                                    k3_8.checked= false;
                                }

                                if(list_string[8] == 1)
                                {
                                    k3_9.checked=true;
                                }
                                else
                                {
                                    k3_9.checked=false;
                                }

                                if(list_string[9] == 1)
                                {
                                    k3_10.checked=true;
                                }
                                else
                                {
                                    k3_10.checked=false;
                                }

                                //console.log(list_string);
                            }
                        }
                    }

                    RadioButton {
                        id: k4
                        x: 58
                        y: -12
                        width: 70
                        text: qsTr("K4")
                        enabled: false
                        font.pointSize: 12
                        font.family: "Times New Roman"
                        onClicked:
                        {
                            w.analizatorON(2);
                            w.zaprosSOST_rele(4);

                            //w.readDatagram_rele(4);

                            k4_1.enabled=true;
                            k4_2.enabled=true;
                            k4_3.enabled=true;
                            k4_4.enabled=true;
                            k4_5.enabled=true;
                            k4_6.enabled=true;
                            k4_7.enabled=true;
                            k4_8.enabled=true;
                            k4_9.enabled=true;
                            k4_10.enabled=true;
                        }

                        Connections
                        {
                            target: w

                            onSignal_prishlo_sost_K4:
                            {
                                var list_string  = [];
                                list_string  = w.list_k4_QML;

                                if(list_string[0] == 1)
                                {
                                    k4_1.checked = true;
                                }
                                else
                                {
                                    k4_1.checked= false;
                                }

                                if(list_string[1] ==1)
                                {
                                    k4_2.checked=true;
                                }
                                else
                                {
                                    k4_2.checked=false;
                                }

                                if(list_string[2]==1)
                                {
                                    k4_3.checked = true;
                                }
                                else
                                {
                                    k4_3.checked= false;
                                }

                                if(list_string[3] == 1)
                                {
                                    k4_4.checked=true;
                                }
                                else
                                {
                                    k4_4.checked=false;
                                }

                                if(list_string[4] == 1)
                                {
                                    k4_5.checked=true;
                                }
                                else
                                {
                                    k4_5.checked=false;
                                }

                                if(list_string[5]==1)
                                {
                                    k4_6.checked = true;
                                }
                                else
                                {
                                    k4_6.checked= false;
                                }

                                if(list_string[6] == 1)
                                {
                                    k4_7.checked=true;
                                }
                                else
                                {
                                    k4_7.checked=false;
                                }

                                if(list_string[7]==1)
                                {
                                    k4_8.checked = true;
                                }
                                else
                                {
                                    k4_8.checked= false;
                                }

                                if(list_string[8] == 1)
                                {
                                    k4_9.checked=true;
                                }
                                else
                                {
                                    k4_9.checked=false;
                                }

                                if(list_string[9] == 1)
                                {
                                    k4_10.checked=true;
                                }
                                else
                                {
                                    k4_10.checked=false;
                                }

                                //console.log(list_string);
                            }
                        }
                    }

                }

                GridLayout {
                    id: analiz
                    x: 2
                    y: 70
                    width: 270
                    height: 350
                    ColumnLayout {
                        id: analiz_k_k3
                        x: 0
                        Layout.columnSpan: 2
                        Switch {
                            id: k3_1
                            text: qsTr("Порт 1")
                            enabled: false
                            font.pointSize: 12
                            Layout.preferredHeight: 30
                            font.family: "Times New Roman"
                            Layout.preferredWidth: 130
                            onClicked:
                            {
                                var list_checked = [] ;

                                if(k3_1.checked)
                                {
                                    list_checked.push("1");
                                }
                                else
                                {
                                    list_checked.push("0");
                                }
                                if(k3_2.checked)
                                {
                                    list_checked.push("1");
                                }
                                else
                                {
                                    list_checked.push("0");
                                }
                                if(k3_3.checked)
                                {
                                    list_checked.push("1");
                                }
                                else
                                {
                                    list_checked.push("0");
                                }
                                if(k3_4.checked)
                                {
                                    list_checked.push("1");
                                }
                                else
                                {
                                    list_checked.push("0");
                                }
                                if(k3_5.checked)
                                {
                                    list_checked.push("1");
                                }
                                else
                                {
                                    list_checked.push("0");
                                }
                                if(k3_6.checked)
                                {
                                    list_checked.push("1");
                                }
                                else
                                {
                                    list_checked.push("0");
                                }
                                if(k3_7.checked)
                                {
                                    list_checked.push("1");
                                }
                                else
                                {
                                    list_checked.push("0");
                                }
                                if(k3_8.checked)
                                {
                                    list_checked.push("1");
                                }
                                else
                                {
                                    list_checked.push("0");
                                }
                                if(k3_9.checked)
                                {
                                    list_checked.push("1");
                                }
                                else
                                {
                                    list_checked.push("0");
                                }
                                if(k3_10.checked)
                                {
                                    list_checked.push("1");
                                }
                                else
                                {
                                    list_checked.push("0");
                                }

                                w.list_k3_QML = list_checked;

                                //console.log(w.list_k3_QML);

                                w.rele_portON(list_checked,3);

                            }
                        }

                        Switch {
                            id: k3_2
                            text: qsTr("Порт 2")
                            enabled: false
                            font.pointSize: 12
                            Layout.preferredHeight: 30
                            font.family: "Times New Roman"
                            Layout.preferredWidth: 130
                            onClicked:
                            {
                                var list_checked = [] ;

                                if(k3_1.checked)
                                {
                                    list_checked.push("1");
                                }
                                else
                                {
                                    list_checked.push("0");
                                }
                                if(k3_2.checked)
                                {
                                    list_checked.push("1");
                                }
                                else
                                {
                                    list_checked.push("0");
                                }
                                if(k3_3.checked)
                                {
                                    list_checked.push("1");
                                }
                                else
                                {
                                    list_checked.push("0");
                                }
                                if(k3_4.checked)
                                {
                                    list_checked.push("1");
                                }
                                else
                                {
                                    list_checked.push("0");
                                }
                                if(k3_5.checked)
                                {
                                    list_checked.push("1");
                                }
                                else
                                {
                                    list_checked.push("0");
                                }
                                if(k3_6.checked)
                                {
                                    list_checked.push("1");
                                }
                                else
                                {
                                    list_checked.push("0");
                                }
                                if(k3_7.checked)
                                {
                                    list_checked.push("1");
                                }
                                else
                                {
                                    list_checked.push("0");
                                }
                                if(k3_8.checked)
                                {
                                    list_checked.push("1");
                                }
                                else
                                {
                                    list_checked.push("0");
                                }
                                if(k3_9.checked)
                                {
                                    list_checked.push("1");
                                }
                                else
                                {
                                    list_checked.push("0");
                                }
                                if(k3_10.checked)
                                {
                                    list_checked.push("1");
                                }
                                else
                                {
                                    list_checked.push("0");
                                }

                                w.list_k3_QML = list_checked;

                                //console.log(w.list_k3_QML);

                                w.rele_portON(list_checked,3);

                            }
                        }

                        Switch {
                            id: k3_3
                            text: qsTr("Порт 3")
                            enabled: false
                            font.pointSize: 12
                            Layout.preferredHeight: 30
                            font.family: "Times New Roman"
                            Layout.preferredWidth: 130
                            onClicked:
                            {
                                var list_checked = [] ;

                                if(k3_1.checked)
                                {
                                    list_checked.push("1");
                                }
                                else
                                {
                                    list_checked.push("0");
                                }
                                if(k3_2.checked)
                                {
                                    list_checked.push("1");
                                }
                                else
                                {
                                    list_checked.push("0");
                                }
                                if(k3_3.checked)
                                {
                                    list_checked.push("1");
                                }
                                else
                                {
                                    list_checked.push("0");
                                }
                                if(k3_4.checked)
                                {
                                    list_checked.push("1");
                                }
                                else
                                {
                                    list_checked.push("0");
                                }
                                if(k3_5.checked)
                                {
                                    list_checked.push("1");
                                }
                                else
                                {
                                    list_checked.push("0");
                                }
                                if(k3_6.checked)
                                {
                                    list_checked.push("1");
                                }
                                else
                                {
                                    list_checked.push("0");
                                }
                                if(k3_7.checked)
                                {
                                    list_checked.push("1");
                                }
                                else
                                {
                                    list_checked.push("0");
                                }
                                if(k3_8.checked)
                                {
                                    list_checked.push("1");
                                }
                                else
                                {
                                    list_checked.push("0");
                                }
                                if(k3_9.checked)
                                {
                                    list_checked.push("1");
                                }
                                else
                                {
                                    list_checked.push("0");
                                }
                                if(k3_10.checked)
                                {
                                    list_checked.push("1");
                                }
                                else
                                {
                                    list_checked.push("0");
                                }

                                w.list_k3_QML = list_checked;

                                //console.log(w.list_k3_QML);

                                w.rele_portON(list_checked,3);

                            }
                        }

                        Switch {
                            id: k3_4
                            text: qsTr("Порт 4")
                            enabled: false
                            font.pointSize: 12
                            Layout.preferredHeight: 30
                            font.family: "Times New Roman"
                            Layout.preferredWidth: 130
                            onClicked:
                            {
                                var list_checked = [] ;

                                if(k3_1.checked)
                                {
                                    list_checked.push("1");
                                }
                                else
                                {
                                    list_checked.push("0");
                                }
                                if(k3_2.checked)
                                {
                                    list_checked.push("1");
                                }
                                else
                                {
                                    list_checked.push("0");
                                }
                                if(k3_3.checked)
                                {
                                    list_checked.push("1");
                                }
                                else
                                {
                                    list_checked.push("0");
                                }
                                if(k3_4.checked)
                                {
                                    list_checked.push("1");
                                }
                                else
                                {
                                    list_checked.push("0");
                                }
                                if(k3_5.checked)
                                {
                                    list_checked.push("1");
                                }
                                else
                                {
                                    list_checked.push("0");
                                }
                                if(k3_6.checked)
                                {
                                    list_checked.push("1");
                                }
                                else
                                {
                                    list_checked.push("0");
                                }
                                if(k3_7.checked)
                                {
                                    list_checked.push("1");
                                }
                                else
                                {
                                    list_checked.push("0");
                                }
                                if(k3_8.checked)
                                {
                                    list_checked.push("1");
                                }
                                else
                                {
                                    list_checked.push("0");
                                }
                                if(k3_9.checked)
                                {
                                    list_checked.push("1");
                                }
                                else
                                {
                                    list_checked.push("0");
                                }
                                if(k3_10.checked)
                                {
                                    list_checked.push("1");
                                }
                                else
                                {
                                    list_checked.push("0");
                                }

                                w.list_k3_QML = list_checked;

                                //console.log(w.list_k3_QML);

                                w.rele_portON(list_checked,3);

                            }
                        }

                        Switch {
                            id: k3_5
                            text: qsTr("Порт 5")
                            enabled: false
                            font.pointSize: 12
                            Layout.preferredHeight: 30
                            font.family: "Times New Roman"
                            Layout.preferredWidth: 130
                            onClicked:
                            {
                                var list_checked = [] ;

                                if(k3_1.checked)
                                {
                                    list_checked.push("1");
                                }
                                else
                                {
                                    list_checked.push("0");
                                }
                                if(k3_2.checked)
                                {
                                    list_checked.push("1");
                                }
                                else
                                {
                                    list_checked.push("0");
                                }
                                if(k3_3.checked)
                                {
                                    list_checked.push("1");
                                }
                                else
                                {
                                    list_checked.push("0");
                                }
                                if(k3_4.checked)
                                {
                                    list_checked.push("1");
                                }
                                else
                                {
                                    list_checked.push("0");
                                }
                                if(k3_5.checked)
                                {
                                    list_checked.push("1");
                                }
                                else
                                {
                                    list_checked.push("0");
                                }
                                if(k3_6.checked)
                                {
                                    list_checked.push("1");
                                }
                                else
                                {
                                    list_checked.push("0");
                                }
                                if(k3_7.checked)
                                {
                                    list_checked.push("1");
                                }
                                else
                                {
                                    list_checked.push("0");
                                }
                                if(k3_8.checked)
                                {
                                    list_checked.push("1");
                                }
                                else
                                {
                                    list_checked.push("0");
                                }
                                if(k3_9.checked)
                                {
                                    list_checked.push("1");
                                }
                                else
                                {
                                    list_checked.push("0");
                                }
                                if(k3_10.checked)
                                {
                                    list_checked.push("1");
                                }
                                else
                                {
                                    list_checked.push("0");
                                }

                                w.list_k3_QML = list_checked;

                                //console.log(w.list_k3_QML);

                                w.rele_portON(list_checked,3);

                            }
                        }

                        Switch {
                            id: k3_6
                            text: qsTr("Порт 6")
                            enabled: false
                            font.pointSize: 12
                            Layout.preferredHeight: 30
                            font.family: "Times New Roman"
                            Layout.preferredWidth: 130
                            onClicked:
                            {
                                var list_checked = [] ;

                                if(k3_1.checked)
                                {
                                    list_checked.push("1");
                                }
                                else
                                {
                                    list_checked.push("0");
                                }
                                if(k3_2.checked)
                                {
                                    list_checked.push("1");
                                }
                                else
                                {
                                    list_checked.push("0");
                                }
                                if(k3_3.checked)
                                {
                                    list_checked.push("1");
                                }
                                else
                                {
                                    list_checked.push("0");
                                }
                                if(k3_4.checked)
                                {
                                    list_checked.push("1");
                                }
                                else
                                {
                                    list_checked.push("0");
                                }
                                if(k3_5.checked)
                                {
                                    list_checked.push("1");
                                }
                                else
                                {
                                    list_checked.push("0");
                                }
                                if(k3_6.checked)
                                {
                                    list_checked.push("1");
                                }
                                else
                                {
                                    list_checked.push("0");
                                }
                                if(k3_7.checked)
                                {
                                    list_checked.push("1");
                                }
                                else
                                {
                                    list_checked.push("0");
                                }
                                if(k3_8.checked)
                                {
                                    list_checked.push("1");
                                }
                                else
                                {
                                    list_checked.push("0");
                                }
                                if(k3_9.checked)
                                {
                                    list_checked.push("1");
                                }
                                else
                                {
                                    list_checked.push("0");
                                }
                                if(k3_10.checked)
                                {
                                    list_checked.push("1");
                                }
                                else
                                {
                                    list_checked.push("0");
                                }

                                w.list_k3_QML = list_checked;

                                //console.log(w.list_k3_QML);

                                w.rele_portON(list_checked,3);

                            }
                        }

                        Switch {
                            id: k3_7
                            text: qsTr("Порт 7")
                            enabled: false
                            font.pointSize: 12
                            Layout.preferredHeight: 30
                            font.family: "Times New Roman"
                            Layout.preferredWidth: 130
                            onClicked:
                            {
                                var list_checked = [] ;

                                if(k3_1.checked)
                                {
                                    list_checked.push("1");
                                }
                                else
                                {
                                    list_checked.push("0");
                                }
                                if(k3_2.checked)
                                {
                                    list_checked.push("1");
                                }
                                else
                                {
                                    list_checked.push("0");
                                }
                                if(k3_3.checked)
                                {
                                    list_checked.push("1");
                                }
                                else
                                {
                                    list_checked.push("0");
                                }
                                if(k3_4.checked)
                                {
                                    list_checked.push("1");
                                }
                                else
                                {
                                    list_checked.push("0");
                                }
                                if(k3_5.checked)
                                {
                                    list_checked.push("1");
                                }
                                else
                                {
                                    list_checked.push("0");
                                }
                                if(k3_6.checked)
                                {
                                    list_checked.push("1");
                                }
                                else
                                {
                                    list_checked.push("0");
                                }
                                if(k3_7.checked)
                                {
                                    list_checked.push("1");
                                }
                                else
                                {
                                    list_checked.push("0");
                                }
                                if(k3_8.checked)
                                {
                                    list_checked.push("1");
                                }
                                else
                                {
                                    list_checked.push("0");
                                }
                                if(k3_9.checked)
                                {
                                    list_checked.push("1");
                                }
                                else
                                {
                                    list_checked.push("0");
                                }
                                if(k3_10.checked)
                                {
                                    list_checked.push("1");
                                }
                                else
                                {
                                    list_checked.push("0");
                                }

                                w.list_k3_QML = list_checked;

                                //console.log(w.list_k3_QML);

                                w.rele_portON(list_checked,3);

                            }
                        }

                        Switch {
                            id: k3_8
                            text: qsTr("Порт 8")
                            enabled: false
                            font.pointSize: 12
                            Layout.preferredHeight: 30
                            font.family: "Times New Roman"
                            Layout.preferredWidth: 130
                            onClicked:
                            {
                                var list_checked = [] ;

                                if(k3_1.checked)
                                {
                                    list_checked.push("1");
                                }
                                else
                                {
                                    list_checked.push("0");
                                }
                                if(k3_2.checked)
                                {
                                    list_checked.push("1");
                                }
                                else
                                {
                                    list_checked.push("0");
                                }
                                if(k3_3.checked)
                                {
                                    list_checked.push("1");
                                }
                                else
                                {
                                    list_checked.push("0");
                                }
                                if(k3_4.checked)
                                {
                                    list_checked.push("1");
                                }
                                else
                                {
                                    list_checked.push("0");
                                }
                                if(k3_5.checked)
                                {
                                    list_checked.push("1");
                                }
                                else
                                {
                                    list_checked.push("0");
                                }
                                if(k3_6.checked)
                                {
                                    list_checked.push("1");
                                }
                                else
                                {
                                    list_checked.push("0");
                                }
                                if(k3_7.checked)
                                {
                                    list_checked.push("1");
                                }
                                else
                                {
                                    list_checked.push("0");
                                }
                                if(k3_8.checked)
                                {
                                    list_checked.push("1");
                                }
                                else
                                {
                                    list_checked.push("0");
                                }
                                if(k3_9.checked)
                                {
                                    list_checked.push("1");
                                }
                                else
                                {
                                    list_checked.push("0");
                                }
                                if(k3_10.checked)
                                {
                                    list_checked.push("1");
                                }
                                else
                                {
                                    list_checked.push("0");
                                }

                                w.list_k3_QML = list_checked;

                                //console.log(w.list_k3_QML);

                                w.rele_portON(list_checked,3);

                            }
                        }

                        Switch {
                            id: k3_9
                            text: qsTr("Порт 9")
                            enabled: false
                            font.pointSize: 12
                            Layout.preferredHeight: 30
                            font.family: "Times New Roman"
                            Layout.preferredWidth: 130
                            onClicked:
                            {
                                var list_checked = [] ;

                                if(k3_1.checked)
                                {
                                    list_checked.push("1");
                                }
                                else
                                {
                                    list_checked.push("0");
                                }
                                if(k3_2.checked)
                                {
                                    list_checked.push("1");
                                }
                                else
                                {
                                    list_checked.push("0");
                                }
                                if(k3_3.checked)
                                {
                                    list_checked.push("1");
                                }
                                else
                                {
                                    list_checked.push("0");
                                }
                                if(k3_4.checked)
                                {
                                    list_checked.push("1");
                                }
                                else
                                {
                                    list_checked.push("0");
                                }
                                if(k3_5.checked)
                                {
                                    list_checked.push("1");
                                }
                                else
                                {
                                    list_checked.push("0");
                                }
                                if(k3_6.checked)
                                {
                                    list_checked.push("1");
                                }
                                else
                                {
                                    list_checked.push("0");
                                }
                                if(k3_7.checked)
                                {
                                    list_checked.push("1");
                                }
                                else
                                {
                                    list_checked.push("0");
                                }
                                if(k3_8.checked)
                                {
                                    list_checked.push("1");
                                }
                                else
                                {
                                    list_checked.push("0");
                                }
                                if(k3_9.checked)
                                {
                                    list_checked.push("1");
                                }
                                else
                                {
                                    list_checked.push("0");
                                }
                                if(k3_10.checked)
                                {
                                    list_checked.push("1");
                                }
                                else
                                {
                                    list_checked.push("0");
                                }

                                w.list_k3_QML = list_checked;

                                //console.log(w.list_k3_QML);

                                w.rele_portON(list_checked,3);

                            }
                        }

                        Switch {
                            id: k3_10
                            text: qsTr("Порт 10")
                            enabled: false
                            font.pointSize: 12
                            Layout.preferredHeight: 30
                            font.family: "Times New Roman"
                            Layout.preferredWidth: 130
                            onClicked:
                            {
                                var list_checked = [] ;

                                if(k3_1.checked)
                                {
                                    list_checked.push("1");
                                }
                                else
                                {
                                    list_checked.push("0");
                                }
                                if(k3_2.checked)
                                {
                                    list_checked.push("1");
                                }
                                else
                                {
                                    list_checked.push("0");
                                }
                                if(k3_3.checked)
                                {
                                    list_checked.push("1");
                                }
                                else
                                {
                                    list_checked.push("0");
                                }
                                if(k3_4.checked)
                                {
                                    list_checked.push("1");
                                }
                                else
                                {
                                    list_checked.push("0");
                                }
                                if(k3_5.checked)
                                {
                                    list_checked.push("1");
                                }
                                else
                                {
                                    list_checked.push("0");
                                }
                                if(k3_6.checked)
                                {
                                    list_checked.push("1");
                                }
                                else
                                {
                                    list_checked.push("0");
                                }
                                if(k3_7.checked)
                                {
                                    list_checked.push("1");
                                }
                                else
                                {
                                    list_checked.push("0");
                                }
                                if(k3_8.checked)
                                {
                                    list_checked.push("1");
                                }
                                else
                                {
                                    list_checked.push("0");
                                }
                                if(k3_9.checked)
                                {
                                    list_checked.push("1");
                                }
                                else
                                {
                                    list_checked.push("0");
                                }
                                if(k3_10.checked)
                                {
                                    list_checked.push("1");
                                }
                                else
                                {
                                    list_checked.push("0");
                                }

                                w.list_k3_QML = list_checked;

                                //console.log(w.list_k3_QML);

                                w.rele_portON(list_checked,3);

                            }
                        }
                    }

                    ColumnLayout {
                        id: analiz_k_k4
                        x: 140
                        Layout.columnSpan: 2
                        Switch {
                            id: k4_1
                            text: qsTr("Порт 1")
                            enabled: false
                            font.pointSize: 12
                            Layout.preferredHeight: 30
                            font.family: "Times New Roman"
                            Layout.preferredWidth: 130
                            onClicked:
                            {
                                var list_checked = [] ;

                                if(k4_1.checked)
                                {
                                    list_checked.push("1");
                                }
                                else
                                {
                                    list_checked.push("0");
                                }
                                if(k4_2.checked)
                                {
                                    list_checked.push("1");
                                }
                                else
                                {
                                    list_checked.push("0");
                                }
                                if(k4_3.checked)
                                {
                                    list_checked.push("1");
                                }
                                else
                                {
                                    list_checked.push("0");
                                }
                                if(k4_4.checked)
                                {
                                    list_checked.push("1");
                                }
                                else
                                {
                                    list_checked.push("0");
                                }
                                if(k4_5.checked)
                                {
                                    list_checked.push("1");
                                }
                                else
                                {
                                    list_checked.push("0");
                                }
                                if(k4_6.checked)
                                {
                                    list_checked.push("1");
                                }
                                else
                                {
                                    list_checked.push("0");
                                }
                                if(k4_7.checked)
                                {
                                    list_checked.push("1");
                                }
                                else
                                {
                                    list_checked.push("0");
                                }
                                if(k4_8.checked)
                                {
                                    list_checked.push("1");
                                }
                                else
                                {
                                    list_checked.push("0");
                                }
                                if(k4_9.checked)
                                {
                                    list_checked.push("1");
                                }
                                else
                                {
                                    list_checked.push("0");
                                }
                                if(k4_10.checked)
                                {
                                    list_checked.push("1");
                                }
                                else
                                {
                                    list_checked.push("0");
                                }

                                w.list_k4_QML = list_checked;

                                //console.log(w.list_k4_QML);

                                w.rele_portON(list_checked,4);

                            }
                        }

                        Switch {
                            id: k4_2
                            text: qsTr("Порт 2")
                            enabled: false
                            font.pointSize: 12
                            Layout.preferredHeight: 30
                            font.family: "Times New Roman"
                            Layout.preferredWidth: 130
                            onClicked:
                            {
                                var list_checked = [] ;

                                if(k4_1.checked)
                                {
                                    list_checked.push("1");
                                }
                                else
                                {
                                    list_checked.push("0");
                                }
                                if(k4_2.checked)
                                {
                                    list_checked.push("1");
                                }
                                else
                                {
                                    list_checked.push("0");
                                }
                                if(k4_3.checked)
                                {
                                    list_checked.push("1");
                                }
                                else
                                {
                                    list_checked.push("0");
                                }
                                if(k4_4.checked)
                                {
                                    list_checked.push("1");
                                }
                                else
                                {
                                    list_checked.push("0");
                                }
                                if(k4_5.checked)
                                {
                                    list_checked.push("1");
                                }
                                else
                                {
                                    list_checked.push("0");
                                }
                                if(k4_6.checked)
                                {
                                    list_checked.push("1");
                                }
                                else
                                {
                                    list_checked.push("0");
                                }
                                if(k4_7.checked)
                                {
                                    list_checked.push("1");
                                }
                                else
                                {
                                    list_checked.push("0");
                                }
                                if(k4_8.checked)
                                {
                                    list_checked.push("1");
                                }
                                else
                                {
                                    list_checked.push("0");
                                }
                                if(k4_9.checked)
                                {
                                    list_checked.push("1");
                                }
                                else
                                {
                                    list_checked.push("0");
                                }
                                if(k4_10.checked)
                                {
                                    list_checked.push("1");
                                }
                                else
                                {
                                    list_checked.push("0");
                                }

                                w.list_k4_QML = list_checked;

                                //console.log(w.list_k4_QML);

                                w.rele_portON(list_checked,4);

                            }
                        }

                        Switch {
                            id: k4_3
                            text: qsTr("Порт 3")
                            enabled: false
                            font.pointSize: 12
                            Layout.preferredHeight: 30
                            font.family: "Times New Roman"
                            Layout.preferredWidth: 130
                            onClicked:
                            {
                                var list_checked = [] ;

                                if(k4_1.checked)
                                {
                                    list_checked.push("1");
                                }
                                else
                                {
                                    list_checked.push("0");
                                }
                                if(k4_2.checked)
                                {
                                    list_checked.push("1");
                                }
                                else
                                {
                                    list_checked.push("0");
                                }
                                if(k4_3.checked)
                                {
                                    list_checked.push("1");
                                }
                                else
                                {
                                    list_checked.push("0");
                                }
                                if(k4_4.checked)
                                {
                                    list_checked.push("1");
                                }
                                else
                                {
                                    list_checked.push("0");
                                }
                                if(k4_5.checked)
                                {
                                    list_checked.push("1");
                                }
                                else
                                {
                                    list_checked.push("0");
                                }
                                if(k4_6.checked)
                                {
                                    list_checked.push("1");
                                }
                                else
                                {
                                    list_checked.push("0");
                                }
                                if(k4_7.checked)
                                {
                                    list_checked.push("1");
                                }
                                else
                                {
                                    list_checked.push("0");
                                }
                                if(k4_8.checked)
                                {
                                    list_checked.push("1");
                                }
                                else
                                {
                                    list_checked.push("0");
                                }
                                if(k4_9.checked)
                                {
                                    list_checked.push("1");
                                }
                                else
                                {
                                    list_checked.push("0");
                                }
                                if(k4_10.checked)
                                {
                                    list_checked.push("1");
                                }
                                else
                                {
                                    list_checked.push("0");
                                }

                                w.list_k4_QML = list_checked;

                                //console.log(w.list_k4_QML);

                                w.rele_portON(list_checked,4);

                            }
                        }

                        Switch {
                            id: k4_4
                            text: qsTr("Порт 4")
                            enabled: false
                            font.pointSize: 12
                            Layout.preferredHeight: 30
                            font.family: "Times New Roman"
                            Layout.preferredWidth: 130
                            onClicked:
                            {
                                var list_checked = [] ;

                                if(k4_1.checked)
                                {
                                    list_checked.push("1");
                                }
                                else
                                {
                                    list_checked.push("0");
                                }
                                if(k4_2.checked)
                                {
                                    list_checked.push("1");
                                }
                                else
                                {
                                    list_checked.push("0");
                                }
                                if(k4_3.checked)
                                {
                                    list_checked.push("1");
                                }
                                else
                                {
                                    list_checked.push("0");
                                }
                                if(k4_4.checked)
                                {
                                    list_checked.push("1");
                                }
                                else
                                {
                                    list_checked.push("0");
                                }
                                if(k4_5.checked)
                                {
                                    list_checked.push("1");
                                }
                                else
                                {
                                    list_checked.push("0");
                                }
                                if(k4_6.checked)
                                {
                                    list_checked.push("1");
                                }
                                else
                                {
                                    list_checked.push("0");
                                }
                                if(k4_7.checked)
                                {
                                    list_checked.push("1");
                                }
                                else
                                {
                                    list_checked.push("0");
                                }
                                if(k4_8.checked)
                                {
                                    list_checked.push("1");
                                }
                                else
                                {
                                    list_checked.push("0");
                                }
                                if(k4_9.checked)
                                {
                                    list_checked.push("1");
                                }
                                else
                                {
                                    list_checked.push("0");
                                }
                                if(k4_10.checked)
                                {
                                    list_checked.push("1");
                                }
                                else
                                {
                                    list_checked.push("0");
                                }

                                w.list_k4_QML = list_checked;

                                //console.log(w.list_k4_QML);

                                w.rele_portON(list_checked,4);

                            }
                        }

                        Switch {
                            id: k4_5
                            text: qsTr("Порт 5")
                            enabled: false
                            font.pointSize: 12
                            Layout.preferredHeight: 30
                            font.family: "Times New Roman"
                            Layout.preferredWidth: 130
                            onClicked:
                            {
                                var list_checked = [] ;

                                if(k4_1.checked)
                                {
                                    list_checked.push("1");
                                }
                                else
                                {
                                    list_checked.push("0");
                                }
                                if(k4_2.checked)
                                {
                                    list_checked.push("1");
                                }
                                else
                                {
                                    list_checked.push("0");
                                }
                                if(k4_3.checked)
                                {
                                    list_checked.push("1");
                                }
                                else
                                {
                                    list_checked.push("0");
                                }
                                if(k4_4.checked)
                                {
                                    list_checked.push("1");
                                }
                                else
                                {
                                    list_checked.push("0");
                                }
                                if(k4_5.checked)
                                {
                                    list_checked.push("1");
                                }
                                else
                                {
                                    list_checked.push("0");
                                }
                                if(k4_6.checked)
                                {
                                    list_checked.push("1");
                                }
                                else
                                {
                                    list_checked.push("0");
                                }
                                if(k4_7.checked)
                                {
                                    list_checked.push("1");
                                }
                                else
                                {
                                    list_checked.push("0");
                                }
                                if(k4_8.checked)
                                {
                                    list_checked.push("1");
                                }
                                else
                                {
                                    list_checked.push("0");
                                }
                                if(k4_9.checked)
                                {
                                    list_checked.push("1");
                                }
                                else
                                {
                                    list_checked.push("0");
                                }
                                if(k4_10.checked)
                                {
                                    list_checked.push("1");
                                }
                                else
                                {
                                    list_checked.push("0");
                                }

                                w.list_k4_QML = list_checked;

                                //console.log(w.list_k4_QML);

                                w.rele_portON(list_checked,4);

                            }
                        }

                        Switch {
                            id: k4_6
                            text: qsTr("Порт 6")
                            enabled: false
                            font.pointSize: 12
                            Layout.preferredHeight: 30
                            font.family: "Times New Roman"
                            Layout.preferredWidth: 130
                            onClicked:
                            {
                                var list_checked = [] ;

                                if(k4_1.checked)
                                {
                                    list_checked.push("1");
                                }
                                else
                                {
                                    list_checked.push("0");
                                }
                                if(k4_2.checked)
                                {
                                    list_checked.push("1");
                                }
                                else
                                {
                                    list_checked.push("0");
                                }
                                if(k4_3.checked)
                                {
                                    list_checked.push("1");
                                }
                                else
                                {
                                    list_checked.push("0");
                                }
                                if(k4_4.checked)
                                {
                                    list_checked.push("1");
                                }
                                else
                                {
                                    list_checked.push("0");
                                }
                                if(k4_5.checked)
                                {
                                    list_checked.push("1");
                                }
                                else
                                {
                                    list_checked.push("0");
                                }
                                if(k4_6.checked)
                                {
                                    list_checked.push("1");
                                }
                                else
                                {
                                    list_checked.push("0");
                                }
                                if(k4_7.checked)
                                {
                                    list_checked.push("1");
                                }
                                else
                                {
                                    list_checked.push("0");
                                }
                                if(k4_8.checked)
                                {
                                    list_checked.push("1");
                                }
                                else
                                {
                                    list_checked.push("0");
                                }
                                if(k4_9.checked)
                                {
                                    list_checked.push("1");
                                }
                                else
                                {
                                    list_checked.push("0");
                                }
                                if(k4_10.checked)
                                {
                                    list_checked.push("1");
                                }
                                else
                                {
                                    list_checked.push("0");
                                }

                                w.list_k4_QML = list_checked;

                                //console.log(w.list_k4_QML);

                                w.rele_portON(list_checked,4);

                            }
                        }

                        Switch {
                            id: k4_7
                            text: qsTr("Порт 7")
                            enabled: false
                            font.pointSize: 12
                            Layout.preferredHeight: 30
                            font.family: "Times New Roman"
                            Layout.preferredWidth: 130
                            onClicked:
                            {
                                var list_checked = [] ;

                                if(k4_1.checked)
                                {
                                    list_checked.push("1");
                                }
                                else
                                {
                                    list_checked.push("0");
                                }
                                if(k4_2.checked)
                                {
                                    list_checked.push("1");
                                }
                                else
                                {
                                    list_checked.push("0");
                                }
                                if(k4_3.checked)
                                {
                                    list_checked.push("1");
                                }
                                else
                                {
                                    list_checked.push("0");
                                }
                                if(k4_4.checked)
                                {
                                    list_checked.push("1");
                                }
                                else
                                {
                                    list_checked.push("0");
                                }
                                if(k4_5.checked)
                                {
                                    list_checked.push("1");
                                }
                                else
                                {
                                    list_checked.push("0");
                                }
                                if(k4_6.checked)
                                {
                                    list_checked.push("1");
                                }
                                else
                                {
                                    list_checked.push("0");
                                }
                                if(k4_7.checked)
                                {
                                    list_checked.push("1");
                                }
                                else
                                {
                                    list_checked.push("0");
                                }
                                if(k4_8.checked)
                                {
                                    list_checked.push("1");
                                }
                                else
                                {
                                    list_checked.push("0");
                                }
                                if(k4_9.checked)
                                {
                                    list_checked.push("1");
                                }
                                else
                                {
                                    list_checked.push("0");
                                }
                                if(k4_10.checked)
                                {
                                    list_checked.push("1");
                                }
                                else
                                {
                                    list_checked.push("0");
                                }

                                w.list_k4_QML = list_checked;

                                //console.log(w.list_k4_QML);

                                w.rele_portON(list_checked,4);

                            }
                        }

                        Switch {
                            id: k4_8
                            text: qsTr("Порт 8")
                            enabled: false
                            font.pointSize: 12
                            Layout.preferredHeight: 30
                            font.family: "Times New Roman"
                            Layout.preferredWidth: 130
                            onClicked:
                            {
                                var list_checked = [] ;

                                if(k4_1.checked)
                                {
                                    list_checked.push("1");
                                }
                                else
                                {
                                    list_checked.push("0");
                                }
                                if(k4_2.checked)
                                {
                                    list_checked.push("1");
                                }
                                else
                                {
                                    list_checked.push("0");
                                }
                                if(k4_3.checked)
                                {
                                    list_checked.push("1");
                                }
                                else
                                {
                                    list_checked.push("0");
                                }
                                if(k4_4.checked)
                                {
                                    list_checked.push("1");
                                }
                                else
                                {
                                    list_checked.push("0");
                                }
                                if(k4_5.checked)
                                {
                                    list_checked.push("1");
                                }
                                else
                                {
                                    list_checked.push("0");
                                }
                                if(k4_6.checked)
                                {
                                    list_checked.push("1");
                                }
                                else
                                {
                                    list_checked.push("0");
                                }
                                if(k4_7.checked)
                                {
                                    list_checked.push("1");
                                }
                                else
                                {
                                    list_checked.push("0");
                                }
                                if(k4_8.checked)
                                {
                                    list_checked.push("1");
                                }
                                else
                                {
                                    list_checked.push("0");
                                }
                                if(k4_9.checked)
                                {
                                    list_checked.push("1");
                                }
                                else
                                {
                                    list_checked.push("0");
                                }
                                if(k4_10.checked)
                                {
                                    list_checked.push("1");
                                }
                                else
                                {
                                    list_checked.push("0");
                                }

                                w.list_k4_QML = list_checked;

                                //console.log(w.list_k4_QML);

                                w.rele_portON(list_checked,4);

                            }
                        }

                        Switch {
                            id: k4_9
                            text: qsTr("Порт 9")
                            enabled: false
                            font.pointSize: 12
                            Layout.preferredHeight: 30
                            font.family: "Times New Roman"
                            Layout.preferredWidth: 130
                            onClicked:
                            {
                                var list_checked = [] ;

                                if(k4_1.checked)
                                {
                                    list_checked.push("1");
                                }
                                else
                                {
                                    list_checked.push("0");
                                }
                                if(k4_2.checked)
                                {
                                    list_checked.push("1");
                                }
                                else
                                {
                                    list_checked.push("0");
                                }
                                if(k4_3.checked)
                                {
                                    list_checked.push("1");
                                }
                                else
                                {
                                    list_checked.push("0");
                                }
                                if(k4_4.checked)
                                {
                                    list_checked.push("1");
                                }
                                else
                                {
                                    list_checked.push("0");
                                }
                                if(k4_5.checked)
                                {
                                    list_checked.push("1");
                                }
                                else
                                {
                                    list_checked.push("0");
                                }
                                if(k4_6.checked)
                                {
                                    list_checked.push("1");
                                }
                                else
                                {
                                    list_checked.push("0");
                                }
                                if(k4_7.checked)
                                {
                                    list_checked.push("1");
                                }
                                else
                                {
                                    list_checked.push("0");
                                }
                                if(k4_8.checked)
                                {
                                    list_checked.push("1");
                                }
                                else
                                {
                                    list_checked.push("0");
                                }
                                if(k4_9.checked)
                                {
                                    list_checked.push("1");
                                }
                                else
                                {
                                    list_checked.push("0");
                                }
                                if(k4_10.checked)
                                {
                                    list_checked.push("1");
                                }
                                else
                                {
                                    list_checked.push("0");
                                }

                                w.list_k4_QML = list_checked;

                                //console.log(w.list_k4_QML);

                                w.rele_portON(list_checked,4);

                            }
                        }

                        Switch {
                            id: k4_10
                            text: qsTr("Порт 10")
                            enabled: false
                            font.pointSize: 12
                            Layout.preferredHeight: 30
                            font.family: "Times New Roman"
                            Layout.preferredWidth: 130
                            onClicked:
                            {
                                var list_checked = [] ;

                                if(k4_1.checked)
                                {
                                    list_checked.push("1");
                                }
                                else
                                {
                                    list_checked.push("0");
                                }
                                if(k4_2.checked)
                                {
                                    list_checked.push("1");
                                }
                                else
                                {
                                    list_checked.push("0");
                                }
                                if(k4_3.checked)
                                {
                                    list_checked.push("1");
                                }
                                else
                                {
                                    list_checked.push("0");
                                }
                                if(k4_4.checked)
                                {
                                    list_checked.push("1");
                                }
                                else
                                {
                                    list_checked.push("0");
                                }
                                if(k4_5.checked)
                                {
                                    list_checked.push("1");
                                }
                                else
                                {
                                    list_checked.push("0");
                                }
                                if(k4_6.checked)
                                {
                                    list_checked.push("1");
                                }
                                else
                                {
                                    list_checked.push("0");
                                }
                                if(k4_7.checked)
                                {
                                    list_checked.push("1");
                                }
                                else
                                {
                                    list_checked.push("0");
                                }
                                if(k4_8.checked)
                                {
                                    list_checked.push("1");
                                }
                                else
                                {
                                    list_checked.push("0");
                                }
                                if(k4_9.checked)
                                {
                                    list_checked.push("1");
                                }
                                else
                                {
                                    list_checked.push("0");
                                }
                                if(k4_10.checked)
                                {
                                    list_checked.push("1");
                                }
                                else
                                {
                                    list_checked.push("0");
                                }

                                w.list_k4_QML = list_checked;

                                //console.log(w.list_k4_QML);

                                w.rele_portON(list_checked,4);

                            }
                        }
                    }
                    rows: 2
                    columns: 4
                }
                columns: 2
            }

            GridLayout {
                id: set_ip_layout
                x: 0
                width: 800
                columnSpacing: 0
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.top: parent.top
                anchors.topMargin: 0
                rowSpacing: 0
                rows: 1
                columns: 3

                TextField {
                    id: vvedite_IP
                    x: 0
                    text: qsTr("Введите новый IP-адрес пульта, если требуется:")
                    Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                    leftPadding: 6
                    font.pointSize: 12
                    horizontalAlignment: Text.AlignHCenter
                    font.bold: true
                    Layout.preferredWidth: 400
                    font.family: "Times New Roman"
                    readOnly: true
                    Layout.preferredHeight: 40
                }

                TextField {
                    id: ip_to_set
                    x: 440
                    Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                    leftPadding: 6
                    font.pointSize: 12
                    horizontalAlignment: Text.AlignHCenter
                    font.bold: true
                    Layout.preferredWidth: 200
                    font.family: "Times New Roman"
                    readOnly: false
                    Layout.preferredHeight: 40
                }

                Button {
                    id: setIP
                    x: 680
                    text: qsTr("Установить")
                    font.pointSize: 12
                    Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                    Layout.preferredWidth: 120
                    font.family: "Times New Roman"
                    Layout.maximumWidth: 65535

                    onClicked:
                    {
                        w.setIP(ip_to_set.text);
                    }
                    Connections
                    {
                        target: w

                        onSignal_obratnogo_perekl:
                        {                          
                            Global.flag__rezresh_perekl_swipeview = 1;
                            Global.flag__tekushii_swipeview=0;

                            swipeView.setCurrentIndex(flajok);
                        }

                    }
                }
            }




        }

    }




    footer: TabBar {
        id: tabBar
        currentIndex: swipeView.currentIndex
        TabButton {
            text: qsTr("Выбор пульта")
            font.family: "Times New Roman"
            font.pointSize: 12
        }
        TabButton {
            text: qsTr("Работа с пультом")
            font.family: "Times New Roman"
            font.pointSize: 12
        }

    }

}

