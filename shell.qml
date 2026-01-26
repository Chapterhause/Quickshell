import Quickshell
import Quickshell.Wayland
import Quickshell.Hyprland
import QtQuick
import QtQuick.Layouts
import Quickshell.Io
import QtQuick.Controls

ShellRoot {

	property string black: "#282828" 	
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

  RowLayout {
    anchors.fill: parent
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
        color: isActive ? blue : (ws ? white : grey)
        font { pixelSize: 15; bold: true }

        MouseArea {
          anchors.fill: parent
          onClicked: Hyprland.dispatch("workspace " + (index + 1))
        }
      }
    }	
    }
	
		Item { width: 40}		
		Audio { }

		Menu {
			id: wallpaperMenu	
			title: Wallpapers	
			height: 50
			width: 100
			x: 2000
			MenuItem { 		
				Button {	
					text: "Tranquility"
					onClicked: { wallpaper = "tranquility"; wallpaperChange.running = true	}	
				}								
			}
			MenuItem {
				Button {	
					text: "redGrove"
					onClicked: { wallpaper = "redGrove"; wallpaperChange.running = true	}	
				}		
			}
			MenuItem { 		
				Button {	
					text: "sunflowerPixel"
					onClicked: { wallpaper = "sunflowerPixel"; wallpaperChange.running = true	}	
				}								
			}
			MenuItem { 		
				Button {	
					text: "rainbowBridge"
					onClicked: { wallpaper = "rainbowBridge"; wallpaperChange.running = true	}	
				}								
			}
		}	
	
		Process {
				id: wallpaperChange		
				command: [ "sh", "-c", "swww img --transition-type none ~/wallpaper/" + wallpaper + ".png"]
				running: false
			}

		Button {
			text: "Wallpapers"
			font { bold: true }
			onClicked: wallpaperMenu.open() 
			background: Rectangle {
				color: green
				radius: 10
				width: 85
			}
		}

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

PanelWindow {
	id: sidePanel	
	anchors.right: true
	implicitHeight: 120
	implicitWidth: 0

	MouseArea {
		anchors.fill: parent
		onClicked: {
			animateWidth.start()
		}
	}

	PropertyAnimation {
		id: animateWidth
		target: sidePanel
		properties: "implicitWidth"
		to: "40"
		duration: 200
	}
}
}
