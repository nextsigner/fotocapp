import QtQuick 2.0

Item {
    id: r
    width: xBtn.width+horizontalMargin*2
    height: xBtn.height+verticalMargin
    property int fontSize: 24
    property int borderWidth: 2
    property alias radius: xBtn.radius
    property string text: '????'
    property int horizontalMargin: 10
    property int verticalMargin: 10
    property int horizontalPadding: 10
    property int verticalPadding: 10
    property int w: -1
    property int h: -1
    property color c1: 'white'
    property color c2: 'black'
    property color c3: 'gray'
    property color c4: 'red'

    property bool onHover: false
    property bool pressed: false

    signal clicked()

    Rectangle{
        id: xBtn
        width: r.w!==-1?r.w:label.contentWidth+r.horizontalPadding
        height: r.h!==-1?r.h:label.contentHeight+r.verticalPadding
        color:  !r.pressed?r.c1:r.c2
        radius: 8
        border.width: r.borderWidth
        border.color:  !r.pressed?r.c2:r.c1
        anchors.centerIn: parent
        Rectangle{
            anchors.fill: parent
            color: r.c2
            opacity: 0.5
            visible: r.onHover&&!r.pressed
            radius: parent.radius
        }
        Text{
            id: label
            text: r.text
            color: !r.pressed?(r.onHover?r.c1:r.c2):r.c1
            font.pixelSize: r.fontSize
            anchors.centerIn: parent
        }
        MouseArea{
            anchors.fill: parent
            hoverEnabled: true
            onEntered: r.onHover=true
            onExited: {
                r.onHover=false
                r.pressed=false
            }
            onPressed: r.pressed=true
            onReleased: r.pressed=false
            onClicked: {
                r.clicked()
            }
        }
    }
}
