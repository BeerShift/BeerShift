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
	var APIurl = APIHost + "beers/name/" + beerName;
	var request = Titanium.Network.createHTTPClient();
	request.open('GET', APIurl);
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
				image : 'images/icon-beer.png',
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