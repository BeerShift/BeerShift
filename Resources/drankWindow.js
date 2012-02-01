//reference the current window
var drankWindow = Titanium.UI.currentWindow;

// get the tabGroup
var tabGroup = Ti.UI.currentWindow.tabGroup;

// get REST API host url
var APIHost = Ti.App.Properties.getString('APIHost');
Ti.include('whereDrank.js');
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

drankWindow.add(view);
drankWindow.addEventListener('focus', function(e) {
	populateTableWithBeer('drank');
});
