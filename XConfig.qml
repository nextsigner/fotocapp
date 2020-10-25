import QtQuick 2.0

XArea {
    id: r
    width: xApp.width
    height: xApp.height
    property int fontSize: app.fs*2
    onVisibleChanged: {
        if(visible){
            tiAdministrador.text=apps.cAdmin
            tiFotografo.text=apps.cFotografo
            tiFotografoTel.text=apps.cFotografoTel
            tiFotografoEMail.text=apps.cFotografoEMail
            tiFotografo.focus=true
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
            text: '<b>Configurar</b>'
            font.pixelSize: app.fs*2
            anchors.horizontalCenter: parent.horizontalCenter
        }
        Text {
            text: '<b>Datos para enviar</b>'
            font.pixelSize: app.fs*2
        }
        Row{
            id: rowTec
            spacing: app.fs
            Text {
                id: labelAdmin
                text: 'Administrador: *'
                anchors.verticalCenter: parent.verticalCenter
                font.pixelSize: r.fontSize
            }
            Rectangle{
                id: xtiAdministrador
                width: r.width-labelAdmin.contentWidth-app.fs*2
                height: r.fontSize*2
                border.width: 2
                clip: true
                anchors.verticalCenter: parent.verticalCenter
                TextInput{
                    id: tiAdministrador
                    width: parent.width-app.fs*0.5
                    height: parent.height-app.fs
                    font.pixelSize: r.fontSize
                    anchors.centerIn: parent
                    KeyNavigation.tab: tiFotografo
                    Keys.onReturnPressed: tiFotografo.focus=true
                    //onTextChanged: xListProdSearch.clear()
                }
            }
        }
        Row{
            id: rowAdmin
            spacing: app.fs
            Text {
                id: labelTec
                text: 'Nombre: *'
                anchors.verticalCenter: parent.verticalCenter
                font.pixelSize: r.fontSize
            }
            Rectangle{
                id: xtiFotografo
                width: r.width-labelTec.contentWidth-app.fs*2
                height: r.fontSize*2
                border.width: 2
                clip: true
                anchors.verticalCenter: parent.verticalCenter
                TextInput{
                    id: tiFotografo
                    width: parent.width-app.fs*0.5
                    height: parent.height-app.fs
                    font.pixelSize: r.fontSize
                    anchors.centerIn: parent
                    KeyNavigation.tab: tiFotografoTel
                    Keys.onReturnPressed: tiFotografoTel.focus=true
                    //onTextChanged: xListProdSearch.clear()
                }
            }
        }
        Row{
            id: rowTecTel
            spacing: app.fs
            Text {
                id: labelTecTel
                text: 'Teléfono: *'
                anchors.verticalCenter: parent.verticalCenter
                font.pixelSize: r.fontSize
            }
            Rectangle{
                id: xtiFotografoTel
                width: r.width-labelTecTel.contentWidth-app.fs*2
                height: r.fontSize*2
                border.width: 2
                clip: true
                anchors.verticalCenter: parent.verticalCenter
                TextInput{
                    id: tiFotografoTel
                    width: parent.width-app.fs*0.5
                    height: parent.height-app.fs
                    font.pixelSize: r.fontSize
                    anchors.centerIn: parent
                    KeyNavigation.tab: tiFotografoEMail
                    Keys.onReturnPressed: tiFotografoEMail.focus=true
                    //onTextChanged: xListProdSearch.clear()
                }
            }
        }
        Row{
            id: rowTecEMail
            spacing: app.fs
            Text {
                id: labelTecEMail
                text: 'E-Mail: *'
                anchors.verticalCenter: parent.verticalCenter
                font.pixelSize: r.fontSize
            }
            Rectangle{
                id: xtiFotografoEMail
                width: r.width-labelTecEMail.contentWidth-app.fs*2
                height: r.fontSize*2
                border.width: 2
                clip: true
                anchors.verticalCenter: parent.verticalCenter
                TextInput{
                    id: tiFotografoEMail
                    width: parent.width-app.fs*0.5
                    height: parent.height-app.fs
                    font.pixelSize: r.fontSize
                    anchors.centerIn: parent
                    validator: RegExpValidator{regExp: /^(([^<>()\[\]\\.,;:\s@"]+(\.[^<>()\[\]\\.,;:\s@"]+)*)|(".+"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$/}
                    KeyNavigation.tab: btnSetConfigData
                    Keys.onReturnPressed: btnSetConfigData.focus=true
                    //onTextChanged: xListProdSearch.clear()
                }
            }
        }
        Text {
            id: labelStatusTecConfig
            width: r.width-app.fs*2
            wrapMode: Text.WordWrap
            //anchors.verticalCenter: parent.verticalCenter
            font.pixelSize: r.fontSize
        }
        Row{
            spacing: app.fs
            anchors.horizontalCenter: parent.horizontalCenter
            Boton{
                id: btnCancelConfigData
                text: focus?'<b>Cancelar</b>':'Cancelar'
                fontSize: r.fontSize
                KeyNavigation.tab: tiFotografo
                onClicked: {
                    app.mod=0
                }
            }
            Boton{
                id: btnSetConfigData
                text: focus?'<b>Listo</b>':'Listo'
                fontSize: r.fontSize
                KeyNavigation.tab: tiFotografo
                onClicked: {
                    tiAdministrador.focus=false
                    tiFotografo.focus=false
                    tiFotografoTel.focus=false
                    tiFotografoEMail.focus=false
                    if(tiAdministrador.text==='localhost'){
                        apps.localHost=!apps.localHost
                        let msg='Se ha cambiado a localHost '+apps.localHost+'\nserver'+app.serverUrl+'\nportRequest='+app.portRequest+'\nportFiles='+app.portFiles
                        let comp=Qt.createComponent("XMsgBox.qml")
                        let obj=comp.createObject(r, {text:msg})
                        return
                    }
                    if(tiFotografo.text!==''&&tiFotografoTel.text!==''&&tiFotografoEMail.text!==''){
                        apps.cAdmin=tiAdministrador.text
                        apps.cFotografoNom=tiFotografo.text
                        apps.cFotografoTel=tiFotografoTel.text
                        apps.cFotografoEMail=tiFotografoEMail.text
                        xAcceso.visible=true
                        app.mod=0
                    }else{
                        labelStatusTecConfig.text='Para utilizar esta aplicación hay que llenar todos los campos de este formulario.'
                    }
                }
            }
        }
    }

    XArea{
        id: xAcceso
        anchors.fill: r
        property string uClaveAcc: ''
        onVisibleChanged: {
            if(!visible){
                tiClaveAcc.focus=false
            }
        }
        MouseArea{
            anchors.fill: parent
        }
        Column{
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.top: parent.top
            anchors.topMargin: app.fs
            spacing: app.fs
            Text {
                text: '<b>Ingresar Clave</b>'
                font.pixelSize: r.fontSize
                anchors.horizontalCenter: parent.horizontalCenter
            }
            Text {
                text:  'Solicitar clave de acceso a nextsigner@gmail.com'
                font.pixelSize: r.fontSize
                width: r.width-app.fs*2
                wrapMode: Text.WordWrap
                anchors.horizontalCenter: parent.horizontalCenter
            }
            Row{
                id: rowAcc
                spacing: app.fs
                Text {
                    id: labelClaveAcc
                    text: 'Clave:'
                    font.pixelSize: r.fontSize
                    anchors.verticalCenter: parent.verticalCenter
                }
                Rectangle{
                    id: xTiClaveAcc
                    width: r.width-labelClaveAcc.contentWidth-app.fs*2
                    height: r.fontSize*2
                    border.width: 2
                    clip: true
                    anchors.verticalCenter: parent.verticalCenter
                    TextInput{
                        id: tiClaveAcc
                        width: parent.width-app.fs*0.5
                        height: parent.height-app.fs
                        font.pixelSize: r.fontSize
                        anchors.centerIn: parent
                        echoMode: TextInput.Password
                        Keys.onReturnPressed: xAcceso.acceder()
                        onTextChanged: labelStatusAcc.text=''
                    }
                }
            }
            Text {
                id: labelStatusAcc
                width: r.width-app.fs*2
                wrapMode: Text.WordWrap
                font.pixelSize: r.fontSize
                anchors.horizontalCenter: parent.horizontalCenter
            }
            Row{
                spacing: app.fs
                anchors.horizontalCenter: parent.horizontalCenter
                Boton{
                    id: btnCancelAcceso
                    text: focus?'<b>Cancelar</b>':'Cancelar'
                    fontSize: r.fontSize
                    KeyNavigation.tab: tiFotografo
                    onClicked: {
                        app.mod=0
                    }
                }
                Boton{
                    text: 'Acceder'
                    fontSize: r.fontSize
                    onClicked: {
                        xAcceso.acceder()
                    }
                }
            }
        }
        function acceder(){
            let d=new Date(Date.now())
            let v1=d.getDate()*2
            let v2=(d.getMonth()+1)*2
            let c=''+v1+v2
            if(tiClaveAcc.text.indexOf(c)>=0&&xAcceso.uClaveAcc!==tiClaveAcc.text){
                xAcceso.visible=false
                xAcceso.uClaveAcc=tiClaveAcc.text
                tiClaveAcc.text=''
            }else{
                labelStatusAcc.text='Clave de acceso incorrecta.'
            }
        }
    }
}


