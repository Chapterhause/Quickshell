import Quickshell
import Quickshell.Wayland
import Quickshell.Hyprland
import QtQuick
import QtQuick.Layouts
import Quickshell.Io
import QtQuick.Controls
import Quickshell.Services.Notifications
import Quickshell.Services.UPower 

ShellRoot {	
	property int volume
	property int pieX
	property int pieY

// For battery notifications
	property bool isCharging: UPower.displayDevice.state == UPowerDeviceState.Charging
	property bool	chargePending: UPower.displayDevice.state == UPowerDeviceState.PendingCharge
	property bool wasCharging: false
	property real timeUntilCharged: UPower.displayDevice.timeToFull
	property real batLevel: UPower.displayDevice.percentage * 100

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
			implicitHeight: 40
			implicitWidth: 200
			color: "transparent"
			focusable: true	
		Rectangle {
			anchors.fill: parent
			color: black
			bottomRightRadius: 10
			bottomLeftRadius: 10

	  	RowLayout {
		    anchors.fill: parent
				anchors.margins: 8
				spacing: 20
				
				RowLayout {
					spacing: 3
		   	 Repeater {
			      model: 3
			
			      Text {
			        property var ws: Hyprland.workspaces.values.find(w => w.id === index + 1)
			        property bool isActive: Hyprland.focusedWorkspace?.id === (index + 1)
			        text: ws ? index + 1 : "" 
			        color: isActive ? blue : (ws ? white : black)
			        font { pixelSize: 15; bold: true }
			
			        MouseArea {
			          anchors.fill: parent
			          onClicked: Hyprland.dispatch("workspace " + (index + 1))
			        }
			      }
		    	}	
				}		
		
//				Process {
//						id: wallpaperChange		
//						command: [ "sh", "-c", "awww img --transition-type fade --transition-duration 1 ~/wallpaper/gruvbox/" + wallpaper + ".png"]
//						running: false
//					}
//					
//					ScrollView {	
//						implicitWidth: 120
//						implicitHeight: 20	
//						ScrollBar.vertical.policy: ScrollBar.AlwaysOff
//						focus: true	
//						
//						ColumnLayout {		
//							Repeater {
//								model: [ 
//								"paintForest", 
//								"studio", 
//								"vendingMachines", 
//								"corona",
//								"cherryBlossom",
//								"minimalSunset",
//								"starfish",
//								"antennas",
//								"greenValley"
//							]	
//							
//							MouseArea {
//								required property var modelData
//								height: 64
//								width: 64
//								Image {	
//									source: "/home/simonn/wallpaper/gruvbox/" + modelData + ".png"
//									fillMode: Image.Stretch
//									sourceSize.width: 64
//									sourceSize.height: 64
//								}
//								onClicked: {
//									wallpaper = modelData
//									wallpaperChange.running = true
//								}
//							}
//						}
//					}
//				}	
	
	//			Process {
	//				id: wifiConnect
	//				command: ["sh", "-c", "nmcli d wifi connect " + wifiField.text + " && sleep 15s"]
	//				running: false
	//				stdout: StdioCollector {
	//					onStreamFinished: wifiField.text = this.text
	//				}
	//			}
	
				MouseArea {
					id: batArea
					width: 20
					height: 20	
					hoverEnabled: true
					Text {
						text: isCharging ? "󰂄" : (batLevel > 90) ? "󰁹" : (batLevel > 70) ? "󰂀" : (batLevel > 40) ? "󰁾" : (batLevel > 20) ? "󰁻" : "󰁺" 
						color: green
						font.pixelSize: 19
					}
				onEntered: { 
					batNotif.running = true
				}
			}			

			Process {
				id: batNotif
				command: ["sh", "-c", "notify-send '" + batLevel + "%' 'Battery Level Check'"]
			}

			Timer {
				id: chargeCheck
				interval: 15000
				running: true
				repeat: true
				onTriggered: {
					chargingNotif.running = (wasCharging !== (isCharging || chargePending))	
					wasCharging = (isCharging || chargePending)	
				}
			}		

			Process {
				id: chargingNotif
				command: [ "sh", "-c", "notify-send 'Laptop is now " + (isCharging ? "charging' 'Time until full: '" + timeUntilCharged : "discharging' 'Time until empty: unknown'")]
				running: false
			}
			
			Timer {
				id: lowBatCheck
				interval: 600000 // 600000 = Ten minutes
				running: true
				repeat: true
				onTriggered: {	
					lowBatWarning.running = (batLevel < 20)
				}
			}

			Process {
				id: lowBatWarning
				command: ["sh", "-c", "notify-send 'Only at " + batLevel + "%' 'Low battery - Charging recommended'"]
				running: false
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
			color: "transparent"

			Repeater {
    		id: rep
    		model: ["firefox", "gimp", "blender", "obsidian", "krita", "sunvox"]

    		delegate: Item {
       		height: 160
        	anchors.centerIn: parent
        	transformOrigin: Item.Center
        	rotation: 360 / rep.model.length * index
        	MouseArea {
						height: 25
						width: 80
						hoverEnabled: true
						onEntered: {
							app = modelData
							launchApp.running = true
							pieMenu.visible = false
						}
						Rectangle {
							anchors.fill: parent
							color: black
							radius: 20
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

	NotificationServer {
		id: server
		actionsSupported: true	
		bodySupported: true

		onNotification: n => {
			n.tracked = true	
		}
	}

	PanelWindow {
		id: notifyWindow	
		anchors.top: true
		anchors.right: true
		anchors.bottom: true	
		
		margins.top: 50

		implicitWidth: 250
		implicitHeight: 500
		color: "transparent"
		exclusionMode: ExclusionMode.Ignore

		ColumnLayout {
			width: parent.width		
			spacing: 10

			Repeater {
				id: cards
				model: server.trackedNotifications
				delegate: Rectangle {
					required property var modelData
					width: parent.width	
					height: 50
					radius: 10	
					border.color: white
					border.width: 2
					color: black

					Timer {
						running: true
						interval: 5000
						onTriggered: modelData.dismiss()
					}

					MouseArea {
						anchors.fill: parent
						onClicked: {
							modelData.dismiss()
						}
				
						ColumnLayout {	
							width: parent.width	
							spacing: 2
							
							Text { 	
								topPadding: 5
								leftPadding: 8
								text: modelData.summary
								width: parent.width
								color: white
								font.bold: true
								elide: Text.ElideRight
							}
	
							Text {
								leftPadding: 8
								visible: text !== ""
								width: parent.width
								text: modelData.body
								color: white
								wrapMode: Text.WordWrap	
							}
						}	
					}
				}
			}
		}
	}
}
	
