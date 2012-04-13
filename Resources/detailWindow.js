function createDetailWindow(e) {
	var windowBeerDetails = Ti.UI.createWindow({
		top : 0,
		left : 0,
		backgroundColor : 'black',
		title : L('winBeerDetails'),
		barImage : 'images/navbar.png'
	});

	var detailsView = Ti.UI.createView({
		height : windowBeerDetails.height - 134,
		left : 0,
		top : 0,
		backgroundColor : 'black',
		borderRadius : 5
	});

	// Let start adding our UI elements
	var beerImage = Titanium.UI.createImageView({
		image : 'images/pitcher.jpg',
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
		width : '95%',
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
		top : 320,
		left : 115,
		color : 'white',
		font : {
			fontSize : 26,
			fontFamily : 'Helvetica',
			fontWeight : 'bold'
		},
		text : L('lblDrinkTheBeer')
	});

	labelDrinkTheBeer.addEventListener('click', function(e) {
		var now = new Date();

		// Post the data to our database
		var drinkPostURL = APIHost + 'beers/';
		var postRequest = Ti.Network.createHTTPClient();
		postRequest.open('POST', drinkPostURL);
		postRequest.send({
			username : Ti.App.Properties.getString('username'),
			beerName : labelBeerDetailName.text,
			when : dateFormat(now, "mmmm dS, yyyy, h:MM:ss TT"),

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