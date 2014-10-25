using Toybox.WatchUi as Ui;
using Toybox.Graphics as Gfx;
using Toybox.System as Sys;
using Toybox.Application as App;

enum 
{
	GREEN_BUTTON,
	RED_BUTTON,
	ADVANCE_HOLE,
	GREEN_MIN_MAX,
	RED_MIN_MAX,
	HOLE_NUMBER,
	TOTAL_SCORE
}

class GolfView extends Ui.View {

    var image;
    var height;
    var width;
    var initialized;
    var redCoords;
    var greenCoords;
    
	function initialize()
	{
		initialized = false;
	}

    //! Load your resources here
    function onLayout(dc) {
        image = Ui.loadResource(Rez.Drawables.id_monkey);
    }

    //! Restore the state of the app and prepare the view to be shown
    function onShow() {
    }

    //! Update the view
    function onUpdate(dc) {
    	// only initilize class variables once
    	if(!initialized) {
    		initializeTriangleCoords(dc);
    		initialized = true;
    	}
    	
        dc.setColor(Gfx.COLOR_WHITE, Gfx.COLOR_BLACK);
        dc.clear();
		
		dc.setColor(Gfx.COLOR_RED, Gfx.COLOR_TRANSPARENT);
		dc.fillPolygon(redCoords);
		
		dc.setColor(Gfx.COLOR_GREEN, Gfx.COLOR_TRANSPARENT);
		dc.fillPolygon(greenCoords);
		
		dc.setColor(Gfx.COLOR_WHITE, Gfx.COLOR_TRANSPARENT);
        dc.drawText( width / 4, ( 9 * height) / 16, Gfx.FONT_MEDIUM, "PAR", Gfx.TEXT_JUSTIFY_CENTER);
    }

    //! Called when this View is removed from the screen. Save the
    //! state of your app here.
    function onHide() {
    }
    
    //! Will iniitalize the class variables depending on the device context being used.
    function initializeTriangleCoords(dc){
    	width = dc.getWidth();
		height = dc.getHeight();
		
		// Red button
		var topx = width / 4;
		var topy = height / 16;
		
		var toplx = width /8;
		var toply = ( height * 4) / 16;
		var toprx = ( width * 3 ) / 8;
		var topry = ( height * 4 ) / 16;
		
		redCoords = [ [topx, topy], [toplx, toply], [toprx, topry] ];
		
		// Green button
		var botx = width / 4;
		var boty = ( height * 15 ) / 16;
		
		var botlx = width / 8;
		var botly = ( height * 12) / 16;
		var botrx = ( width * 3 ) / 8;
		var botry = ( height * 12 ) / 16;
		
		greenCoords = [ [botx, boty], [botlx, botly], [botrx, botry] ];
		
		var app = App.getApp();
		app.setProperty(GREEN_MIN_MAX, getGreenMinMax());
		app.setProperty(RED_MIN_MAX, getRedMinMax());
    }

	//! Will return an array of [xmin, xmax, ymin, ymax] for the green triangle.
	function getGreenMinMax()
	{
		var min_max = [greenCoords[1][0], greenCoords[2][0], greenCoords[1][1], greenCoords[0][1]];
		return min_max;
	}
	
	//! Will return an array of [xmin, xmax, ymin, ymax] for the red triangle.
	function getRedMinMax()
	{
		var min_max = [redCoords[1][0], redCoords[2][0], redCoords[0][1], redCoords[1][1]];
		return min_max;
	}
}

class GolfInputDelegate extends Ui.InputDelegate
{
	//! Called whenever the screen is clicked.
	function onTap(evt)
	{
		var app = App.getApp();
		var clickedCoords = evt.getCoordinates();
		Sys.println(clickedCoords.toString());
		
		var greenMinMax = app.getProperty(GREEN_MIN_MAX);
		var redMinMax = app.getProperty(RED_MIN_MAX);
		
		if(inBox(greenMinMax, clickedCoords))
		{
			app.setProperty(GREEN_BUTTON, 1);
		}
		else if(inBox(redMinMax, clickedCoords))
		{
			app.setProperty(RED_BUTTON, 1);
		}
		
        Ui.requestUpdate();
	}
	
	//! Returns true if the click coords are within the box coords passed in.
	function inBox(box, clickedCoords)
	{
		Sys.println(box[0]);
		if(clickedCoords[0] > box[0] && clickedCoords[0] < box[1])
		{
			if(clickedCoords[1] > box[2] && clickedCoords[1] < box[3])
			{
				return true;
			}
		}
		
		return false;
	}
}