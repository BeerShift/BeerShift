//reference the current window
var firehoseWindow = Titanium.UI.currentWindow;

// get the tabGroup
var tabGroup = Ti.UI.currentWindow.tabGroup;
var APIHost = Ti.App.Properties.getString('APIHost');
Ti.include('populateDrankAndKegStand.js');
//create the view, this will hold all of our UI controls
var view = Titanium.UI.createView({
	width : 300,
	height : 400,
	left : 10,
	top : 10,
	backgroundColor : 'black',
	borderRadius : 5
});

firehoseWindow.add(view);
firehoseWindow.addEventListener('focus', function(e) {
	populateTableWithBeer('kegstand');
});
