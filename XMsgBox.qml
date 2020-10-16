import QtQuick 2.0

Rectangle {
    id: r
    width: app.width-r.fontSize*2
    height: textMsg.contentHeight+r.fontSize*8
    border.width: 2
    radius: app.fs*0.5
    anchors.horizontalCenter: parent.horizontalCenter
    anchors.top: parent.top
    anchors.topMargin: app.fs
    property  alias text: textMsg.text
    property  alias tit: textTit.text
    property int fontSize: app.fs*2
    Column{
       anchors.centerIn: r
       spacing: app.fs
       Text{
           id: textTit
           text: '<b>Información</b>'
           font.pixelSize: r.fontSize
           width: r.width-app.fs*2
           wrapMode: Text.WordWrap
       }
       Text{
            id: textMsg
            font.pixelSize: r.fontSize
            width: r.width-app.fs*2
            wrapMode: Text.WordWrap
        }
        Boton{
            text: 'Aceptar'
            fontSize: r.fontSize
            anchors.right: parent.right
            onClicked: {
                r.destroy(1)
            }
        }
    }
}
