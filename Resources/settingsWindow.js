function SettingsWindow() {
	//reference the current window
	var self = Ti.UI.createWindow({
		backgroundColor: "black",
		title: L('winSettings'),
		barImage: 'images/navbar.png',
		layout: 'vertical'
	}),
	
		// get the tabGroup
		tabGroup = self.tabGroup,
	
		// Check our properties to autofill if this user already exists.
		username = Ti.App.Properties.getString("username"),
		password = Ti.App.Properties.getString("password"),
		APIHost = Ti.App.Properties.getString('APIHost'),
		
		// font styles for controls
		labelFont = {fontSize: 14, fontFamily: 'Helvetica', fontWeight: 'bold'},
		fieldFont = {fontSize: 12, fontFamily: 'Helvetica', fontWeight: 'bold'};

	
	var labelApi = Titanium.UI.createLabel({
		width: 'auto',
		left: 10,
		top: 10,
		color: 'white',
		font: labelFont,
		text: L('lblApi')
	});
	self.add(labelApi);
	
	var tfApi = Ti.UI.createTextField({
		width: '95%',
		top: 0,
		borderStyle: Ti.UI.INPUT_BORDERSTYLE_ROUNDED,
		autocorrect: false,
		returnKeyType: Ti.UI.RETURNKEY_DONE,
		font: fieldFont,
		hintText: L('tfApiHintText')
	});
	
	if (APIHost !== null) {
		tfApi.value = APIHost;
	}
	self.add(tfApi);
	
	var labelUsername = Titanium.UI.createLabel({
		width: 'auto',
		left: 10,
		top: 5,
		color: 'white',
		font: labelFont,
		text : L('lblUsername')
	});
	self.add(labelUsername);
	
	var tfUsername = Ti.UI.createTextField({
		width: '95%',
		top: 0,
		borderStyle: Ti.UI.INPUT_BORDERSTYLE_ROUNDED,
		autocorrect: false,
		returnKeyType: Ti.UI.RETURNKEY_DONE,
		font: fieldFont,
		hintText : L('tfUsernameHintText')
	});
	
	// fill the username textfield with the existing username
	if (username !== null) {
		tfUsername.value = username;
	}
	self.add(tfUsername);
	
	var labelPassword = Titanium.UI.createLabel({
		width: 'auto',
		top: 5,
		left: 10,
		color: 'white',
		font: labelFont,
		text : L('lblPassword')
	});
	self.add(labelPassword);
	
	var tfPassword = Ti.UI.createTextField({
		width: '95%',
		top: 0,
		borderStyle: Ti.UI.INPUT_BORDERSTYLE_ROUNDED,
		returnKeyType: Ti.UI.RETURNKEY_DONE,
		passwordMask: true,
		font: fieldFont,
		hintText : L('tfPasswordHintText')
	});	
	self.add(tfPassword);
	
	// create our Button to login
	var buttonLogin = Ti.UI.createButton({
		image: 'images/button-login.png',
		id: 1,
		top: 10,
		backgroundColor: 'black'
	});
	buttonLogin.addEventListener('click', loginUser);
	
	self.add(buttonLogin);
	
	// create the openshift logo
	var logo = Ti.UI.createImageView({
		image: 'images/OpenShift-Logo-1.jpg',
		top: 25
	}),
		breweryDBLogo = Ti.UI.createImageView({
			image: 'images/Powered-By-BreweryDB.png',
			top: 10
		});
	self.add(logo);
	self.add(breweryDBLogo);
		
	function loginUser(e) {
		// Set the  login button to not show
		buttonLogin.visible = false;
	
		// Show our Authenticating label
		var labelAuthenticating = Titanium.UI.createLabel({
			width : 'auto',
			height : 30,
			top : 120,
			left : 10,
			color : 'white',
			font : {
				fontSize : 14,
				fontFamily : 'Helvetica',
				fontWeight : 'bold'
			},
			text : L('lblAuthenticating')
		});
	
		view.add(labelAuthenticating);
		
		Ti.App.Properties.setString('APIHost', tfApi.value);
		APIHost = tfApi.value;
	
		// Make a call out to openshift to validate / create user
		// First, you'll want to check the user is connected to the intertubes
		if(Titanium.Network.online == true) {
	
			// I could set a global var here that is a boolean to block until a response is received
			// maybe have an animated gif imgView or something
			var request = Titanium.Network.createHTTPClient();
			tfUsername.value = tfUsername.value.toLowerCase();
			var getURL = APIHost + 'user/username/' + tfUsername.value;
			request.open('GET', getURL);
			request.send();
			request.onload = function() {
				var statusCode = request.status;
				if(statusCode == 404) {
					// The username doesn't exist so lets create a new user
					// but only if the user wants us to
					var createUserOptionDialog = Ti.UI.createOptionDialog({
						title : L('createUserTitle'),
						options : [L('labelYes'), L('labelNo')],
						cancel : 1
					})
	
					//add the click event listener to the option dialog
					createUserOptionDialog.addEventListener('click', function(e) {
						if(e.index == 0) {
							var postURL = APIHost + 'user/';
							var postRequest = Ti.Network.createHTTPClient();
							postRequest.open('POST', postURL);
							postRequest.send({
								username : tfUsername.value,
								password : tfPassword.value
							});
							labelAuthenticating.visible = false;
							// Show the login button again to allow user to switch accounts
							buttonLogin.visible = true;
							// Set the properties
							Ti.App.Properties.setString('username', tfUsername.value);
							Ti.App.Properties.setString('password', tfPassword.value);
							// Put the user back on the drink tab
							tabGroup.setActiveTab(0);
						} else {
							labelAuthenticating.visible = false;
							buttonLogin.visible = true;
						}
					});
					createUserOptionDialog.show();
	
				}
				if(statusCode == 200) {
					var response = request.responseText;
					var jsonResult = JSON.parse(response);
					var backUser = jsonResult[0].username;
					var backPassword = jsonResult[0].password;
					if(tfUsername.value == backUser && tfPassword.value == backPassword) {
						labelAuthenticating.visible = false;
						// Show the login button again to allow user to switch accounts
						buttonLogin.visible = true;
						// Set the properties
						Ti.App.Properties.setString('username', tfUsername.value);
						Ti.App.Properties.setString('password', tfPassword.value);
						// Put the user back on the drink tab
						tabGroup.setActiveTab(0);
					} else {
						if(tfUsername.value == backUser && tfPassword.value != backPassword) {
							labelAuthenticating.visible = false;
							// Show an alert telling the user the password is not correct
							var alertDialog = Titanium.UI.createAlertDialog({
								title : L('alrtDialogTitle'),
								message : L('alrtDialogMsg')
							});
							alertDialog.show();
							buttonLogin.visible = true;
						}
					}
				}
			}
		}
	}
	
	return self;
};

module.exports = SettingsWindow;