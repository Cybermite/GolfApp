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
    var holeTracker;
    
	function initialize()
	{
		holeTracker = new HoleTracker();
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
		updateScore();
		var app = App.getApp();
		
		var scoreString = holeTracker.getScoreString();
		var totalScore = holeTracker.getTotalScore();
		//app.getProperty(TOTAL_SCORE);
		
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
		
		var prefix = "+";
		if(totalScore < 0){
			prefix = "-";
		}
		
		dc.setColor(Gfx.COLOR_WHITE, Gfx.COLOR_TRANSPARENT);
        dc.drawText( width / 4, ( 9 * height) / 16, Gfx.FONT_MEDIUM, scoreString, Gfx.TEXT_JUSTIFY_CENTER);
        dc.drawText( ( width *3 ) / 4, height / 2, Gfx.FONT_LARGE, prefix + totalScore, Gfx.TEXT_JUSTIFY_CENTER);
}

	//! increments or decremements the score depending on which button is pressed.
	function updateScore()
	{
		var app = App.getApp();
		if(app.getProperty(GREEN_BUTTON))
		{
			app.setProperty(GREEN_BUTTON, false);
			holeTracker.incrementScore();
		}
		else if(app.getProperty(RED_BUTTON))
		{
			app.setProperty(RED_BUTTON, false);
			holeTracker.decrementScore();
		}
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


class HoleTracker
{
	var holeNumber;
	var score;
	var scoreString;
	var scoreIndex;
	
	function initialize(){
		holeNumber = 1;
		score = [ "ALBATROSS", "EAGLE", "BIRDIE", "PAR", "BOGIE", "DOUBLE", "TRIPLE" ];
		scoreIndex = 3;
		scoreString = score[scoreIndex];
		var app = App.getApp();
		app.setProperty(TOTAL_SCORE, 0);
	}

	function getScoreString(){
		if(scoreIndex < 0){
			var returnVal = "CHEATER";
			scoreIndex = 0;
			return returnVal;
		}
		else if(scoreIndex > 6){
			var returnVal = "+" + (scoreIndex - 3);
			return returnVal;
		}
		else{
			return score[scoreIndex];
		}
	}
	
	function advanceHole(){
		var app = app.getApp();
		var curHole = app.getProperty(HOLE_NUMBER);
		app.setProperty(HOLE_NUMBER, curHole + 1);
		var curTotal = app.getProperty(TOTAL_SCORE);
		app.setProperty(TOTAL_SCORE, curTotal + getHoleScore());
	}
	
	function getHoleScore(){
		return scoreIndex - 3;
	}
	
	function getTotalScore(){
		var app = App.getApp();
		return app.getProperty(TOTAL_SCORE);
	}
	
	function incrementScore(){
		scoreIndex = scoreIndex - 1;
	}
	
	function decrementScore(){
		scoreIndex = scoreIndex + 1;
	}
}

class GolfInputDelegate extends Ui.InputDelegate
{
	//! Called whenever the screen is clicked.
	function onTap(evt)
	{
		var app = App.getApp();
		var clickedCoords = evt.getCoordinates();
		var greenMinMax = app.getProperty(GREEN_MIN_MAX);
		var redMinMax = app.getProperty(RED_MIN_MAX);
		
		if(inBox(greenMinMax, clickedCoords))
		{
			app.setProperty(GREEN_BUTTON, true);
		}
		else if(inBox(redMinMax, clickedCoords))
		{
			app.setProperty(RED_BUTTON, true);
		}
		
        Ui.requestUpdate();
	}
	
	//! Returns true if the click coords are within the box coords passed in.
	function inBox(box, clickedCoords)
	{
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