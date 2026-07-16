import Quickshell
import Quickshell.Wayland
import Quickshell.Services.Notifications
import QtQuick
import QtQuick.Layouts

Scope {
	id: root

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
					border.color: "#EBDBB2"
					border.width: 2
					color: "#282828"

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
								color: "#EBDBB2"
								font.bold: true
								elide: Text.ElideRight
							}
	
							Text { 
								leftPadding: 8
								visible: text !== ""
								width: parent.width
								text: modelData.body
								color: "#EBDBB2" 
								wrapMode: Text.WordWrap	
							}
						}	
					}
				}
			}
		}
	}
}
