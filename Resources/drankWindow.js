function DrankWindow() {
	//reference the current window
	var self = Ti.UI.createWindow({
		backgroundColor: "black",
		title: L('winDrank'),
		barImage: 'images/navbar.png',
		layout:'vertical'
	});
	
	// get the tabGroup
	var tabGroup = self.tabGroup;
	var DrankDetailWindow = require('whereDrank');
	
	function populateTableWithBeer(windowType, data) {
		var APIurl = APIHost + "firehose/";
		
		if (windowType == 'drank') {
			APIurl = APIHost + "userbeers/username/" + Ti.App.Properties.getString("username");
		};
		
		Ti.API.info(APIurl);
		var request = Titanium.Network.createHTTPClient();
		request.open('GET', APIurl);
		request.send();
		
		request.onerror = function(e) {
			Ti.API.error(JSON.stringify(e));
			alert("ERROR: Unable to retrieve your drank list. Try drinking a beer first?");
		};
		
		//this method will process the remote data
		request.onload = function() {			
			//create a json object using the JSON.PARSE function
			var responseData = request.responseText;
			var response = JSON.parse(responseData);
			
			data = [];
	
			//loop each item in the json object
			for(var i = 0; i < response.length; i++) {
				//create a table row
				var row = Titanium.UI.createTableViewRow({
					hasChild: true,
					className: 'recipe-row',
					backgroundColor: '#fff',
					_beerName: response[i].beer,
					_when: response[i].when,
					_title: response[i].beer
				});
				//title label
				var titleLabelText = response[i].username + " " + L('titleLabelText') + " " + response[i].beer;
				if (windowType == 'drank') {
					titleLabelText = response[i].beer;
				} 
				var titleLabel = Titanium.UI.createLabel({
					text: titleLabelText,
					font: {
						fontSize: 14,
						fontWeight: 'bold'
					},
					left: 50,
					top: 5,
					height: 20,
					width: 210,
					color: '#000'
				});
				row.add(titleLabel);
	
				//add our icon to the left of the row
				var iconImage = Titanium.UI.createImageView({
					image: 'images/icon-beer.png',
					width: 24,
					height: 24,
					left: 10,
					top: 5
				});
				row.add(iconImage);
	
				var whenLabel = Titanium.UI.createLabel({
					text: response[i].when,
					font: {
						fontSize: 10,
						fontWeight: 'normal'
					},
					left: 50,
					top: 17,
					height: 20,
					width: 200,
					color: '#000'
				});
				row.add(whenLabel);
				//add the table row to our data[] object
				data.push(row);
			}
	
			//finally, set the data property of the tableView to our data[] object
			tblBeers.setData(data);
			tblBeers.addEventListener('click', function(e) {
				var drankDetailWin = new DrankDetailWindow(e.rowData);
				self.containingTab.open(drankDetailWin);
			});
		};
	}
	
	// get REST API host url
	var APIHost = Ti.App.Properties.getString('APIHost');
	
	//Ti.include('populateDrankAndKegStand.js');
	
	var reloadButton = Titanium.UI.createButton({
		top: 10,
		left:10,
		title: 'Reload',
	});
	
	var data = [{title:'Loading ...'}];
	
	var tblBeers = Titanium.UI.createTableView({
		top: 10,
		width: '100%',
		height:'75%',
		rowHeight: 35,
		borderRadius: 5,
		data: data
	});
	
	reloadButton.addEventListener('click', function(e){
		populateTableWithBeer('drank', data);
	});
	
	self.add(reloadButton);
	self.add(tblBeers);
	
	self.addEventListener('focus', function() {
		populateTableWithBeer('drank', data);
	});
	
	return self;
};

module.exports = DrankWindow;