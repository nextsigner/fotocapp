import QtQuick 2.0
import QtQuick.Controls 2.0
import QtMultimedia 5.12

XArea {
    id: r
    width: xApp.width
    height: xApp.height-xMenu.height
    clip: true
    property int h: 0
    property int m: 0
    property int s: 0
    property int dia: 0
    property int mes: 0
    property int anio: 0
    property string uUrlTempCap: ''
    property alias cbNoms: cbNombres
    Camera {
        id: camera
        imageProcessing.whiteBalanceMode: CameraImageProcessing.WhiteBalanceFlash
        deviceId:  QtMultimedia.availableCameras[apps.cameraIndex].deviceId
        //captureMode: Camera.CaptureViewfinder
        exposure {
            exposureCompensation: -1.0
            exposureMode: Camera.ExposurePortrait
        }

        flash.mode: Camera.FlashRedEyeReduction

        imageCapture {
            onImageCaptured: {
                photoPreview.source = preview  // Show the preview in an Image
                photoPreview.width=photoPreview.sourceSize.width
                photoPreview.visible=true
                xInfoCap.visible=true
                xInfoCap.updateData()
            }
        }
        onErrorStringChanged: {
            console.log('Error! '+errorString)
        }
    }

    Column{
        spacing: app.fs
        anchors.horizontalCenter: parent.horizontalCenter
        Rectangle{
            id:xVO
            width: apps.cameraRotation===90?180:r.width
            height: apps.cameraRotation===90?r.width:180
            border.width: 0
            border.color: 'blue'
            color: 'transparent'
            anchors.horizontalCenter: parent.horizontalCenter
            visible: !photoPreview.visible
            rotation: apps.cameraRotation
            clip: true
            MouseArea{
                anchors.fill: parent
                onClicked: rowBtnCamera.opacity=1.0
            }
            VideoOutput {
                id: videoOutPut
                anchors.top: parent.top
                source: camera
                width: r.width-app.fs
                height: parent.height
                //rotation: apps.cameraRotation
                focus : visible // to receive focus and capture key events when visible
            }
        }

        XInfoCap{
            id: xInfoCap
            width: r.width
            height: photoPreview.height
            onDataUpdated: {
                xInfoCap.grabToImage(function(result) {
                    let tempFileName=unik.getPath(2)+'/foto.jpg'
                    console.log('Image Captured: '+tempFileName)
                    result.saveToFile(tempFileName);
                    r.uUrlTempCap=tempFileName
                    btnCancelarCap.visible=true
                    btnEnviarCap.visible=true
                    photoPreview.width=r.width
                    videoOutPut.width=r.width-app.fs
                    xInfoCap.width=r.width
                    flash.opacity=0.0
                });
            }
            visible: false
            Image {
                id: photoPreview
                width: r.width
                fillMode: Image.PreserveAspectFit
                z:xInfoCap.z-1
                rotation: videoOutPut.rotation
                visible: false
                onStatusChanged: {
                    if(status===Image.Ready){
                        //xInfoCap.updateData()
                    }
                }
                MouseArea{
                    anchors.fill: parent
                    onDoubleClicked: {
                        photoPreview.visible=false
                        xInfoCap.visible=false
                    }
                }
            }
            //            Rectangle{
            //                anchors.fill: parent
            //                border.width: 4
            //                border.color: 'red'
            //                color: 'transparent'
            //            }
        }

        Text {
            id: labelStatus
            text: 'Mostrando Captura'
            opacity: text!==''?1.0:0.0
            font.pixelSize: app.fs
            width: r.width-app.fs*2
            anchors.horizontalCenter: parent.horizontalCenter
            wrapMode: Text.WordWrap
            visible: photoPreview.visible
        }
        Row{
            spacing: app.fs
            anchors.horizontalCenter: parent.horizontalCenter
            visible: photoPreview.visible
            //anchors.top: parent.bottom
            //anchors.topMargin: app.fs
            Boton{
                id: btnCancelarCap
                text: 'Cancelar'
                fontSize: app.fs*2
                onClicked: {
                    xInfoCap.visible=false
                    photoPreview.visible=false
                    xLoading.visible=false
                }
            }
            Boton{
                id: btnEnviarCap
                text: 'Enviar'
                fontSize: app.fs*2
                onClicked: {
                    sendCap()
                    xLoading.visible=true
                }
            }
        }
        Boton{
            id: btnNuevaCaptura
            text: 'Nueva Captura'
            fontSize: app.fs*2
            //anchors.bottom: r.bottom
            //anchors.bottomMargin: app.fs
            anchors.horizontalCenter: r.horizontalCenter
            visible: photoPreview.visible&&!btnCancelarCap.visible&&!btnEnviarCap.visible
            onClicked: {
                xInfoCap.visible=false
                photoPreview.visible=false
            }
        }
    }
    Column{
        spacing: app.fs
        visible: !photoPreview.visible
        anchors.bottom: r.bottom
        anchors.bottomMargin: app.fs*3
        anchors.horizontalCenter: parent.horizontalCenter
        ComboBox{
            id: cbNombres
            width: r.width-app.fs
            anchors.horizontalCenter: parent.horizontalCenter
            font.pixelSize: app.fs*2
            Timer{
                running: true
                repeat: true
                interval: 1000
                onTriggered: {
                    if(cbNombres.count===0){
                        cbNombres.model=manSqlData.getNombres()
                    }else{
                        stop()
                    }
                }
            }
        }
        Row{
            spacing: app.fs
            anchors.horizontalCenter: parent.horizontalCenter
            Boton{
                text: 'Agregar'
                visible: !photoPreview.visible
                fontSize: app.fs*2
                onClicked: {
                    xAddNom.visible=true
                }
            }
            Boton{
                text: 'Capturar'
                fontSize: app.fs*2
                opacity: cbNombres.currentIndex===0?0.0:1.0
                enabled: opacity===1.0
                onClicked: {
                    if(apps.cAdmin===''){
                        let msg='Para utilizar esta aplicación hay que anotar el nombre de la empresa que recibirá las capturas. \nPara hacer esto hay que ir al menú Configurar y poner los datos del fotografo.'
                        let comp=Qt.createComponent("XMsgBox.qml")
                        let obj=comp.createObject(r, {text:msg})
                        return
                    }
                    if(apps.cFotografoNom===''){
                        let msg='Para utilizar esta aplicación hay que anotar el nombre del fotógrafo. \nPara hacer esto hay que ir al menú Configurar y poner los datos del fotografo.'
                        let comp=Qt.createComponent("XMsgBox.qml")
                        let obj=comp.createObject(r, {text:msg})
                        return
                    }
                    if(cbNombres.currentIndex===0){
                        let msg='Para realizar una captura primero hay que elegir un nombre.'
                        let comp=Qt.createComponent("XMsgBox.qml")
                        let obj=comp.createObject(r, {text:msg})
                        return
                    }
                    xInfoCap.fotografo=apps.cFotografoNom
                    xInfoCap.fotode=cbNombres.currentText
                    flash.opacity=1.0
                }
            }
        }
    }
    Text{
        id: infoVO
        text: 'VO'
        font.pixelSize: app.fs*2
        color: 'yellow'
        width: r.width-app.fs
        wrapMode: Text.WordWrap
        visible: false
    }
    Row{
        id: rowBtnCamera
        opacity: 0.0
        spacing: app.fs
        anchors.horizontalCenter: r.horizontalCenter
        anchors.top: r.top
        anchors.topMargin: r.width*0.35
        Behavior on opacity{NumberAnimation{duration: 500}}
        Timer{
            id: tHideBtnsCamera
            running: rowBtnCamera.opacity===1.0
            repeat: false
            interval: 5000
            onTriggered: rowBtnCamera.opacity=0.0
        }
        Boton{
            id: btnCameraRotation
            text: 'Rotar Cámara'
            fontSize: app.fs*2
            enabled: rowBtnCamera.opacity===1.0
            anchors.horizontalCenter: r.horizontalCenter
            onClicked: {
                if(apps.cameraRotation===0){
                    apps.cameraRotation=90
                }else if(apps.cameraRotation===90){
                    apps.cameraRotation=180
                }else{
                    apps.cameraRotation=0
                }
                tHideBtnsCamera.restart()
            }
        }
        Boton{
            id: btnCameraSelect
            text: 'Cambiar Cámara'
            fontSize: app.fs*2
            opacity: QtMultimedia.availableCameras.length>1?1.0:0.5
            enabled: rowBtnCamera.opacity===1.0
            anchors.horizontalCenter: r.horizontalCenter
            onClicked: {
                if(QtMultimedia.availableCameras.length-1>apps.cameraIndex){
                    apps.cameraIndex++
                }else{
                    apps.cameraIndex=0
                }
                let msg='Se ha cambiado a la cámara '+parseInt(apps.cameraIndex + 1)+'\nEste dispositivo tiene en total '+QtMultimedia.availableCameras.length+' cámaras.'
                let comp=Qt.createComponent("XMsgBox.qml")
                let obj=comp.createObject(r, {text:msg})
                tHideBtnsCamera.restart()
            }
        }
    }
    Rectangle{
        id: flash
        anchors.fill: r
        opacity: 0.0
        Behavior on opacity{
            NumberAnimation{duration: 150}
        }
        onOpacityChanged: {
            if(opacity===1.0){
                videoOutPut.width=videoOutPut.sourceRect.width
                xInfoCap.width=videoOutPut.width
                camera.imageCapture.capture();
            }
        }
    }
    Timer{
        running: r.visible
        repeat: true
        interval: 500
        onTriggered: {
            let w1=videoOutPut.sourceRect.width
            let dw1=w1-r.width
            let h1=videoOutPut.sourceRect.height
            //Porcentaje de Reducción de Ancho
            let porcRW=parseFloat(100-dw1/w1*100)
            let nh1=h1/100*porcRW
            //infoVO.text='RW:'+r.width+' WC:'+w1+' DW:'+dw1+' P1:'+porcRW+' HC:'+h1+' NH:'+nh1
            if(apps.cameraRotation===90){
                xVO.width=nh1+app.fs*2
                xVO.height=r.width
            }else{
                xVO.width=r.width
                xVO.height=nh1+app.fs*2
            }

            //if(){}
        }
    }
    function sendCap(){
        if(apps.cAdmin==='null'){
            //return
        }
        let administrador=apps.cAdmin
        let fotografo=apps.cFotografoNom
        let fotode=cbNombres.currentText
        xLoading.visible=true
        let d = new Date(Date.now())
        let url=app.serverUrl+':'+app.portRequest+'/fotocapp/nuevacaptura?r='+d.getTime()//+consulta
        console.log('Post '+app.moduleName+' server from '+url)
        var jsonCtx='{"ctx":{"administrador":"'+administrador+'", "fotografo":"'+fotografo+'", "telefono":"'+apps.cFotografoTel+'", "email":"'+apps.cFotografoEMail+'", "fotode":"'+fotode+'"}}'
        var imageData=unik.imageCameraCapturaToByteArray(r.uUrlTempCap)
        //console.log('::::'+imageData)
        //cap.source="data:image/png;base64,"+imageData;
        var params = 'ctx='+jsonCtx+'&imagen='+imageData
        var req = new XMLHttpRequest();
        req.open('POST', url, true);
        req.setRequestHeader('Content-type', 'application/x-www-form-urlencoded')
        req.onreadystatechange = function (aEvt) {
            if (req.readyState === 4) {
                if(req.status === 200){
                    //console.log('Response Pres: '+req.responseText)
                    let json
                    try {
                        json=JSON.parse(req.responseText)
                        labelStatus.text='La captura se ha enviado correctamente.'
                        //photoPreview.visible=false
                        btnEnviarCap.visible=false
                        btnCancelarCap.visible=false
                    } catch(e) {
                        labelStatus.text='Error al enviar la captura. '+e
                        xLoading.visible=false
                    }
                    btnEnviarCap.enabled=true
                }else{
                    console.log("Error el cargar el servidor de FotoCapp. Code 1\n");
                    btnEnviarCap.enabled=true
                    let msg='Error al enviar la captura.\n\nEl servidor no está respondiendo correctamente a este requerimiento.\n\nServidor no disponible: '+app.serverUrl+' puerto 1='+app.portRequest+' puerto 2='+app.portFiles
                    labelStatus.text=msg
                    let comp=Qt.createComponent("XMsgBox.qml")
                    let obj=comp.createObject(r, {text:msg})
                    xLoading.visible=false
                }
                xLoading.visible=false
            }
        };
        req.send(params);
    }
}
