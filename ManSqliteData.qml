import QtQuick 2.0

Item {
    id: r
    property string url: ''
    signal nombreNuevo(string nombre)

    //Nombres
    function setNombre(nombre){
        //unik.sqliteInit(r.url)
        let sql='insert into nombres (nombre)values(\''+nombre+'\')'
        unik.sqlQuery(sql)
    }

    function getNombres(){
        //unik.sqliteInit(r.url)
        let sql='select * from nombres'
        let rows=unik.getSqlData(sql)
        let a=['Seleccionar Nombre']
        for(var i=0;i<rows.length;i++){
            a.push(rows[i].col[1])
        }
        return a
    }

    Component.onCompleted: {
        let folder=unik.getPath(3)+'/'+app.moduleName
        if(!unik.folderExist(folder)){
            unik.mkdir(folder)
        }
        r.url=folder+'/data.sqlite'
        console.log('Sqlite database: '+r.url)
        unik.sqliteInit(r.url)
        let sql='CREATE TABLE IF NOT EXISTS nombres'
            +'('
            +'id INTEGER PRIMARY KEY AUTOINCREMENT,'
            +'nombre TEXT NOT NULL'
            +')'
        unik.sqlQuery(sql)
    }
}
