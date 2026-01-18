import Quickshell
import QtQuick
import QtQuick.Layouts
import Quickshell.io

property string batteryLevel

Process {
				id: bat
				command: ["sh", "-c", "upower -i /org/freedesktop/UPower/devices/battery_BATT | grep percentage | grep -o '[0-9]*'"]
				running: true
				stdout: StdioCollector {
    			onStreamFinished: batteryLevel = this.text
    		}
			}
			
			Timer {
				interval: 5000
				running: true
				repeat: true
				onTriggered: {
					bat.running = true
				}
			}
