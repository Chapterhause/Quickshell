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
//	property int pieX
//	property int pieY

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
	property string app: ""	
	
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
			gradient: Gradient {
//				orientation: Gradient.Horizontal
        GradientStop { position: -1.2; color: grey }
        GradientStop { position: 0.7; color: black }
    	}
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
			        font { pixelSize: 17; bold: true; family: "JetBrains Mono" }
			
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
					height: 25	
					anchors.verticalCenter: bar
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
					lowBatWarning.running = (batLevel < 20) && !isCharging
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
				font { pixelSize: 16; bold: true; family: "JetBrains Mono" }
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

	PanelWindow {
		id: pAnchor	
		color: "transparent"
		anchors.top: true
		anchors.right: true			
	}

	PopupWindow {
		id: pieMenu	
		anchor.window: pAnchor		
		anchor.gravity: Edges.Top | Edges.Left
		implicitWidth: 1400
		implicitHeight: 1000
		visible: false	
		color: "transparent"
			Repeater {
				id: rep	
				model: ["firefox", "nemo", "blender", "obsidian", "rawtherapee", "sioyek"]	
    		delegate: Item {
					id: element
					height: 500
					width: 160
					y: -50
					x: 625
        	transformOrigin: Item.Bottom
        	rotation: 360 / rep.model.length * index
					
					MouseArea {
						id: pieButton
						anchors.fill: parent	
						hoverEnabled: true
						onEntered: {
							app = modelData		
						}
						
						Rectangle {	
							color: black
							anchors.centerIn: element
							y: 400
							width: 150
							height: 20
							radius: 20	
							rotation: -element.rotation
							
							Text {
								text: modelData
								anchors.centerIn: parent
								color: modelData == app ? blue : white
								font.pixelSize: 17 	
							} 
						}
						anchors.horizontalCenter: parent.horizontalCenter
					}
    		}
			}
			
	}

//	Process {
//		id: getCursorX
//		command: [ "sh", "-c", "hyprctl cursorpos | grep -o '[0-9]*' | sed -n -e '1p; 2q'" ]
//		stdout: StdioCollector {
//	    onStreamFinished: pieX = this.text
//		}
//		running: false
//	}

//	Process {
//		id: getCursorY
//		command: [ "sh", "-c", "hyprctl cursorpos | grep -o '[0-9]*' | sed -n -e '2p; 3q'" ]
//		stdout: StdioCollector {
//	    onStreamFinished: pieY= this.text
//		}
//		running: false
//	}

	Process {
		id: launchApp
		command: [ "sh", "-c", app ]
		running: false
	}

	GlobalShortcut {
    appid: "quickshell"
    name: "pieMenuToggle"
    onPressed: {	
			pieMenu.visible =	true 
		}
		onReleased: {
			pieMenu.visible = false
			launchApp.running = true
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
								font.family: "JetBrains Mono"
								elide: Text.ElideRight
							}
	
							Text {
								leftPadding: 8
								visible: text !== ""
								width: parent.width
								text: modelData.body
								color: white
								font.family: "JetBrains Mono"
								wrapMode: Text.WordWrap	
							}
						}	
					}
				}
			}
		}
	}
}
	
