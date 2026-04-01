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
	id: bar
	anchors.top: true
  anchors.left: true
  anchors.right: true
  implicitHeight: 40
	color: black		

	
	property int batLevel
	property int volume
	property int ramUsage
	property int cpuUsage

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
		
		RowLayout {
			spacing: 10
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
		
		Item { width: 40}		

		ColumnLayout {
			spacing: 15
			anchors.margins: 3
			Brightness { 
				Layout.preferredHeight: 3
			}

			Audio { }
		}	

		Process {
				id: wallpaperChange		
				command: [ "sh", "-c", "swww img --transition-type fade --transition-duration 1 ~/wallpaper/gruvbox/" + wallpaper + ".png"]
				running: false
			}
		
//		PopupWindow {
//			id: wallMenu	
//			anchor.window: bar
//    	anchor.rect.x: wallButton.x 
//			anchor.rect.y: parentWindow.height
//			color: black
//    	implicitWidth: 100
//    	implicitHeight: 50
//			visible: false
	
				ScrollView {	
					implicitWidth: 120
					implicitHeight: 20	
					ScrollBar.vertical.policy: ScrollBar.AlwaysOff
					ColumnLayout {		
						Repeater {
							model: [ 
								"paintForest", 
								"studio", 
								"vendingMachines", 
								"corona",
								"cherryBlossom",
								"minimalSunset",
								"starfish",
								"antennas",
								"greenValley"
							]	
								MouseArea {
									required property var modelData
									height: 20
									width: 120
									Text {
										anchors.centerIn: parent
										text: modelData
										color: white
										font.pixelSize: 13
									}
									onClicked: {
										wallpaper = modelData
										wallpaperChange.running = true
									}
								}
							}
						}
					}

//		Text {
//			id: ram
//			color: blue
//			text: "󰧑 " + ramUsage + "%"
//			font { pixelSize: 15; bold: true}
//		}
//
//		Process {
//			id: getRam
//			command: ["sh", "-c", "free | grep -o '[0-9]*' | sed -n -e 2p"]
//			stdout: StdioCollector {
//				onStreamFinished: ramUsage = this.text / 15755544 * 100
//			}
//			running: true
//		}
//
//		Timer {
//			interval: 5000
//			running: true
//			repeat: true
//			onTriggered: getRam.running = true
//		}


//		Text {
//			id: cpu
//			color: yellow
//			text: "󰘚 " + cpuUsage + "%"
//			font { pixelSize: 15; bold: true}
//		}
//
//		Process {
//			id: getCpu
//			command: ["sh", "-c", "vmstat | grep -o '[0-9]*' | sed -n -e '15p; 16q'"]
//			stdout: StdioCollector {
//				onStreamFinished: cpuUsage = 100 - this.text
//			}
//			running: true
//		}
//
//		Timer {
//			interval: 5000
//			running: true
//			repeat: true
//			onTriggered: getCpu.running = true
//		}
//
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
			ToolTip {
				visible: hover
				text: "Test"
				delay: 10
			} 
		}
	
		Timer {
			interval: 1000
			running: true
			repeat: true
			onTriggered: clock.text = Qt.formatDateTime(new Date(), "HH:mm:ss") 
		}
	}	
}

