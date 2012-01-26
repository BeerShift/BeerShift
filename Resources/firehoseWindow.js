//reference the current window
var firehoseWindow = Titanium.UI.currentWindow;

// get the tabGroup
var tabGroup = Ti.UI.currentWindow.tabGroup;


//create the view, this will hold all of our UI controls
var view = Titanium.UI.createView({
	width : 300,
	height : 400,
	left : 10,
	top : 10,
	backgroundColor : 'black',
	borderRadius : 5
});


function populateTableWithBeer() {

	var data = [];

	var tblBeers = Titanium.UI.createTableView({
		height : 340,
		width : 320,
		top : 0,
		left : 5,
		rowHeight : 35,
		borderRadius : 5,
		data : data
	});
	view.add(tblBeers);
	var data = [];
	var pintlabURL = "http://localhost/api/firehose/";
	Ti.API.info(pintlabURL);
	var request = Titanium.Network.createHTTPClient();
	request.open('GET', pintlabURL);
	request.send();
	//this method will process the remote data
	request.onload = function() {
		//create a json object using the JSON.PARSE function
		var response = JSON.parse(request.responseText);

		//loop each item in the json object
		for(var i = 0; i < response.length; i++) {
			//create a table row
			var row = Titanium.UI.createTableViewRow({
				hasChild : true,
				className : 'recipe-row',
				backgroundColor : '#fff',
				_username : response[i].username,
				_beerName : response[i].beer,
				_when : response[i].when
			});
			//title label
			var titleLabel = Titanium.UI.createLabel({
				text : response[i].username + " drank " + response[i].beer,
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
			
			var whenLabel = Titanium.UI.createLabel({
			text: response[i].when,
			font: {fontSize: 10, fontWeight: 'normal'},
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
		tblBeers.visible = false;
		tblBeers.setData(data);
		tblBeers.addEventListener('click', function(e) {
			drinkTab.open(createDetailWindow(e.rowData))
		});
		tblBeers.visible = true;
	}
}

populateTableWithBeer();
firehoseWindow.add(view);
firehoseWindow.addEventListener('focus', function(e){
	Ti.API.info('window has focus');
	populateTableWithBeer();
});
