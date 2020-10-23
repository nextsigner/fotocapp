import QtQuick 2.0

XArea {
    id: r
    property string capId: ''
    property alias imageData: cap.source
    width: parent.width
    height: parent.height
    clip: true
    color: 'transparent'
    Rectangle{
        anchors.fill: r
        color: 'white'
        opacity: 0.75
    }
    Image {
        id: cap
        width: r.width*2
        x: 0-((width-r.width)/2)
        fillMode: Image.PreserveAspectFit
        MouseArea{
            id: maCap
            anchors.fill: parent
            drag.target: cap
            drag.axis: Drag.XAndYAxis
            onDoubleClicked:  {
                cap.x=0-((cap.width-r.width)/2)
                cap.y=0-((cap.height-r.width)/2)
            }
        }
    }
    Row{
        spacing: app.fs
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.bottom: parent.bottom
        anchors.bottomMargin: app.fs
        Boton{
            text: '  -  '
            fontSize: app.fs*2
            onClicked: {
                if(cap.width-app.fs*3<r.width){
                    //if(cap.width<r.width){
                        cap.x=0
                        cap.y=0
                    //}
                    return
                }
                cap.width-=app.fs*3

            }
        }
        Boton{
            text: ' + '
            fontSize: app.fs*2
            onClicked: {
                cap.width+=app.fs*3
            }
        }
        Boton{
            text: ' X '
            fontSize: app.fs*2
            onClicked: r.destroy(1)
        }
    }
}
