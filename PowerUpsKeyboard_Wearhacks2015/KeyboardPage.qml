import QtQuick 2.2
import QtQuick.Controls 1.2
import QtQuick.Controls.Styles 1.2
import QtGraphicalEffects 1.0

Item {
    id: rootItem
    width: 100
    height: 62

    focus: true

    anchors.fill: parent

    property int currentRightSelectedIndex:7

    property int currentLeftSelectedIndex:7

    property int destinationRightIndex:7
    property int destinationLeftIndex:7

    property string rightMoveAction;
    property string leftMoveAction;

    Image{
        id: backgroundImage
        anchors.fill: rootItem
        source: "qrc:/Images/centralscreenbg.png"
    }

    //TextBox
    TextField{
        id: textField
        anchors{
            horizontalCenter: rootItem.horizontalCenter
            top: rootItem.top
            topMargin:100
        }

        horizontalAlignment: Text.AlignHCenter

        width: rootItem.width  * 0.5
        height:100
        textColor: "White"
        font.pixelSize: 35
        style:
            TextFieldStyle{
                //font.pixelSize: 20

                background: Image{
                    id: bgImage
                    source: "qrc:/Images/normalinput.png"

                }
            }

    }

    Component{
        id: keypadDelegateLeft
        Item{
            id: keypadDelegateContainerLeft

            width: keypadLeftGridView.cellWidth
            height: keypadLeftGridView.cellHeight




            Rectangle{
                id:keyRect

                color:"grey"
                opacity:0.4
                visible: true
                anchors{
                    left: keypadDelegateContainerLeft.left
                    right: keypadDelegateContainerLeft.right
                    bottom: keypadDelegateContainerLeft.bottom
                    top: keypadDelegateContainerLeft.top
                    margins:2
                }

                //width: keypadLeftContainer.cellWidth
                //height:keypadLeftContainer.cellHeight

                border.color:"white"
                border.width:2


                Text{
                    id: keyText
                    anchors.centerIn: keyRect
                    text:key
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                    color:"white"
                    font.bold: rootItem.currentLeftSelectedIndex == index? true: false
                    font.pixelSize: rootItem.currentLeftSelectedIndex == index? 40:18
                }
            }
        }
    }

    //Keypad Left
    Item{
        id:keypadLeftContainer
        anchors{
            left: rootItem.left
            top: textField.bottom
            right: rootItem.horizontalCenter
            bottom: rootItem.bottom
        }


        Image{
            id: selectedItem
            source: "qrc:/Images/toolbarbuttonnormal.png"
                //"qrc:/Images/toolbarbuttonactive.png"
                //"qrc:/Images/toolbarbuttonhover.png"
            property int offsetValue: keypadLeftGridView.cellWidth * 0.45
            x: (keypadLeftContainer.width - keypadLeftGridView.width)/2 + 2 * keypadLeftGridView.cellWidth - offsetValue/2
            y: (keypadLeftContainer.height - keypadLeftGridView.height)/2 + keypadLeftGridView.cellHeight - offsetValue/2
            width: keypadLeftGridView.cellWidth + offsetValue
            height: keypadLeftGridView.cellHeight + offsetValue
            z:20
        }

        DropShadow
        {
            id: dropShadow
            anchors.fill: selectedItem
            horizontalOffset:13
            verticalOffset:13
            source: selectedItem
            radius:8.0
            samples:16
        }

//        Rectangle{
//            id: boundaryRect
//            anchors.fill:selectedItem
//            color:"transparent"
//            border.color:"black"
//            border.width:1

//        }

        GridView{
            id: keypadLeftGridView
            x:(keypadLeftContainer.width - keypadLeftGridView.width)/2
            y: (keypadLeftContainer.height - keypadLeftGridView.height)/2

            width: keypadLeftContainer.width *0.4
            height: keypadLeftContainer.height*0.5
            cellWidth: width/5
            cellHeight: height/3
            model: leftKeypadModel
            delegate: keypadDelegateLeft
        }
    }

    //Keypad Right
    Timer{
        id: rightTimer
        interval:700
        repeat: false
        onTriggered:{
            //check if can move to next one

            //get move flag
            //nodRingControllerRight.getEnableMove() == false
/*            if(nodRingControllerRight.getEnableMove() == false){
                //add letter to string
                keypadRightContainer.addLetterToString()
            }else*/

            console.log("Enable move is: " + nodRingControllerRight.getEnableMove())
            if(nodRingControllerRight.getEnableMove() == true){
                //keep moving
                if(rootItem.currentRightSelectedIndex != rootItem.destinationRightIndex){
                    if(rootItem.rightMoveAction == "UP"){
                        rootItem.currentRightSelectedIndex = rootItem.currentRightSelectedIndex - 5;
                        keypadRightContainer.goToKeyRight(rootItem.currentRightSelectedIndex);
                    }
                    else if(rootItem.rightMoveAction == "LEFT"){
                        rootItem.currentRightSelectedIndex = rootItem.currentRightSelectedIndex -1;
                        keypadRightContainer.goToKeyRight(rootItem.currentRightSelectedIndex);
                    }
                    else if(rootItem.rightMoveAction == "DOWN"){
                        rootItem.currentRightSelectedIndex = rootItem.currentRightSelectedIndex +5;
                        keypadRightContainer.goToKeyRight(rootItem.currentRightSelectedIndex);
                    }
                    else if(rootItem.rightMoveAction == "RIGHT"){
                        rootItem.currentRightSelectedIndex = rootItem.currentRightSelectedIndex + 1;
                        keypadRightContainer.goToKeyRight(rootItem.currentRightSelectedIndex);
                    }
                    else if(rootItem.rightMoveAction == "UPPER_LEFT"){
                        rootItem.currentRightSelectedIndex = rootItem.currentRightSelectedIndex -6;
                        keypadRightContainer.goToKeyRight(rootItem.currentRightSelectedIndex);
                    }
                    else if(rootItem.rightMoveAction == "UPPER_RIGHT"){
                        rootItem.currentRightSelectedIndex = rootItem.currentRightSelectedIndex -4;
                        keypadRightContainer.goToKeyRight(rootItem.currentRightSelectedIndex);
                    }
                    else if(rootItem.rightMoveAction == "LOWER_LEFT"){
                        rootItem.currentRightSelectedIndex = rootItem.currentRightSelectedIndex + 4;
                        keypadRightContainer.goToKeyRight(rootItem.currentRightSelectedIndex);
                    }
                    else if(rootItem.rightMoveAction == "LOWER_RIGHT"){
                        rootItem.currentRightSelectedIndex = rootItem.currentRightSelectedIndex + 6;
                        keypadRightContainer.goToKeyRight(rootItem.currentRightSelectedIndex);
                    }
                }
            }
        }
    }

    Component{
        id: keypadDelegateRight
        Item{
            id: keypadDelegateContainerRight

            width: keypadRightGridView.cellWidth
            height: keypadRightGridView.cellHeight

            Connections{
                id: connectionsToRightKeypad
                target: keypadRightContainer
                onGoToKeyRight:{
                    if(goToIndex == index){
                        console.log("Going to INDEX: " + index)
                        console.log("Destination index is: " + rootItem.destinationRightIndex)

                        //find difference between current element and selected element
                        var diffX = selectedItemRight.x + selectedItemRight.offsetValue/2 - (keypadDelegateContainerRight.x + keypadRightGridView.x) ;
                        var diffY = selectedItemRight.y + selectedItemRight.offsetValue/2 - (keypadDelegateContainerRight.y + keypadRightGridView.y);

                        //move gridview by this much
                        keypadRightGridView.x = keypadRightGridView.x + diffX;
                        keypadRightGridView.y = keypadRightGridView.y + diffY;

                        rightTimer.start()
                    }

                }
                onAddLetterToString:{
                    if(rootItem.currentRightSelectedIndex == index){
                        textField.text = "%1%2".arg(textField.text).arg(key)
                    }
                }
            }



            Rectangle{
                id:keyRect

                color:"grey"
                opacity:0.4
                visible: true
                anchors{
                    left: keypadDelegateContainerRight.left
                    right: keypadDelegateContainerRight.right
                    bottom: keypadDelegateContainerRight.bottom
                    top: keypadDelegateContainerRight.top
                    margins:2
                }

                //width: keypadLeftContainer.cellWidth
                //height:keypadLeftContainer.cellHeight

                border.color:"white"
                border.width:2


                Text{
                    id: keyText
                    anchors.centerIn: keyRect
                    text:key
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                    color:"white"
                    font.bold: rootItem.currentRightSelectedIndex == index? true: false
                    font.pixelSize: rootItem.currentRightSelectedIndex == index? 40:18

                }
            }
        }
    }

    property bool pressedOnce: false
    property bool somethingElsePressed: false

    Keys.onPressed:{
        if(event.key == Qt.Key_J){
            nodRingControllerRight.positionChanged("LEFT");
            event.accepted = true;
            somethingElsePressed = true
        }
        else if(event.key == Qt.Key_L){
            nodRingControllerRight.positionChanged("RIGHT");
            event.accepted = true;
            somethingElsePressed = true
        }
        else if(event.key == Qt.Key_I){
            nodRingControllerRight.positionChanged("UP");
            event.accepted = true;
            somethingElsePressed = true
        }
        else if(event.key == Qt.Key_Comma){
            nodRingControllerRight.positionChanged("DOWN");
            event.accepted = true;
            somethingElsePressed = true
        }
        else if(event.key == Qt.Key_U){
            nodRingControllerRight.positionChanged("UPPER_LEFT");
            event.accepted = true;
            somethingElsePressed = true
        }
        else if(event.key == Qt.Key_O){
            nodRingControllerRight.positionChanged("UPPER_RIGHT");
            event.accepted = true;
            somethingElsePressed = true
        }
        else if(event.key == Qt.Key_M){
            nodRingControllerRight.positionChanged("LOWER_LEFT");
            event.accepted = true;
            somethingElsePressed = true
        }
        else if(event.key == Qt.Key_Period){
            nodRingControllerRight.positionChanged("LOWER_RIGHT");
            event.accepted = true;
            somethingElsePressed = true
        }
        else if(event.key == Qt.Key_Return){
            console.log("Return pressed")

            if(nodRingControllerRight.getEnableMove() != 1){
                nodRingControllerRight.setEnableMove(1)
            }

            if(event.isAutoRepeat == true)           {
                event.accepted = false
            }else{
                event.accepted = true
                rootItem.focus = true
            }
        }

    }
    Keys.onReleased:{
        if(event.key == Qt.Key_Return){
            if(event.isAutoRepeat){
                event.accepted = false
            }else{
                event.accepted = true
                nodRingControllerRight.setEnableMove(0)
                if(somethingElsePressed){
                    keypadRightContainer.addLetterToString()
                    somethingElsePressed = false
                }
                textField.focus = true
                console.log("Adding letter to string from key release")
            }
        }
    }

    Item{
        id: keypadRightContainer
        anchors{
            right: rootItem.right
            left: rootItem.horizontalCenter
            top: textField.bottom
            bottom: rootItem.bottom
        }

        signal goToKeyRight(int goToIndex)
        signal addLetterToString();


        function selectKey(goToIndex){
            rootItem.currentRightSelectedIndex = goToIndex;
            goToKeyRight(goToIndex);

        }


        Connections{
            id: connectionsToNodRingControllerRight
            target: nodRingControllerRight
            onPositionChanged:{
                console.log("POSITION RECEIVED BY KEYBOARD CLASS: " + action)

                if(action == "UP")
                {
                    rootItem.destinationRightIndex = rootItem.currentRightSelectedIndex
                    while(rootItem.destinationRightIndex - 5 >= 0){
                        rootItem.destinationRightIndex = rootItem.destinationRightIndex - 5;
                    }

                    if(rootItem.destinationRightIndex != rootItem.currentRightSelectedIndex){
                        keypadRightContainer.selectKey(rootItem.currentRightSelectedIndex - 5);
                        rootItem.rightMoveAction = "UP"
                    }

                    console.log("Destination right index is: "+ rootItem.destinationRightIndex)
                }
                else if(action == "LEFT")
                {
                    rootItem.destinationRightIndex = rootItem.currentRightSelectedIndex
                    while(rootItem.destinationRightIndex%5 - 1 >= 0){
                        rootItem.destinationRightIndex = rootItem.destinationRightIndex -1;
                    }

                    if(rootItem.destinationRightIndex != rootItem.currentRightSelectedIndex){
                        keypadRightContainer.selectKey(rootItem.currentRightSelectedIndex - 1);
                        rootItem.rightMoveAction = "LEFT"
                    }
                }
                else if(action == "DOWN")
                {
                    rootItem.destinationRightIndex = rootItem.currentRightSelectedIndex
                    while(rootItem.destinationRightIndex + 5 <= 14){
                        rootItem.destinationRightIndex = rootItem.destinationRightIndex + 5;
                    }

                    if(rootItem.destinationRightIndex != rootItem.currentRightSelectedIndex){
                        keypadRightContainer.selectKey(rootItem.currentRightSelectedIndex + 5);
                        rootItem.rightMoveAction = "DOWN"
                    }
                }
                else if(action == "RIGHT")
                {
                    rootItem.destinationRightIndex = rootItem.currentRightSelectedIndex
                    while(rootItem.destinationRightIndex%5 + 1 <= 4){
                        rootItem.destinationRightIndex = rootItem.destinationRightIndex + 1;
                    }

                    if(rootItem.destinationRightIndex != rootItem.currentRightSelectedIndex){
                        keypadRightContainer.selectKey(rootItem.currentRightSelectedIndex + 1);
                        rootItem.rightMoveAction = "RIGHT"
                    }



                }
                else if(action == "UPPER_RIGHT")
                {
                    rootItem.destinationRightIndex = rootItem.currentRightSelectedIndex
                    while(rootItem.destinationRightIndex - 4 > 0){
                        rootItem.destinationRightIndex = rootItem.destinationRightIndex - 4;
                    }

                    if(rootItem.destinationRightIndex != rootItem.currentRightSelectedIndex){
                        keypadRightContainer.selectKey(rootItem.currentRightSelectedIndex - 4);
                        rootItem.rightMoveAction = "UPPER_RIGHT"
                    }
                }
                else if(action == "UPPER_LEFT")
                {
                    rootItem.destinationRightIndex = rootItem.currentRightSelectedIndex
                    while(rootItem.destinationRightIndex - 6 >= 0){
                        rootItem.destinationRightIndex = rootItem.destinationRightIndex - 6;
                    }

                    if(rootItem.destinationRightIndex != rootItem.currentRightSelectedIndex){
                        keypadRightContainer.selectKey(rootItem.currentRightSelectedIndex - 6);
                        rootItem.rightMoveAction = "UPPER_LEFT"
                    }
                }
                else if(action == "LOWER_LEFT")
                {
                    rootItem.destinationRightIndex = rootItem.currentRightSelectedIndex
                    while(rootItem.destinationRightIndex + 4 <= 14){
                        rootItem.destinationRightIndex = rootItem.destinationRightIndex + 4;
                    }

                    if(rootItem.destinationRightIndex != rootItem.currentRightSelectedIndex){
                        keypadRightContainer.selectKey(rootItem.currentRightSelectedIndex + 4);
                        rootItem.rightMoveAction = "LOWER_LEFT"
                    }
                }
                else if(action == "LOWER_RIGHT")
                {
                    rootItem.destinationRightIndex = rootItem.currentRightSelectedIndex
                    while(rootItem.destinationRightIndex + 6 <= 16){
                        rootItem.destinationRightIndex = rootItem.destinationRightIndex + 6;
                    }

                    if(rootItem.destinationRightIndex != rootItem.currentRightSelectedIndex){
                        keypadRightContainer.selectKey(rootItem.currentRightSelectedIndex + 6);
                        rootItem.rightMoveAction = "LOWER_RIGHT"
                    }
                }

            }

            onEnableMovedChanged:{
                if(nodRingControllerRight.getEnableMove() == false)
                {
                    //add letter to string
                    keypadRightContainer.addLetterToString()
                }
            }

        }

        Image{
            id: selectedItemRight
            source:"qrc:/Images/toolbarbuttonnormal.png"

                //"qrc:/Images/toolbarbuttonactive.png"
                //"qrc:/Images/toolbarbuttonhover.png"
            property int offsetValue: keypadRightGridView.cellWidth * 0.45
            x: (keypadRightContainer.width - keypadRightGridView.width)/2 + 2 * keypadRightGridView.cellWidth - offsetValue/2
            y: (keypadRightContainer.height - keypadRightGridView.height)/2 + keypadRightGridView.cellHeight - offsetValue/2
            width: keypadRightGridView.cellWidth + offsetValue
            height: keypadRightGridView.cellHeight + offsetValue

            z:20
        }

        DropShadow
        {
            id: dropShadowRight
            anchors.fill: selectedItemRight
            horizontalOffset:13
            verticalOffset:13
            source: selectedItemRight
            radius:8.0
            samples:16
        }

//        Rectangle{
//            id: boundaryRectRight
//            anchors{
//                fill:selectedItemRight
//            }
//            color:"transparent"
//            border.color:"black"
//            border.width:1

//        }

        GridView{
            id: keypadRightGridView
            x: (keypadRightContainer.width - keypadRightGridView.width)/2
            y: (keypadRightContainer.height - keypadRightGridView.height)/2
            width: keypadRightContainer.width * 0.4
            height: keypadRightContainer.height * 0.5
            cellWidth: width/5
            cellHeight: height/3
            model: rightKeypadModel
            delegate: keypadDelegateRight

        }
    }

    ListModel{
        id: leftKeypadModel
        ListElement{ key:"Q" }
        ListElement{ key:"W" }
        ListElement{ key:"E" }
        ListElement{ key:"R" }
        ListElement{ key:"T" }
        ListElement{ key:"A" }
        ListElement{ key:"S" }
        ListElement{ key:"D" }
        ListElement{ key:"F" }
        ListElement{ key:"G" }
        ListElement{ key:"Z" }
        ListElement{ key:"X" }
        ListElement{ key:"C" }
        ListElement{ key:"V" }
        ListElement{ key:"B" }
    }

    ListModel{
        id: rightKeypadModel
        ListElement{ key:"Y" }
        ListElement{ key:"U" }
        ListElement{ key:"I" }
        ListElement{ key:"O" }
        ListElement{ key:"P" }
        ListElement{ key:"H" }
        ListElement{ key:"J" }
        ListElement{ key:"K" }
        ListElement{ key:"L" }
        ListElement{ key:";" }
        ListElement{ key:"B" }
        ListElement{ key:"N" }
        ListElement{ key:"M" }
        ListElement{ key:"," }
        ListElement{ key:"." }
    }

//    Rectangle{
//        id: testRectangle
//        width:100
//        height:100
//        anchors{
//            right: rootItem.right
//            bottom: rootItem.bottom
//            margins:15
//        }

//        MouseArea{
//            id: testRectangleMouseArea
//            anchors.fill: testRectangle
//            onClicked: keypadRightContainer.selectKey(1)
//                //nodRingControllerRight.positionChanged("UP")
//        }
//    }

//    Rectangle{
//        id: testRectangle2
//        width:100
//        height:100
//        anchors{
//            right: testRectangle.left
//            bottom: rootItem.bottom
//            margins:15
//        }

//        MouseArea{
//            id: testRectangleMouseArea2
//            anchors.fill: testRectangle2
//            onClicked: nodRingControllerRight.positionChanged("LOWER_RIGHT")
//        }
//    }



}
