import QtQuick 2.0

XArea {
    id: r
    width: xApp.width
    height: xApp.height
    onVisibleChanged: {
        if(visible){
//            tiFotografo.text=apps.cFotografo
//            tiFotografoTel.text=apps.cFotografoTel
//            tiFotografoEMail.text=apps.cFotografoEMail
//            tiHost.text=apps.serverUrl
//            tiHost.focus=true
        }
    }
    Rectangle{
        anchors.fill: r
        color: 'red'
        border.color: 'blue'
        border.width: 4
        visible: false
    }
    Column{
        id: col
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: parent.top
        anchors.topMargin: app.fs
        spacing: app.fs
        Text {
            text: '<b>Agregar Nombre</b>'
            font.pixelSize: app.fs*2
            anchors.horizontalCenter: parent.horizontalCenter
        }
        Row{
            id: rowIp
            spacing: app.fs
            Text {
                id: labelHost
                text: 'Nombre:'
                anchors.verticalCenter: parent.verticalCenter
                font.pixelSize: app.fs*2
            }
            Rectangle{
                id: xTiNombre
                width: r.width-labelHost.contentWidth-app.fs*2
                height: app.fs*3
                border.width: 2
                clip: true
                anchors.verticalCenter: parent.verticalCenter
                TextInput{
                    id: tiNombre
                    width: parent.width-app.fs*0.5
                    height: parent.height-app.fs
                    font.pixelSize: app.fs*2
                    anchors.centerIn: parent
                    KeyNavigation.tab: btnAddNom
                    Keys.onReturnPressed: btnAddNom.focus=true
                    maximumLength: 30
                }
            }
        }
        Row{
            spacing: app.fs
            anchors.horizontalCenter: parent.horizontalCenter
            Boton{
                id: btnCancelAddNom
                text: focus?'<b>Cancelar</b>':'Cancelar'
                fontSize: app.fs*2
                KeyNavigation.tab: btnAddNom
                onClicked: {
                    r.visible=false
                }
            }
            Boton{
                id: btnAddNom
                text: focus?'<b>Agregar</b>':'Agregar'
                fontSize: app.fs*2
                KeyNavigation.tab: tiNombre
                onClicked: {
                    tiNombre.focus=false
                    let a = manSqlData.getNombres()
                    console.log('Nombres pre existentes: '+a.toString())
                    if(tiNombre.text!==''&&a.indexOf(tiNombre.text)<0){
                        manSqlData.setNombre(tiNombre.text)
                        r.visible=false
                    }else{
                        let msg='Este nombre ya existe.'
                        let comp=Qt.createComponent("XMsgBox.qml")
                        let obj=comp.createObject(r, {text:msg})
                    }
                }
            }
        }
    }
}


