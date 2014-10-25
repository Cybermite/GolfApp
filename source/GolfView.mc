using Toybox.WatchUi as Ui;
using Toybox.Graphics as Gfx;
using Toybox.System as Sys;

class GolfView extends Ui.View {

    var image;
    var height;
    var width;
    var initialized;
    var redCoords;
    var greenCoords;
    
	function initialize(dc)
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
    }

    //! Called when this View is removed from the screen. Save the
    //! state of your app here.
    function onHide() {
    }
    
    function initializeTriangleCoords(dc){
    	width = dc.getWidth();
		height = dc.getHeight();
		
		var topx = width / 4;
		var topy = height / 8;
		
		var toplx = width /8;
		var toply = ( height * 3) / 8;
		var toprx = ( width * 3 ) / 8;
		var topry = ( height * 3 ) / 8;
		
		redCoords = [ [topx, topy], [toplx, toply], [toprx, topry] ];
		
		var botx = ( width * 3 ) / 4;
		var boty = ( height * 7 ) / 8;
		
		var botlx = width /8;
		var botly = ( height * 7) / 8;
		var botrx = ( width * 3 ) / 8;
		var botry = ( height * 7 ) / 8;
		
		
		greenCoords = [ [botx, boty], [botlx, botly], [botrx, botry] ];
    }

	function getTriangleCoords()
	{
		
	}
}

class GolfInputDelegate extends Ui.InputDelegate
{
	function onTap(evt)
	{
		var coords = evt.getCoordinates();
		Sys.println(coords.toString());
		
        Ui.requestUpdate();
	}
}