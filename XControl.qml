import QtQuick 2.0
import "funcs.js" as JS

XArea {
    id: r
    width: xApp.width
    height: xApp.height-xMenu.height
    property int fontSize: app.fs*2
    onVisibleChanged: {
        if(visible){
            getAsistencias(apps.cAdmin)
        }
    }
    //    MouseArea{
    //        anchors.fill: r
    //        onDoubleClicked: {
    //            getAsistencias('qt')
    //        }
    //    }
    Column{
        id: col
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: parent.top
        anchors.topMargin: app.fs
        spacing: app.fs
        Column{
            id: colHeaderControl
            anchors.horizontalCenter: parent.horizontalCenter
            Text {
                text: '<b>Control</b>'
                font.pixelSize: app.fs*2
                anchors.horizontalCenter: parent.horizontalCenter
            }
        }
        ListView{
            id: lv
            width: r.width-app.fs
            height: r.height-colHeaderControl.height-app.fs*10
            //contentHeight: height*2
            clip: true
            //spacing: app.fs
            anchors.horizontalCenter: parent.horizontalCenter
            currentIndex: -1
            model: lm
            delegate: compAsistencias
            onCurrentIndexChanged: {
                //getImagen(lm.get(currentIndex).vid)
            }
        }
    }
    Component{
        id: compAsistencias
        Rectangle{
            id: xCompAsistencia
            width: lv.width
            height: index===lv.currentIndex?colItemCap.height+app.fs:labelAsistencia.contentHeight+app.fs*2
            border.width: 2
            border.color: lv.currentIndex===index?'red':'black'
            color: lv.currentIndex===index?'black':'white'
            clip: true
            property int rowMod1Height: labelAsistencia.contentHeight+app.fs*2
            property string momento: '?'
            property string imageData: vImageData
            property int uHeight: rowMod1Height
            onHeightChanged:{
                if(uHeight>height){
                    lv.contentY=xCompAsistencia.y
                }
                rowMod1Height=height
            }
            Behavior on height{
                NumberAnimation{duration: 250}
            }
            MouseArea{
                anchors.fill: parent
                onClicked: {
                    if(lv.currentIndex===index){
                        lv.currentIndex=-1
                        return
                    }
                    lv.currentIndex=index
                    if(cap.vId===''){
                        getImagen(vId, cap)
                    }
                }
            }
            Column{
                id: colItemCap
                spacing: app.fs
                width: parent.width
                anchors.top: parent.top
                anchors.topMargin: app.fs//parent.height-labelAsistencia.height/2
                //anchors.centerIn: parent
                Text{
                    id: labelAsistencia
                    font.pixelSize: app.fs*1.5
                    text:  ' '+vFotoDe+' '+momento
                    color: lv.currentIndex===index?'white':'black'
                    width: parent.width-app.fs*2
                    wrapMode: Text.WordWrap
                    anchors.horizontalCenter: parent.horizontalCenter
                }
                Image {
                    id: cap
                    width: xCompAsistencia.width
                    anchors.horizontalCenter: parent.horizontalCenter
                    fillMode: Image.PreserveAspectFit
                    property string vId: ''
                    /*onStatusChanged: {
                        if(status===Image.Ready&&vId!==''){

                        }
                    }*/
                    MouseArea{
                        id: maCap
                        anchors.fill: parent
                        enabled: parent.height>app.fs*3
                        onClicked: {
                            showCap(cap.vId, cap.source)
                        }
                    }
                    Component.onCompleted: {
                        //let ddd=''
                        //cap.source="data:image/png;base64,"+ddd.replace(/ /g,'+');
                    }
                }
            }
            Component.onCompleted: {
                let d=new Date(vFechaRegistro)
                momento=''+d.toString()
            }
        }
    }
    ListModel{
        id: lm
        function addItem(_id, administrador, fotografo, fotode, fechaRegistro){
            return{
                vId: _id,
                vAdministrador: administrador,
                vFotografo: fotografo,
                vFotoDe: fotode,
                vFechaRegistro: fechaRegistro,
                vImageData: ''
            }
        }
    }

    Boton{
        id: btnActualizar
        text: 'Actualizar'
        fontSize: app.fs*2
        anchors.bottom: parent.bottom
        anchors.bottomMargin: app.fs
        anchors.left: parent.left
        anchors.leftMargin: app.fs
        onClicked: {
            getAsistencias(apps.cAdmin)
        }
    }
    function getAsistencias(consulta){
        xLoading.visible=true
        let url=app.serverUrl+':'+app.portRequest+'/fotocapp/getAsistencias?consulta='+consulta
        console.log('Get '+app.moduleName+' server from '+url)
        var req = new XMLHttpRequest();
        req.open('GET', url, true);
        req.onreadystatechange = function (aEvt) {
            if (req.readyState === 4) {
                if(req.status === 200){
                    //let json=JSON.parse(req.responseText)
                    //console.log('Asistencias: '+req.responseText)
                    setAsistenciasResult(req.responseText)
                }else{
                    //console.log("Error el cargar el servidor de FotoCapp. Code 1\n");
                    let msg='Error al consultar datos.\n\nEl servidor no está respondiendo correctamente a este requerimiento.\n\nServidor no disponible: '+app.serverUrl+' puerto 1='+app.portRequest+' puerto 2='+app.portFiles
                    JS.showMsgBox(msg)
                }
                xLoading.visible=false
            }
        };
        req.send(null);
    }
    function setAsistenciasResult(datos){
        lm.clear()
        let json=JSON.parse(datos)
        for(var i=0;i<Object.keys(json.asistencias).length;i++){
            lm.append(lm.addItem(json.asistencias[i]._id, json.asistencias[i].administrador, json.asistencias[i].fotografo, json.asistencias[i].fotode, json.asistencias[i].fechaRegistro))
        }
    }
    function getImagen(id, cap){
        xLoading.visible=true
        let url=app.serverUrl+':'+app.portRequest+'/fotocapp/getImagen?id='+id
        console.log('Get '+app.moduleName+' server from '+url)
        var req = new XMLHttpRequest();
        req.open('GET', url, true);
        req.onreadystatechange = function (aEvt) {
            if (req.readyState === 4) {
                if(req.status === 200){
                    let json=JSON.parse(req.responseText)
                    //console.log(json.asistencias.imagen);
                    //var imageData=''+json.asistencias.imagen
                    //cap.source="data:image/png;base64,"+imageData.replace(/ /g,'+');
                    loadCap(cap, json.asistencias._id, json.asistencias.imagen)
                }else{
                    let msg='Error el cargar imagen desde el servidor de FotoCapp. Code 1'
                    JS.showMsgBox(msg)
                }
                xLoading.visible=false
            }
        };
        req.send(null);
    }
    function loadCap(cap, id, data){
        cap.vId=id
        cap.source="data:image/png;base64,"+data.replace(/ /g,'+');
        //Qt.quit()
    }
    function showCap(id, data){
        let comp = Qt.createComponent("XCapView.qml")
        let obj = comp.createObject(r, {capId: id, imageData: data})
    }
}


