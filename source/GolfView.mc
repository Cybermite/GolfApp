using Toybox.WatchUi as Ui;
using Toybox.Graphics as Gfx;

class GolfView extends Ui.View {

    var image;

    //! Load your resources here
    function onLayout(dc) {
        image = Ui.loadResource(Rez.Drawables.id_monkey);
    }

    //! Restore the state of the app and prepare the view to be shown
    function onShow() {
    }

    //! Update the view
    function onUpdate(dc) {
        dc.setColor(Gfx.COLOR_WHITE, Gfx.COLOR_BLACK);
        dc.clear();
		dc.setColor(Gfx.COLOR_RED, Gfx.COLOR_TRANSPARENT);
		var width = dc.getWidth();
		var height = dc.getHeight();
		
		var topx = width / 4;
		var topy = height / 8;
		
		var toplx = width /8;
		var toply = ( height * 3) / 8;
		var toprx = ( width * 3 ) / 8;
		var topry = ( height * 3 ) / 8;
		
		var top = [ [topx, topy], [toplx, toply], [toprx, topry] ];
		
		dc.fillPolygon(top);
        //dc.drawText(5, 20, Gfx.FONT_MEDIUM, "Click the menu button", Gfx.TEXT_JUSTIFY_LEFT);
        //dc.drawBitmap(5, 30, image);
    }

    //! Called when this View is removed from the screen. Save the
    //! state of your app here.
    function onHide() {
    }

}