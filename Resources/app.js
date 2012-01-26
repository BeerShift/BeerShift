var tabGroup = Ti.UI.createTabGroup();

var windowDrink = Ti.UI.createWindow({
	width : 320,
	height : 480,
	top : 0,
	left : 0,
	backgroundColor : 'black',
	title : 'BeerShift',
	barImage : 'navbar.png'
});

function createDetailWindow(e) {
	var windowBeerDetails = Ti.UI.createWindow({
		width : 320,
		height : 480,
		top : 0,
		left : 0,
		backgroundColor : 'black',
		title : 'Beer Details',
		barImage : 'navbar.png'
	});

	var detailsView = Ti.UI.createView({
		width : 320,
		height : windowBeerDetails.height - 134,
		left : 0,
		top : 0,
		backgroundColor : 'black',
		borderRadius : 5
	});

	// Let start adding our UI elements
	var beerImage = Titanium.UI.createImageView({
		image : 'pitcher.jpg',
		width : 80,
		height : 62,
		left : 10,
		top : 20
	});

	var labelBeerDetailName = Titanium.UI.createLabel({
		width : 'auto',
		height : 30,
		top : 40,
		left : 100,
		color : 'white',
		font : {
			fontSize : 14,
			fontFamily : 'Helvetica',
			fontWeight : 'bold'
		},
		text : e._title
	});
	var labelBreweryName = Titanium.UI.createLabel({
		width : 'auto',
		height : 30,
		top : 58,
		left : 100,
		color : 'white',
		font : {
			fontSize : 14,
			fontFamily : 'Helvetica',
			fontWeight : 'bold'
		},
		text : e._brewery
	});

	var textareaDescription = Titanium.UI.createTextArea({
		color : 'white',
		backgroundColor : 'black',
		value : e._description,
		height : 200,
		width : 300,
		top : 105,
		left : 10,
		font : {
			fontSize : 12,
			fontFamily : 'Helvetica',
			fontWeight : 'bold',
			color : 'white'
		},
		borderColor : '#000',
		editable : false
	});
	var labelDrinkTheBeer = Titanium.UI.createLabel({
		width : 'auto',
		height : 30,
		top : 320,
		left : 130,
		color : 'white',
		font : {
			fontSize : 14,
			fontFamily : 'Helvetica',
			fontWeight : 'bold'
		},
		text : 'Drink It!'
	});

	labelDrinkTheBeer.addEventListener('click', function(e) {
		Ti.API.info(Ti.App.Properties.getString('username') + " just drank a beer (" + labelBeerDetailName.text + ")");

		var now = new Date();

		// Post the data to our database
		var drinkPostURL = 'http://localhost/api/beers/';
		var postRequest = Ti.Network.createHTTPClient();
		postRequest.open('POST', drinkPostURL);
		postRequest.send({
			username : Ti.App.Properties.getString('username'),
			beerName : labelBeerDetailName.text,
			when	: dateFormat(now, "dddd, mmmm dS, yyyy, h:MM:ss TT")
		});

		tabGroup.setActiveTab(1);
	});
	detailsView.add(labelDrinkTheBeer);
	detailsView.add(labelBeerDetailName);
	detailsView.add(labelBreweryName);
	detailsView.add(beerImage);
	detailsView.add(textareaDescription);
	windowBeerDetails.add(detailsView);

	return windowBeerDetails;
}

var view = Ti.UI.createView({
	width : 320,
	height : windowDrink.height - 134,
	left : 0,
	top : 0,
	backgroundColor : 'black',
	borderRadius : 5
});

//define our table view

var labelBeerName = Titanium.UI.createLabel({
	width : 'auto',
	height : 30,
	top : 20,
	left : 10,
	color : 'white',
	font : {
		fontSize : 14,
		fontFamily : 'Helvetica',
		fontWeight : 'bold'
	},
	text : 'Beer Name: '
});
view.add(labelBeerName);

var tfBeerName = Ti.UI.createTextField({
	width : 200,
	height : 30,
	top : 20,
	right : 0,
	font : {
		fontSize : 14,
		fontFamily : 'Helvetica',
		fontWeight : 'bold'
	},
	borderStyle : Ti.UI.INPUT_BORDERSTYLE_ROUNDED,
	returnKeyType : Ti.UI.RETURNKEY_DONE,
	hintText : 'What am I drinking?'
});
tfBeerName.addEventListener('return', function(e) {
	populateTableWithBeer(e.value);
});
view.add(tfBeerName);

function populateTableWithBeer(beerName) {

	var data = [];

	var tblBeers = Titanium.UI.createTableView({
		height : 380,
		width : 320,
		top : 55,
		left : 5,
		rowHeight : 35,
		borderRadius : 5,
		data : data
	});
	view.add(tblBeers);
	var data = [];
	var pintlabURL = "http://localhost/api/beers/name/" + beerName;
	var request = Titanium.Network.createHTTPClient();
	request.open('GET', pintlabURL);
	request.send();
	//this method will process the remote data
	request.onload = function() {
		//create a json object using the JSON.PARSE function
		var response = JSON.parse(request.responseText);

		//loop each item in the json object
		for(var i = 0; i < response.data.length; i++) {
			//create a table row
			var row = Titanium.UI.createTableViewRow({
				hasChild : true,
				className : 'recipe-row',
				backgroundColor : '#fff',
				_title : response.data[i].name,
				_description : response.data[i].description,
				_brewery : response.data[i].breweries[0].name
			});
			//title label
			var titleLabel = Titanium.UI.createLabel({
				text : response.data[i].name,
				font : {
					fontSize : 14,
					fontWeight : 'bold'
				},
				left : 50,
				top : 5,
				height : 20,
				width : 210,
				color : '#000'
			});
			row.add(titleLabel);

			//add our little icon to the left of the row
			var iconImage = Titanium.UI.createImageView({
				image : 'beer-icon.png',
				width : 24,
				height : 24,
				left : 10,
				top : 5
			});
			row.add(iconImage);

			//add the table row to our data[] object
			data.push(row);
		}

		//finally, set the data property of the tableView to our data[] object
		tblBeers.visible = false;
		tblBeers.setData(data);
		tblBeers.addEventListener('click', function(e) {
			drinkTab.open(createDetailWindow(e.rowData))
		});
		tblBeers.visible = true;
	}
}

//view.add(tblBeers);

windowDrink.add(view);

var drinkTab = Ti.UI.createTab({
	icon : 'icon-drink.png',
	title : 'Drink',
	window : windowDrink
});
var windowDrank = Ti.UI.createWindow({
	width : 320,
	height : 480,
	top : 0,
	left : 0,
	backgroundColor : "black",
	url : 'drankWindow.js',
	title : 'Drank',
	barImage : 'navbar.png'
});

var windowFirehose = Ti.UI.createWindow({
	width : 320,
	height : 480,
	top : 0,
	left : 0,
	backgroundColor : "black",
	url : 'firehoseWindow.js',
	title : 'Firehose',
	barImage : 'navbar.png'
});

var drankTab = Ti.UI.createTab({
	icon : 'icon-drank.png',
	title : 'Drank',
	window : windowDrank
});

var windowSettings = Ti.UI.createWindow({
	width : 320,
	height : 480,
	top : 0,
	left : 0,
	backgroundColor : "black",
	url : 'settingsWindow.js',
	title : 'Settings',
	barImage : 'navbar.png',
	mainTabGroup : tabGroup
});

var fireHouseTab = Ti.UI.createTab({
	icon : 'icon-firehose.png',
	title : 'Fire Hose',
	window : windowFirehose
});

var settingsTab = Ti.UI.createTab({
	icon : 'icon_settings.png',
	title : 'Settings',
	window : windowSettings
});

tabGroup.addTab(drinkTab);
tabGroup.addTab(drankTab);
tabGroup.addTab(fireHouseTab);
tabGroup.addTab(settingsTab);

//Determine if we need to set the settings tab as the default if the user has not logged in
if(Ti.App.Properties.getString("username") == null || Ti.App.Properties.getString("username").length < 1) {
	tabGroup.setActiveTab(3);
}

tabGroup.open();



var dateFormat = function () {
	var	token = /d{1,4}|m{1,4}|yy(?:yy)?|([HhMsTt])\1?|[LloSZ]|"[^"]*"|'[^']*'/g,
		timezone = /\b(?:[PMCEA][SDP]T|(?:Pacific|Mountain|Central|Eastern|Atlantic) (?:Standard|Daylight|Prevailing) Time|(?:GMT|UTC)(?:[-+]\d{4})?)\b/g,
		timezoneClip = /[^-+\dA-Z]/g,
		pad = function (val, len) {
			val = String(val);
			len = len || 2;
			while (val.length < len) val = "0" + val;
			return val;
		};

	// Regexes and supporting functions are cached through closure
	return function (date, mask, utc) {
		var dF = dateFormat;

		// You can't provide utc if you skip other args (use the "UTC:" mask prefix)
		if (arguments.length == 1 && Object.prototype.toString.call(date) == "[object String]" && !/\d/.test(date)) {
			mask = date;
			date = undefined;
		}

		// Passing date through Date applies Date.parse, if necessary
		date = date ? new Date(date) : new Date;
		if (isNaN(date)) throw SyntaxError("invalid date");

		mask = String(dF.masks[mask] || mask || dF.masks["default"]);

		// Allow setting the utc argument via the mask
		if (mask.slice(0, 4) == "UTC:") {
			mask = mask.slice(4);
			utc = true;
		}

		var	_ = utc ? "getUTC" : "get",
			d = date[_ + "Date"](),
			D = date[_ + "Day"](),
			m = date[_ + "Month"](),
			y = date[_ + "FullYear"](),
			H = date[_ + "Hours"](),
			M = date[_ + "Minutes"](),
			s = date[_ + "Seconds"](),
			L = date[_ + "Milliseconds"](),
			o = utc ? 0 : date.getTimezoneOffset(),
			flags = {
				d:    d,
				dd:   pad(d),
				ddd:  dF.i18n.dayNames[D],
				dddd: dF.i18n.dayNames[D + 7],
				m:    m + 1,
				mm:   pad(m + 1),
				mmm:  dF.i18n.monthNames[m],
				mmmm: dF.i18n.monthNames[m + 12],
				yy:   String(y).slice(2),
				yyyy: y,
				h:    H % 12 || 12,
				hh:   pad(H % 12 || 12),
				H:    H,
				HH:   pad(H),
				M:    M,
				MM:   pad(M),
				s:    s,
				ss:   pad(s),
				l:    pad(L, 3),
				L:    pad(L > 99 ? Math.round(L / 10) : L),
				t:    H < 12 ? "a"  : "p",
				tt:   H < 12 ? "am" : "pm",
				T:    H < 12 ? "A"  : "P",
				TT:   H < 12 ? "AM" : "PM",
				Z:    utc ? "UTC" : (String(date).match(timezone) || [""]).pop().replace(timezoneClip, ""),
				o:    (o > 0 ? "-" : "+") + pad(Math.floor(Math.abs(o) / 60) * 100 + Math.abs(o) % 60, 4),
				S:    ["th", "st", "nd", "rd"][d % 10 > 3 ? 0 : (d % 100 - d % 10 != 10) * d % 10]
			};

		return mask.replace(token, function ($0) {
			return $0 in flags ? flags[$0] : $0.slice(1, $0.length - 1);
		});
	};
}();

// Some common format strings
dateFormat.masks = {
	"default":      "ddd mmm dd yyyy HH:MM:ss",
	shortDate:      "m/d/yy",
	mediumDate:     "mmm d, yyyy",
	longDate:       "mmmm d, yyyy",
	fullDate:       "dddd, mmmm d, yyyy",
	shortTime:      "h:MM TT",
	mediumTime:     "h:MM:ss TT",
	longTime:       "h:MM:ss TT Z",
	isoDate:        "yyyy-mm-dd",
	isoTime:        "HH:MM:ss",
	isoDateTime:    "yyyy-mm-dd'T'HH:MM:ss",
	isoUtcDateTime: "UTC:yyyy-mm-dd'T'HH:MM:ss'Z'"
};

// Internationalization strings
dateFormat.i18n = {
	dayNames: [
		"Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat",
		"Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"
	],
	monthNames: [
		"Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec",
		"January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"
	]
};

// For convenience...
Date.prototype.format = function (mask, utc) {
	return dateFormat(this, mask, utc);
};