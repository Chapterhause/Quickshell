import Quickshell
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Quickshell.Io

  RowLayout {
    PopupWindow {
      id: wallMenu
      anchor.window: topBar
      anchor.rect.x: 2060
      anchor.rect.y: parentWindow.height
      width: 100
      height: 100 
      visible: false
      color: black

      MouseArea {
	anchors.fill: parent	
	hoverEnabled: true
	onExited: {
	  wallMenu.visible = false
	}

	ColumnLayout {
	  spacing: 0
	  MouseArea {	
	    width: 100
	    height: 25
	    Rectangle {
	      color: darkGrey
	      width: parent.width
	      height: 25
	    }
	    Text {	  
	      text: "Tranquility"
	      color: white
	      anchors.centerIn: parent
	    }
	    onClicked: { wallpaper = "tranquility"; wallpaperChange.running = true	}	  
          }	
          MouseArea {	
	    width: 100
	    height: 25
	    Rectangle {
	      color: black
	      width: parent.width
	      height: 25
	    }
	    Text {	  
	      text: "Red Grove"
	      color: white
	      anchors.centerIn: parent
	    }
	    onClicked: { wallpaper = "redGrove"; wallpaperChange.running = true	}	  
          } 
    	  MouseArea {	
	    width: 100 
	    height: 25
	    Rectangle {
	      color: darkGrey
	      width: parent.width
	      height: 25
	    }
	    Text {	  
	      text: "Rainbow Bridge"
	      color: white
	      anchors.centerIn: parent
	    }
	    onClicked: { wallpaper = "rainbowBridge"; wallpaperChange.running = true	}	  
          }
 	  MouseArea {	
	    width: 100 
	    height: 25
	    Rectangle {
	      color: black
	      width: parent.width
	      height: 25
	    }
	    Text {	  
	      text: "Sunflowers"
	      color: white
	      anchors.centerIn: parent
	    }
	    onClicked: { wallpaper = "sunflowerPixel"; wallpaperChange.running = true	}	  
          } 
        }
      }
    }

    Process {
      id: wallpaperChange		
      command: [ "sh", "-c", "swww img --transition-type fade --transition-duration 1 ~/wallpaper/" + wallpaper + ".png"]
      running: false
    }

    Rectangle {
      color: green
      radius: 10
      id: wall
      width: 40
      height: 20
      bottomLeftRadius: 20
      bottomRightRadius: 20
      MouseArea {
        anchors.fill: parent	
	hoverEnabled: true
	onEntered: {
	  wallMenu.visible = true	
        }
        Text {
	  text: "Wall"
	  anchors.centerIn: parent
	  font { pixelSize: 13; bold: true }
        }
      }
    }
  }
