function DrinkWindow() {
	var self = Ti.UI.createWindow({
		backgroundColor: 'black',
		title: L('winDrink'),
		barImage: 'images/navbar.png',
		layout: 'vertical'
	}),	
		// Creata a textfield to allow the user to input a beer name and place it next the label field
		tfBeerName = Ti.UI.createTextField({
			width: "95%",
			top: 10,
			borderStyle: Ti.UI.INPUT_BORDERSTYLE_ROUNDED,
			font: {
				fontFamily: 'Helvetica',
				fontWeight: 'bold'
			},
			returnKeyType: Ti.UI.RETURNKEY_SEARCH,
			hintText: L('tfBeerName')
		}),
		DetailWin = require('detailWindow');
	
	// add our textfield to the view
	self.add(tfBeerName);
	
	var data = [],
		tblBeers = Titanium.UI.createTableView({
			width: "95%",
			height:"75%",
			top: 25,
			rowHeight: 35,
			borderRadius: 5,
			data: data
		});
	self.add(tblBeers);
	
	// Add an event listener so when the user enters return or done
	// we call the populateTableWithBeer function to make the REST calls
	tfBeerName.addEventListener('return', function(e) {
		// this function is included from the populateTableWithBeer.js file
		
		var APIurl = APIHost + "beers/name/" + escape(e.value);
		var request = Titanium.Network.createHTTPClient();
		request.open('GET', APIurl);
		request.send();
		//this method will process the remote data
		request.onload = function() {
			//create a json object using the JSON.PARSE function
			var response = JSON.parse(request.responseText),
				len = response.data.length,
				data = [];
	
			//loop each item in the json object
			for (var i = 0; i < len; i++) {
				//create a table row
				var row = Titanium.UI.createTableViewRow({
					hasChild: true,
					className: 'recipe-row',
					backgroundColor: '#fff',
					_title: response.data[i].name,
					_description: response.data[i].description,
					_brewery: response.data[i].breweries[0].name
				});
				//title label
				var titleLabel = Titanium.UI.createLabel({
					text: response.data[i].name,
					font: {
						fontSize: 14,
						fontWeight: 'bold'
					},
					left: 50,
					top: 10,
					height: 20,
					width: 210,
					color: '#000'
				});
				row.add(titleLabel);
	
				//add our little icon to the left of the row
				var iconImage = Titanium.UI.createImageView({
					image: 'images/icon-beer.png',
					width: 24,
					height: 24,
					left: 10,
					top: 5
				});
				row.add(iconImage);
	
				//add the table row to our data[] object
				data.push(row);
			}
	
			//finally, set the data property of the tableView to our data[] object
			tblBeers.setData(data);
			tblBeers.visible = true;
			tblBeers.addEventListener('click', function(e) {
				var detailWin = new DetailWin(e.rowData);
				self.containingTab.open(detailWin);
			});
		}
	});
	
	return self;
};

module.exports = DrinkWindow;
