import QtQuick 2.0

Rectangle {
    id: r
//    border.width: 2
//    border.color: 'blue'
    color: 'transparent'
    //anchors.fill: parent
    property string momento: '01/01/2020 00:00:00'
    property string administrador: 'administrador'
    property string fotografo: 'fotograro'
    property string fotode: 'fotode'
    signal dataUpdated
    Rectangle{
        width: txtMomento.contentWidth+app.fs
        height: txtMomento.contentHeight+app.fs
        border.width: 2
        border.color: 'red'
        color: 'transparent'
        anchors.top: r.top
        anchors.topMargin: app.fs
        anchors.left: r.left
        anchors.leftMargin: app.fs
        Rectangle{
            anchors.fill: parent
            color: 'black'
            opacity: 0.3
        }
        Text{
            id: txtMomento
            text: '<b>'+r.momento
            font.pixelSize: r.width*0.03
            color: 'white'
            anchors.centerIn: parent
        }
    }
    Rectangle{
        width: txtAdministrador.contentWidth+app.fs
        height: txtAdministrador.contentHeight+app.fs
        border.width: 2
        border.color: 'red'
        color: 'transparent'
        anchors.top: r.top
        anchors.topMargin: app.fs
        anchors.right: r.right
        anchors.rightMargin: app.fs
        Rectangle{
            anchors.fill: parent
            color: 'black'
            opacity: 0.3
        }
        Text{
            id: txtAdministrador
            text: '<b>'+apps.cAdmin
            font.pixelSize: r.width*0.03
            color: 'white'
            anchors.centerIn: parent
        }
    }
    Rectangle{
        width: txtFotografo.contentWidth+app.fs
        height: txtFotografo.contentHeight+app.fs
        border.width: 2
        border.color: 'red'
        color: 'transparent'
        anchors.bottom:  r.bottom
        anchors.bottomMargin: app.fs
        anchors.left: r.left
        anchors.leftMargin: app.fs
        Rectangle{
            anchors.fill: parent
            color: 'black'
            opacity: 0.3
        }
        Text{
            id: txtFotografo
            text: '<b>'+r.fotografo
            font.pixelSize: r.width*0.03
            color: 'white'
            anchors.centerIn: parent
        }
    }
    Rectangle{
        width: txtFotoDe.contentWidth+app.fs
        height: txtFotoDe.contentHeight+app.fs
        border.width: 2
        border.color: 'red'
        color: 'transparent'
        anchors.bottom:  r.bottom
        anchors.bottomMargin: app.fs
        anchors.right: r.right
        anchors.rightMargin: app.fs
        Rectangle{
            anchors.fill: parent
            color: 'black'
            opacity: 0.3
        }
        Text{
            id: txtFotoDe
            text: '<b>'+r.fotode
            font.pixelSize: r.width*0.03
            color: 'white'
            anchors.centerIn: parent
        }
    }
    function updateData(){
        let d=new Date(Date.now())
        let dia=''+d.getDate()
        let mes=''+parseInt(d.getMonth()+1)
        let anio=''+d.getFullYear()
        let hora=d.getHours()
        let min=d.getMinutes()>9?''+d.getMinutes():'0'+d.getMinutes()
        let seg=d.getSeconds()>9?''+d.getSeconds():'0'+d.getSeconds()
        r.momento=''+dia+'/'+mes+'/'+anio+' '+hora+':'+min+':'+seg
        r.dataUpdated()
    }
}
