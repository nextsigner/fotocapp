import QtQuick 2.0

Rectangle {
    id: r
    width: xApp.width-r.fontSize*2
    height: textMsg.contentHeight+r.fontSize*8
    border.width: 2
    radius: app.fs*0.5
    anchors.horizontalCenter: parent.horizontalCenter
    anchors.top: parent.top
    anchors.topMargin: app.fs
    property  alias text: textMsg.text
    property  alias tit: textTit.text
    property int fontSize: app.fs*2
    /*Rectangle {
        id: bg
        width: app.width-r.fontSize*2
        height: textMsg.contentHeight+r.fontSize*8
        border.width: 2
        radius: app.fs*0.5
    }*/
    MouseArea{
        anchors.fill: parent
        onDoubleClicked: r.destroy(1)
    }
    Flickable{
        width: r.width-app.fs*2
        height: textTit.contentHeight+textMsg.contentHeight+botAceptar.height+colInfo.spacing*2
        contentWidth: r.width
        contentHeight: colInfo.height+app.fs*2
        boundsBehavior: Flickable.StopAtBounds
        anchors.centerIn: parent
        Column{
            id: colInfo
            anchors.centerIn: r
            spacing: app.fs
            Text{
                id: textTit
                text: '<b>Información</b>'
                font.pixelSize: r.fontSize
                width: r.width-app.fs*2
                wrapMode: Text.WordWrap
                anchors.horizontalCenter: parent.horizontalCenter
            }
            Text{
                id: textMsg
                font.pixelSize: r.fontSize
                width: r.width-app.fs*2
                wrapMode: Text.WordWrap
                anchors.horizontalCenter: parent.horizontalCenter
            }
            Boton{
                id: botAceptar
                text: 'Aceptar'
                fontSize: r.fontSize
                anchors.right: parent.right
                onClicked: {
                    r.destroy(1)
                }
            }
        }
    }
}
