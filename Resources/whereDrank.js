function createDrankDetailWindow(e) {
	var windowBeerDetails = Ti.UI.createWindow({
		width : 320,
		height : 480,
		top : 0,
		left : 0,
		backgroundColor : 'black',
		title : L('winBeerDetails'),
		barImage : 'images/navbar.png'
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
	var labelWhenDrank = Titanium.UI.createLabel({
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
		text : e._when
	});
	
	// Add our UI elements to our view
	var beerAnnotation = Titanium.Map.createAnnotation({
		latitude : 41.88925,
		longitude : -87.632638,
		title : e._title,
		subtitle : e._when,
		pincolor : Titanium.Map.ANNOTATION_RED,
		animate : true
	});

	var mapview = Titanium.Map.createView({
		top : 110,
		height : 350,
		mapType : Titanium.Map.STANDARD_TYPE,
		region : {
			latitude : 41.88925,
			longitude : -87.632638,
			latitudeDelta : 0.5,
			longitudeDelta : 0.5
		},
		animate : true,
		regionFit : true,
		userLocation : true,
		annotations:[beerAnnotation]
	});
	detailsView.add(mapview);

	detailsView.add(labelBeerDetailName);
	detailsView.add(labelWhenDrank);
	detailsView.add(beerImage);
	windowBeerDetails.add(detailsView);

	return windowBeerDetails;
}