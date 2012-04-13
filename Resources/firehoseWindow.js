//reference the current window
var firehoseWindow = Titanium.UI.currentWindow;

// get the tabGroup
var tabGroup = Ti.UI.currentWindow.tabGroup;
var APIHost = Ti.App.Properties.getString('APIHost');
Ti.include('whereDrank.js');
Ti.include('populateDrankAndKegStand.js');

//create the view, this will hold all of our UI controls
var view = Titanium.UI.createView({
	width : '95%',
	left : 10,
	top : 10,
	backgroundColor : 'black',
	borderRadius : 5,
	layout: 'horizontal'
});

var reloadButton = Titanium.UI.createButton({
	top: 10,
	title: 'Reload',
	backgroundColor: '#FFF'
});

var data = [];

var tblBeers = Titanium.UI.createTableView({
	top: 20,
	width : '100%',
	rowHeight : 35,
	borderRadius : 5,
	data : data
});

reloadButton.addEventListener('click', function(e){
	populateTableWithBeer('kegstand', data);
});

view.add(reloadButton)

firehoseWindow.add(view);

populateTableWithBeer('kegstand', data);