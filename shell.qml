import Quickshell
import Quickshell.Wayland
import Quickshell.Hyprland
import QtQuick
import QtQuick.Layouts
import Quickshell.Io
import QtQuick.Controls

PanelWindow {
  anchors.top: true
  anchors.left: true
  anchors.right: true
  implicitHeight: 40
  color: black

	property int batLevel
	property int volume
	
	property string black: "#282828" 	
	property string grey: "#7C6F64"	
	property string white: "#EBDBB2"
	property string blue: "#458588"
	property string yellow: "#D79921"
	property string green: "#98971A"
	property string wallpaper: "paintForest"	

  RowLayout {
    anchors.fill: parent
		anchors.margins: 8
		spacing: 20

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
	
		Item { width: 40}		

		ColumnLayout {
			spacing: 15
			anchors.margins: 3
			Brightness { 
				Layout.preferredHeight: 3
			}

			Audio { }
		}

		Menu {
			id: wallpaperMenu	
			title: Wallpapers	
			height: 50
			width: 100
			x: 1000
			MenuItem { 		
				Button {	
					text: "paintForest"
					onClicked: { wallpaper = "paintForest"; wallpaperChange.running = true	}	
				}								
			}
			MenuItem {
				Button {	
					text: "cherryBlossom"
					onClicked: { wallpaper = "cherryBlossom"; wallpaperChange.running = true	}	
				}		
			}
			MenuItem { 		
				Button {	
					text: "corona"
					onClicked: { wallpaper = "corona"; wallpaperChange.running = true	}	
				}								
			}
			MenuItem { 		
				Button {	
					text: "studio"
					onClicked: { wallpaper = "studio"; wallpaperChange.running = true	}	
				}								
			}
		}	
		

		Process {
				id: wallpaperChange		
				command: [ "sh", "-c", "swww img ~/wallpaper/gruvbox/" + wallpaper + ".png"]
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
			id: battery
			color: green
			font { pixelSize: 15; bold: true }	
			text: "󰁹 " + batLevel + "%"
		}		

		Process {
				id: bat
				command: ["sh", "-c", "upower -i /org/freedesktop/UPower/devices/battery_BATT | grep percentage | grep -o '[0-9]*'"]
				running: true
				stdout: StdioCollector {
    			onStreamFinished: batLevel = this.text
    		}
			}
	
		Timer {
			interval: 5000
			running: true
			repeat: true
			onTriggered: bat.running = true
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
