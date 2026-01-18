import Quickshell
import QtQuick
import Quickshell.Io
import QtQuick.Controls
import QtQuick.Layouts

RowLayout {
	property int brightness	

	Slider {
		value: brightness
		from: 1
		to: 50
		width: 150
		stepSize: 1
		height: 5
		onValueChanged: {
			brightness = value
			changeBrightness.running = true
		}
		
		Process {
			id: changeBrightness
			running: false
			command: ["sh", "-c", "brightnessctl s " + brightness + "%"]
		}

		background: Rectangle {
			y: parent.height - 5
			width: 150
			height: 5
			radius: 5
			color: grey

			Rectangle {
				width: brightness * 3
				height: parent.height
				color: green
				radius: 10
			}
		}

		handle: Rectangle {
			x: brightness * 3 - 6
			y: parent.height - 10
			color: white
			width: 18
			height: 18
			radius: 9
			Text {
				anchors.centerIn: parent
				text: brightness
				color: black
				font { pixelSize: 10; bold: true}
			}
		}
	}

		Process {
			id: bright
			command: ["sh", "-c", "brightnessctl | grep 'Current brightness' | grep -o '[0-9]*' | sed -n '2p; 3q'"]
			running: true
			stdout: StdioCollector {
	    	onStreamFinished: brightness = this.text
	    }
		}	
	
		Timer {
			interval: 1000
			running: true
			repeat: true
			onTriggered: bright.running = true
		}		
} 
