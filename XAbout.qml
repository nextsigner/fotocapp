import QtQuick 2.0

XArea {
    id: r
    width: xApp.width
    height: xApp.height
    Rectangle{
        anchors.fill: r
        color: 'red'
        border.color: 'blue'
        border.width: 4
        visible: false
    }
    Column{
        id: col
        anchors.centerIn: r
        spacing: app.fs
        Text {
            text: '<b>FotoCapp</b>'
            font.pixelSize: app.fs*2
            anchors.horizontalCenter: parent.horizontalCenter
        }
        Text {
            width: r.width-app.fs
            text: 'Aplicación para calcular el presupuesto de servicios y productos de Prosegur Argentina.'
            font.pixelSize: app.fs
            wrapMode: Text.WordWrap
            anchors.horizontalCenter: parent.horizontalCenter
            textFormat: Text.RichText
            horizontalAlignment: Text.AlignHCenter
        }
        Item {
            width: 2
            height: app.fs*2
        }
        Text {
            width: r.width-app.fs
            text: 'Esta aplicación fue creada por nextsigner@gmail.com en Agosto de 2020'
            font.pixelSize: app.fs*2
            wrapMode: Text.WordWrap
            anchors.horizontalCenter: parent.horizontalCenter
        }
        Text {
            width: r.width-app.fs
            text: 'Esta aplicación fue creada con Qt Open Source bajo las licencias LGPL y LGPL2. Para más información<br />dirigirse a <a href="https://www.qt.io/">https://www.qt.io/</a>'
            font.pixelSize: app.fs*2
            wrapMode: Text.WordWrap
            anchors.horizontalCenter: parent.horizontalCenter
            textFormat: Text.RichText
            onLinkActivated: Qt.openUrlExternally(link)
        }
    }
}
