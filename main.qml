import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Window 2.12
import Qt.labs.settings 1.1
import "funcs.js" as JS

ApplicationWindow {
    id: app
    visibility: "Windowed"
    width: !mobile?300:Screen.width
    height: !mobile?600:Screen.height
    visible: true
    title: moduleName
    property string moduleName: 'fotocapp'
    property bool mobile: Qt.platform.os==='android'
    property int fs: width*0.03
    property color c1: 'white'
    property color c2: 'black'
    property color c3: '#ccc'
    property color c4: 'red'

    property string serverUrl: 'http://localhost'
    property int portRequest: 8080
    property int portFiles: 8081

    property int mod: 0
    property int widthMarcador: 2

    onModChanged: {
        if(mod===0){
            xXMenu.cBtn=bot1
        }
        if(mod===1){
            xXMenu.cBtn=bot2
        }
        if(mod===2){
            xXMenu.cBtn=bot3
        }
        if(mod===3){
            xXMenu.cBtn=bot4
        }
        marcador.x=xXMenu.cBtn.x+xXMenu.cBtn.width/2-marcador.width/2
    }

    Settings{
        id: apps
        fileName: moduleName+'.cfg'
        property bool localHost: false
        property string cAdmin: ''
        property string cFotografoNom: ''
        property string cFotografoEMail: ''
        property string cFotografoTel: ''
        property int cameraIndex: 0
        property int cameraRotation: 0
        onLocalHostChanged: {
            if(!localHost){
                JS.getServerUrl()
            }else{
                serverUrl='http://localhost'
                portRequest=8080
                portFiles=8081
            }
        }
    }

    ManSqliteData{id: manSqlData}
    Item{
        id: xApp
        anchors.fill: parent
        Flickable{
            id: flick
            anchors.fill: parent
            contentWidth: parent.width
            contentHeight: col1.height//+app.fs*4
            Column{
                id: col1
                width: xApp.width
                anchors.horizontalCenter: parent.horizontalCenter
                Item{
                    id: xXMenu
                    width: xMenu.width
                    height: xMenu.height
                    property var cBtn:bot1
                    anchors.horizontalCenter: parent.horizontalCenter
                    Rectangle{
                        id: marcador
                        width: app.widthMarcador
                        height: xApp.height
                        x:bot1.x+bot1.width/2-width/2
                        color: 'black'
                        Behavior on x{
                            NumberAnimation{duration: 500; easing.type: Easing.InOutQuad}
                        }
                    }
                    Row{
                        id: xMenu
                        spacing: app.fs
                        anchors.horizontalCenter: parent.horizontalCenter
                        Boton{
                            id: bot1;
                            text: 'Capturar'
                            fontSize: app.fs*1.5
                            horizontalMargin: app.fs*0.1
                            onClicked: app.mod=0
                            opacity: app.mod===0?1.0:0.65
                        }
                        Boton{
                            id: bot2;
                            text: 'Control'
                            fontSize: app.fs*1.5
                            horizontalMargin: app.fs*0.1
                            onClicked: app.mod=1
                            opacity: app.mod===1?1.0:0.65
                        }
                        Boton{
                            id: bot3;
                            text: 'Configurar'
                            fontSize: app.fs*1.5
                            horizontalMargin: app.fs*0.1
                            onClicked: app.mod=2
                            opacity: app.mod===2?1.0:0.65
                        }
                        Boton{
                            id: bot4;
                            text: '?'
                            fontSize: app.fs*1.5
                            horizontalMargin: app.fs*0.1
                            onClicked: app.mod=3
                            opacity: app.mod===3?1.0:0.65
                        }
                    }
                }
                XCamera{id: xCamera;visible: app.mod===0}
                XControl{id: xControl;visible: app.mod===1}
                XConfig{id: xConfig;visible: app.mod===2}
                XAbout{id: xAbout;visible: app.mod===3}

            }
        }
        XAddNom{
            id: xAddNom;
            visible: false
            onVisibleChanged: {
                if(!visible)xCamera.cbNoms.model=manSqlData.getNombres()
            }
        }
        XLoading{id: xLoading}
    }
    Text{
        text: 'LocalHost'
        font.pixelSize: app.fs
        color: 'red'
        visible: apps.localHost
    }
    Shortcut{
        sequence: 'Esc'
        onActivated: Qt.quit()
    }
    Component.onCompleted: {
        if(!apps.localHost){
            JS.getServerUrl()
        }
    }
}
