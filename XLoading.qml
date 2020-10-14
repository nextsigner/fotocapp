import QtQuick 2.0

Item {
    id: r
    width: app.fs*4
    height: width
    visible: false
    anchors.centerIn: parent
    property var ao: [0.1, 0.2, 0.3,0.4,0.5,0.6,0.7,0.8,0.9,1.0]
    SequentialAnimation{
        running: r.visible
        loops: Animation.Infinite

        NumberAnimation {
            target: r
            property: "rotation"
            from:-359
            to:0
            duration: 900
            //easing.type: Easing.OutInQuad
        }
    }
    Repeater{
        model: 9
        Item{
            id: r2
            width: r.width
            height: 1
            anchors.centerIn: r
            rotation: index*(360/9)
            Behavior on opacity{
                NumberAnimation{duration: 500}
            }
            Timer{
                running: r.visible
                repeat: true
                interval: 600
                onTriggered: {
                    if(r2.opacity===0.0){
                        r2.opacity=r.ao[index]
                    }else{
                        r2.opacity=0.0
                    }
                }
            }
            Rectangle{
                id: circ1
                width: app.fs*0.6
                height: width
                color: 'red'
                border.width: 1
                radius: width*0.5
                rotation: 90
                gradient: Gradient {
                    GradientStop {
                        position: 0.00;
                        color: "#000";
                    }
                    GradientStop {
                        position: 0.50;
                        color: "transparent";
                    }
                    GradientStop {
                        position: 1.00;
                        color: "#000";
                    }
                }
                anchors.right: parent.right
                anchors.verticalCenter: parent.verticalCenter
                opacity: r.ao[index]
            }
            Rectangle{
                width: circ1.width
                height: width
                color: 'red'
                border.width: 1
                radius: width*0.5
                gradient: Gradient {
                    GradientStop {
                        position: 0.00;
                        color: "#000";
                    }
                    GradientStop {
                        position: 0.50;
                        color: "transparent";
                    }
                    GradientStop {
                        position: 1.00;
                        color: "#000";
                    }
                }
                anchors.right: parent.right
                anchors.verticalCenter: parent.verticalCenter
                opacity: r.ao[index]
            }
        }
    }
    MouseArea{
        anchors.fill: r
        onClicked: r.visible=false
    }

}
