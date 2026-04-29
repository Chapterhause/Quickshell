import Quickshell
import Quickshell.Wayland
import Quickshell.Hyprland
import QtQuick
import QtQuick.Layouts
import Quickshell.Io
import QtQuick.Controls

ShellRoot {
	property int batLevel
	property int volume
	property int pieX
	property int pieY

// Colors
	property string black: "#282828" 	
	property string grey: "#7C6F64"	
	property string white: "#EBDBB2"
	property string blue: "#458588"
	property string yellow: "#D79921"
	property string green: "#98971A"
	
	property string wallpaper: "paintForest"	
	property string app: "firefox"
	
		PanelWindow {
			id: bar
			anchors.top: true
		  anchors.left: true
		  anchors.right: true
		  implicitHeight: 40
			color: black		
			focusable: true	
		
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
					focus: true	
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

	PopupWindow {
		id: pieMenu
		anchor.window: bar
		anchor.rect.x: pieX - 100
		anchor.rect.y: pieY - 100
		implicitWidth: 200
		implicitHeight: 200		
		visible: false	
		color: "transparent"
		Rectangle {
			anchors.fill: parent
			radius: 100
			color: black

			Repeater {
    		id: rep
    		model: ["firefox", "obsidian", "blender", "krita", "gimp", "sunvox"]

    		delegate: Item {
       		height: 160
        	anchors.centerIn: parent
        	transformOrigin: Item.Center
        	rotation: 360 / rep.model.length * index
        	MouseArea {
						height: 15
						width: 60
						hoverEnabled: true
						onEntered: {
							app = modelData
							launchApp.running = true
							pieMenu.visible = false
						}
						Rectangle {
							anchors.fill: parent
							color: grey
							Text {
								anchors.centerIn: parent
								text: modelData
								color: white
								font.pixelSize: 17
							} 
						}
						anchors.horizontalCenter: parent.horizontalCenter
         	  rotation: -parent.rotation // If you want to have them upright
					}
    		}
			}
		}	
	}

	Process {
		id: getCursorX
		command: [ "sh", "-c", "hyprctl cursorpos | grep -o '[0-9]*' | sed -n -e '1p; 2q'" ]
		stdout: StdioCollector {
	    onStreamFinished: pieX = this.text
		}
		running: false
	}

	Process {
		id: getCursorY
		command: [ "sh", "-c", "hyprctl cursorpos | grep -o '[0-9]*' | sed -n -e '2p; 3q'" ]
		stdout: StdioCollector {
	    onStreamFinished: pieY= this.text
		}
		running: false
	}

	Process {
		id: launchApp
		command: [ "sh", "-c", app ]
		running: false
	}

	GlobalShortcut {
    appid: "quickshell"
    name: "pieMenuToggle"
    onPressed: {
			getCursorX.running = true
			getCursorY.running = true
			pieMenu.visible = !pieMenu.visible
    }
	}
}
	
