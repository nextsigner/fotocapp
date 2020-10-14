function getServerUrl(){
    let url='https://raw.githubusercontent.com/nextsigner/nextsigner.github.io/master/fotocapp_server'
    console.log('Get '+app.moduleName+' server from '+url)
    var req = new XMLHttpRequest();
    req.open('GET', url, true);
    req.onreadystatechange = function (aEvt) {
        if (req.readyState === 4) {
            if(req.status === 200){
                let m0=req.responseText.split('|')
                if(m0.length>2){
                    app.serverUrl=m0[0]
                    app.portRequest=m0[1]
                    app.portFiles=m0[2]
                    console.log('FotoCapp Server='+app.serverUrl+' '+app.portRequest+' '+app.portFiles)
                }else{
                    console.log("Error el cargar el servidor de FotoCapp. Code 2\n");
                }
            }else{
                console.log("Error el cargar la url del servidor FotoCapp. Code 1\n");
            }
        }
    };
    req.send(null);
}
