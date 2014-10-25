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
		var width = dc.getWidth();
		var height = dc.getHeight();
		
		var topx = width / 4;
		var topy = height / 16;
		
		var toplx = width /8;
		var toply = ( height * 4) / 16;
		var toprx = ( width * 3 ) / 8;
		var topry = ( height * 4 ) / 16;
		
		var top = [ [topx, topy], [toplx, toply], [toprx, topry] ];
		
		dc.setColor(Gfx.COLOR_RED, Gfx.COLOR_TRANSPARENT);
		dc.fillPolygon(top);
		
		var botx = width / 4;
		var boty = ( height * 15 ) / 16;
		
		var botlx = width / 8;
		var botly = ( height * 12) / 16;
		var botrx = ( width * 3 ) / 8;
		var botry = ( height * 12 ) / 16;
		
		dc.setColor(Gfx.COLOR_GREEN, Gfx.COLOR_TRANSPARENT);
		var bot = [ [botx, boty], [botlx, botly], [botrx, botry] ];
		
		dc.fillPolygon(bot);
		
		dc.setColor(Gfx.COLOR_WHITE, Gfx.COLOR_TRANSPARENT);
        dc.drawText( width / 4, ( 9 * height) / 16, Gfx.FONT_MEDIUM, "PAR", Gfx.TEXT_JUSTIFY_CENTER);
        //dc.drawBitmap(5, 30, image);
    }

    //! Called when this View is removed from the screen. Save the
    //! state of your app here.
    function onHide() {
    }

}