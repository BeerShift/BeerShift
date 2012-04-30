// include our javascript dateFormat function
Ti.include('dateFormat.js');
Ti.include('detailWindow.js');
Ti.include('populateTableWithBeer.js');

// create the initial tabGroup that is displayed at the bottom on the UI
var tabGroup = Ti.UI.createTabGroup();

// define our BeerShift REST API host
var APIHost = Ti.App.Properties.getString('APIHost');
if(APIHost == null){
	APIHost = 'http://beershift.onopenshift.com/index.php/api/'; //http://beershift-mjelenrh.rhcloud.com/
	Ti.App.Properties.setString('APIHost', APIHost);
};

// define our main window that will users to search for Beers
var windowDrink = Ti.UI.createWindow({
	backgroundColor : 'black',
	title : L('winDrink'),
	barImage : 'images/navbar.png'
});

// Define our primary view for the DrinkWindow
var view = Ti.UI.createView({
	backgroundColor : 'black',
	borderRadius : 5,
});

// create our search label
var labelBeerName = Titanium.UI.createLabel({
	top: 20,
	left: 10,
	color : 'white',
	font : {
		fontFamily : 'Helvetica',
		fontWeight : 'bold'
	},
	text : L('lblBeerName')
});
// Add our search label to the view we created above
//view.add(labelBeerName);

// Creata a textfield to allow the user to input a beer name and place it next the label field
var tfBeerName = Ti.UI.createTextField({
	width: "95%",
	top: 10,
	borderStyle : Ti.UI.INPUT_BORDERSTYLE_ROUNDED,
	font : {
		fontFamily : 'Helvetica',
		fontWeight : 'bold'
	},
	returnKeyType : Ti.UI.RETURNKEY_SEARCH,
	hintText : L('tfBeerName')
});

// Add an event listener so when the user enters return or done
// we call the populateTableWithBeer function to make the REST calls
tfBeerName.addEventListener('return', function(e) {
	// this function is included from the populateTableWithBeer.js file
	populateTableWithBeer(e.value);
});
// add our textfield to the view
view.add(tfBeerName);

// Add our view to the window
windowDrink.add(view);

// Create our tabs and subwindows
var drinkTab = Ti.UI.createTab({
	icon : 'images/icon-drink.png',
	title : L('tabDrink'),
	window : windowDrink
});
var windowDrank = Ti.UI.createWindow({
	width : 320,
	height : 480,
	top : 0,
	left : 0,
	backgroundColor : "black",
	url : 'drankWindow.js',
	title : L('winDrank'),
	barImage : 'images/navbar.png'
});
var windowFirehose = Ti.UI.createWindow({
	width : 320,
	height : 480,
	top : 0,
	left : 0,
	backgroundColor : "black",
	url : 'firehoseWindow.js',
	title : L('winFirehose'),
	barImage : 'images/navbar.png'
});
var drankTab = Ti.UI.createTab({
	icon : 'images/icon-drank.png',
	title : L('tabDrank'),
	window : windowDrank
});
var windowSettings = Ti.UI.createWindow({
	width : 320,
	height : 480,
	top : 0,
	left : 0,
	backgroundColor : "black",
	url : 'settingsWindow.js',
	title : L('winSettings'),
	barImage : 'images/navbar.png',
	mainTabGroup : tabGroup
});
var fireHouseTab = Ti.UI.createTab({
	icon : 'images/icon-firehose.png',
	title : L('tabFireHouse'),
	window : windowFirehose
});
var settingsTab = Ti.UI.createTab({
	icon : 'images/icon-settings.png',
	title : L('tabSettings'),
	window : windowSettings
});

// Add all of our tabs to our tabGroup
tabGroup.addTab(drinkTab);
tabGroup.addTab(drankTab);
tabGroup.addTab(fireHouseTab);
tabGroup.addTab(settingsTab);

//Determine if we need to set the settings tab as the default if the user has not logged in
if(Ti.App.Properties.getString("username") == null || Ti.App.Properties.getString("username").length < 1) {
	tabGroup.setActiveTab(3);
}

// Open the tabGroup so that it display to the user
tabGroup.open();
