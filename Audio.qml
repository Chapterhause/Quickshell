import Quickshell
import QtQuick
import QtQuick.Controls
import Quickshell.Io
import QtQuick.Layouts

RowLayout {

	property string volume
	Layout.preferredWidth: 30	
	spacing: 10
	Layout.preferredHeight: 1

	Process {	
		id: listen
		command: ["sh", "-c", "wpctl get-volume @DEFAULT_AUDIO_SINK@ | grep -o '[0-9]*' | sed -n -e '2p; 3q'"]
		running: true
			
		stdout: StdioCollector {
			onStreamFinished: volume = this.text	
		}	
	}

	Slider {
		id: volumeSlider
		value: volume		
		from: 0
		to: 50
		width: 150	
		height: 2
		stepSize: 1
		onValueChanged: {
			volume = value
			changeVolume.running = true
		}

		Process {
			id: changeVolume
			running: false
			command: [ "sh", "-c", "wpctl set-volume @DEFAULT_AUDIO_SINK@ " + volume + "%"]
		}	

		background: Rectangle {
     	y: parent.height - 5
      width: 150
      height: 5
      radius: 10
      color: grey

      Rectangle {
        width: volume * 3
        height: parent.height
        color: blue
        radius: 10
			}
		}

		handle: Rectangle { 
			x: volume * 3 - 6
			y: parent.height - 10
			width: 18
      height: 18
      radius: 9
			border.color: white
			color: white
			Text {
				anchors.centerIn: parent	
				text: volume
				color: black
				font { pixelSize: 10; bold: true }
			}
    }
	}	

	Timer {
		interval: 1000
		running: true
		repeat: true
		onTriggered: listen.running = true	
	}
}
