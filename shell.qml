import Quickshell
import Quickshell.Wayland
import Quickshell.Hyprland
import QtQuick
import QtQuick.Layouts
import Quickshell.Io
import QtQuick.Controls

ShellRoot {

  property string black: "#282828" 	
  property string darkGrey: "#3C3836"
  property string grey: "#7C6F64"	
  property string white: "#EBDBB2"
  property string blue: "#458588"
  property string yellow: "#D79921"
  property string green: "#98971A"
	
  property string wallpaper: "Tranquility"	 
	
PanelWindow {
  anchors.top: true
  anchors.left: true
  anchors.right: true
  implicitHeight: 40
  color: black	
  id: topBar

  RowLayout {	
		anchors.fill: parent
		anchors.centerIn: parent
    anchors.margins: 8
    spacing: 30

    RowLayout {
      spacing: 25
      Repeater {
        model: 9

        Text {
          property var ws: Hyprland.workspaces.values.find(w => w.id === index + 1)
          property bool isActive: Hyprland.focusedWorkspace?.id === (index + 1)
          text: index + 1
          color: isActive ? blue : (ws ? white : black)
          font { pixelSize: 15; bold: true }

          MouseArea {
            anchors.fill: parent
            onClicked: Hyprland.dispatch("workspace " + (index + 1))
          }
        }
      }	
    }
	 
    MouseArea {
      width: 40
      id: opener
      height: 20
      hoverEnabled: true
      onEntered: {
				subwindow.visible = true
      }
    } 
    		 
    PopupWindow {
      id: subwindow
      anchor.window: topBar
      anchor.rect.y: parentWindow.height
      anchor.rect.x: opener.x
      implicitHeight: 80
      implicitWidth: 200
      visible: false
      color: grey
      MouseArea {
				anchors.fill: parent
				hoverEnabled: true
				onExited: {
	  			subwindow.visible = false
  			}
  			TabBar {
       		id: bar
        	width: parent.width
        	TabButton {
         		text: "Music" 
        	}
        	TabButton {
       			text:	"Performance" 
    			}
    			TabButton {
        		text: "Network"
    			}
				}

				SwipeView {
					width: parent.width - 50
					height: parent.height - 50
					anchors.centerIn: parent
    			currentIndex: bar.currentIndex
					Text {
						text: "Current Song:"	
						color: white
					}	
    			Text {
						text: "CPU Usage:"	
						color: white
    			}
					Text {
						text: "Networks Available:"
						color: white
					}	
				}
    	}
		}

//    TextField {
//      id: networkField
//      height: 20
//      width: 80
//      placeholderText: "Enter network name" 
//      placeholderTextColor: black
//      hoverEnabled: true
//      focus: true
//      background: Rectangle {
//	color: grey
//      }
//    }

    Audio { }

    WallpaperMenu { }  

    Text {
      id: clock
			color: white  
      font { pixelSize: 15; bold: true }
      text: Qt.formatDateTime(new Date(), "HH:mm:ss")
    }
	
    Timer {
      interval: 1000
      running: true
      repeat: true
      onTriggered: clock.text = Qt.formatDateTime(new Date(), "HH:mm:ss") 
    }
  }
}
}
