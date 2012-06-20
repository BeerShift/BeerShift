function DrankDetailWindow(e) {
	var windowBeerDetails = Ti.UI.createWindow({
		width: "100%",
		height: 480,
		top: 0,
		left: 0,
		backgroundColor: 'black',
		title: L('winBeerDetails'),
		barImage: 'images/navbar.png'
	});

	var detailsView = Ti.UI.createView({
		width: 320,
		height: windowBeerDetails.height - 134,
		left: 0,
		top: 0,
		backgroundColor: 'black',
		borderRadius: 5
	});

	// Let start adding our UI elements
	var beerImage = Titanium.UI.createImageView({
		image: 'images/pitcher.jpg',
		width: 80,
		height: 62,
		left: 10,
		top: 20
	});

	var labelBeerDetailName = Titanium.UI.createLabel({
		width: 'auto',
		height: 30,
		top: 40,
		left: 100,
		color: 'white',
		font: {
			fontSize: 14,
			fontFamily: 'Helvetica',
			fontWeight: 'bold'
		},
		text: e._title
	});
	var labelWhenDrank = Titanium.UI.createLabel({
		width: 'auto',
		height: 30,
		top: 58,
		left: 100,
		color: 'white',
		font: {
			fontSize: 14,
			fontFamily: 'Helvetica',
			fontWeight: 'bold'
		},
		text: e._when
	});
	
	// Add our UI elements to our view

	detailsView.add(labelBeerDetailName);
	detailsView.add(labelWhenDrank);
	detailsView.add(beerImage);
	windowBeerDetails.add(detailsView);

	return windowBeerDetails;
};

module.exports = DrankDetailWindow;