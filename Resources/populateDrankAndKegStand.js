function populateTableWithBeer(windowType) {
	var labelLoading = Titanium.UI.createLabel({
	width : 'auto',
	height : 30,
	top : 20,
	left : 50,
	color : 'white',
	font : {
		fontSize : 14,
		fontFamily : 'Helvetica',
		fontWeight : 'bold'
	},
	text : 'Loading......'
});

view.add(labelLoading);
	var data = [];

	var tblBeers = Titanium.UI.createTableView({
		height : 340,
		width : 300,
		top : 0,
		left : 5,
		rowHeight : 35,
		borderRadius : 5,
		data : data
	});
	
	var APIurl = APIHost + "firehose/";
	
	if (windowType == 'drank') {
		APIurl = APIHost + "userbeers/username/" + Ti.App.Properties.getString("username");
	} 
	var request = Titanium.Network.createHTTPClient();
	request.open('GET', APIurl);
	request.send();
	//this method will process the remote data
	request.onload = function() {
		labelLoading.visible = true;
		tblBeers.visible = false;
		//create a json object using the JSON.PARSE function
		var response = JSON.parse(request.responseText);

		//loop each item in the json object
		for(var i = 0; i < response.length; i++) {
			//create a table row
			var row = Titanium.UI.createTableViewRow({
				hasChild : true,
				className : 'recipe-row',
				backgroundColor : '#fff',
				_beerName : response[i].beer,
				_when : response[i].when,
				_title: response[i].beer
			});
			//title label
			var titleLabelText = response[i].username + " drank " + response[i].beer;
			if (windowType == 'drank') {
				titleLabelText = response[i].beer;
			} 
			var titleLabel = Titanium.UI.createLabel({
				text : titleLabelText,
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

			//add our icon to the left of the row
			var iconImage = Titanium.UI.createImageView({
				image : 'images/icon-beer.png',
				width : 24,
				height : 24,
				left : 10,
				top : 5
			});
			row.add(iconImage);

			var whenLabel = Titanium.UI.createLabel({
				text : response[i].when,
				font : {
					fontSize : 10,
					fontWeight : 'normal'
				},
				left : 50,
				top : 17,
				height : 20,
				width : 200,
				color : '#000'
			});
			row.add(whenLabel);
			//add the table row to our data[] object
			data.push(row);
		}

		//finally, set the data property of the tableView to our data[] object
		
		tblBeers.visible = false;
		tblBeers.setData(data);
		tblBeers.addEventListener('click', function(e) {
			Ti.UI.currentTab.open(createDrankDetailWindow(e.rowData))
		});
		if(tblBeers.getData().length > 0) {
			view.add(tblBeers);
			labelLoading.visible = false;
			tblBeers.visible = true;
		}
	}
}


