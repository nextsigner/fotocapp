import QtQuick 2.0
import QtMultimedia 5.0

XArea {
    id: r
    width: xApp.width
    height: xApp.height-xMenu.height
    property int h: 0
    property int m: 0
    property int s: 0
    property int dia: 0
    property int mes: 0
    property int anio: 0
    property string uUrlTempCap: ''
    Camera {
        id: camera
        imageProcessing.whiteBalanceMode: CameraImageProcessing.WhiteBalanceFlash

        exposure {
            exposureCompensation: -1.0
            exposureMode: Camera.ExposurePortrait
        }

        flash.mode: Camera.FlashRedEyeReduction

        imageCapture {
            onImageCaptured: {
                photoPreview.source = preview  // Show the preview in an Image
                photoPreview.visible=true
            }
        }
        onErrorStringChanged: {
            console.log('Error! '+errorString)
        }
    }

    Column{
        spacing: app.fs
        anchors.horizontalCenter: parent.horizontalCenter
        VideoOutput {
            source: camera
            width: r.width-app.fs
            //height: sourceRect.height
            anchors.horizontalCenter: parent.horizontalCenter
            focus : visible // to receive focus and capture key events when visible
            visible: !photoPreview.visible
        }
        Image {
            id: photoPreview
            width: r.width
            fillMode: Image.PreserveAspectFit
            visible: false
            onStatusChanged: {
                if(status===Image.Ready){
                    photoPreview.grabToImage(function(result) {
                        let tempFileName=unik.getPath(2)+'/foto.jpg'
                        console.log('Image Captured: '+tempFileName)
                        result.saveToFile(tempFileName);
                        r.uUrlTempCap=tempFileName
                        btnCancelarCap.visible=true
                        btnEnviarCap.visible=true
                    });
                }
            }
            MouseArea{
                anchors.fill: parent
                onDoubleClicked: photoPreview.visible=false
            }
            Rectangle{
                anchors.fill: parent
                border.width: 4
                border.color: 'red'
                color: 'transparent'
            }

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
                onClicked: {
                    photoPreview.visible=false
                }
            }
            Boton{
                id: btnEnviarCap
                text: 'Enviar'
                onClicked: {
                    sendCap()
                    xLoading.visible=true
                }
            }
        }

        Boton{
            id: btnNuevaCaptura
            text: 'Nueva Captura'
            anchors.bottom: r.bottom
            anchors.bottomMargin: app.fs
            anchors.horizontalCenter: r.horizontalCenter
            visible: photoPreview.visible&&!btnCancelarCap.visible&&!btnEnviarCap.visible
            onClicked: {
                photoPreview.visible=false
            }
        }
    }
    Boton{
        text: 'Capturar'
        anchors.bottom: r.bottom
        anchors.bottomMargin: app.fs
        anchors.horizontalCenter: r.horizontalCenter
        visible: !photoPreview.visible
        fontSize: app.fs*2
        onClicked: {
            camera.imageCapture.capture();
        }
    }



    function sendCap(){
        if(apps.cAdmin==='null'){
            //return
        }
        let administrador='qt'
        let fotografo='qt1'
        let fotode='tq1'
        xLoading.visible=true
        let d = new Date(Date.now())
        let url=app.serverUrl+':'+app.portRequest+'/fotocapp/nuevacaptura?r='+d.getTime()//+consulta
        console.log('Post '+app.moduleName+' server from '+url)
        var jsonCtx='{"ctx":{"administrador":"'+administrador+'", "fotografo":"'+fotografo+'", "telefono":"'+apps.cFotografoTel+'", "email":"'+apps.cFotografoEMail+'", "fotode":"'+fotode+'"}}'
        var params = 'ctx='+jsonCtx+'&imagen='+unik.imageCameraCapturaToByteArray(r.uUrlTempCap)
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
                    }
                    btnEnviarCap.enabled=true
                }else{
                    console.log("Error el cargar el servidor de Ppres. Code 1\n");
                    btnEnviarCap.enabled=true
                    let msg='Error al enviar la captura. El servidor no está respondiendo correctamente a este requerimiento.'
                    labelStatus.text=msg
                    let comp=Qt.createComponent("XMsgBox.qml")
                    let obj=comp.createObject(r, {text:msg})
                }
                xLoading.visible=false
            }
        };
        req.send(params);
    }
}
