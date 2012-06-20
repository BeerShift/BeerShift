// include our javascript dateFormat function
Ti.include('dateFormat.js');

// create the initial tabGroup that is displayed at the bottom on the UI
var tabGroup = Ti.UI.createTabGroup();

// define our BeerShift REST API host
var APIHost = Ti.App.Properties.getString('APIHost');
if (APIHost == null) {
	APIHost = 'http://beershift.onopenshift.com/index.php/api/'; //http://beershift-mjelenrh.rhcloud.com/
	Ti.App.Properties.setString('APIHost', APIHost);
};

// define our main window that will users to search for Beers
var DrinkWindow = require('drinkWindow'),
	windowDrink = new DrinkWindow(),
	drinkTab = Ti.UI.createTab({
		icon: 'images/icon-drink.png',
		title: L('tabDrink'),
		window: windowDrink
	});
windowDrink.containingTab = drinkTab;

var DrankWindow = require('drankWindow'),
	windowDrank = new DrankWindow(),
	drankTab = Ti.UI.createTab({
		icon: 'images/icon-drank.png',
		title: L('tabDrank'),
		window: windowDrank
	});
windowDrank.containingTab = drankTab;
	
var FirehoseWindow = require('firehoseWindow'),
	windowFirehose = new FirehoseWindow(),
	fireHoseTab = Ti.UI.createTab({
		icon: 'images/icon-firehose.png',
		title: L('tabFireHouse'),
		window: windowFirehose
	});
windowFirehose.containingTab = fireHoseTab;

var WinSettings = require('settingsWindow'),
	windowSettings = new WinSettings();
	settingsTab = Ti.UI.createTab({
		icon: 'images/icon-settings.png',
		title: L('tabSettings'),
		window: windowSettings
	});
windowSettings.containingTab = settingsTab;

// Add all of our tabs to our tabGroup
tabGroup.addTab(drinkTab);
tabGroup.addTab(drankTab);
tabGroup.addTab(fireHoseTab);
tabGroup.addTab(settingsTab);

//Determine if we need to set the settings tab as the default if the user has not logged in
if (Ti.App.Properties.getString("username") == null || Ti.App.Properties.getString("username").length < 1) {
	tabGroup.setActiveTab(3);
}


// Open the tabGroup so that it display to the user
tabGroup.open();
