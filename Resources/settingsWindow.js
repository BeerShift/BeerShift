//reference the current window
var settingsWindow = Titanium.UI.currentWindow;

// get the tabGroup
var tabGroup = Ti.UI.currentWindow.tabGroup;

// Check our properties to autofill if this user already exists.
var username = Ti.App.Properties.getString("username");
var password = Ti.App.Properties.getString("password");
var APIHost = Ti.App.Properties.getString('APIHost');

//create the view, this will hold all of our UI controls
var view = Titanium.UI.createView({
	width : 300,
	height : 400,
	left : 10,
	top : 10,
	backgroundColor : 'black',
	borderRadius : 5
});

// create the openshift logo
var logo = Ti.UI.createImageView({
	image : 'images/openshift-logo-white-scaled.png',
	width : 141,
	height : 56,
	left : 85,
	top : 200
});

var breweryDBLogo = Ti.UI.createImageView({
	image : 'images/Powered-By-BreweryDB.png',
	width : 141,
	height : 56,
	left : 85,
	top : 275
});

view.add(logo);
view.add(breweryDBLogo);

var labelUsername = Titanium.UI.createLabel({
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
	text : 'Username: '
});
view.add(labelUsername);

var tfUsername = Ti.UI.createTextField({
	width : 200,
	height : 30,
	top : 20,
	right : 10,
	borderStyle : Ti.UI.INPUT_BORDERSTYLE_ROUNDED,
	returnKeyType : Ti.UI.RETURNKEY_DONE,
	hintText : 'BeerShift Username'
});

// fill the username textfield with the existing username
if(username != null) {
	tfUsername.value = username;
}

view.add(tfUsername);

var labelPassword = Titanium.UI.createLabel({
	width : 'auto',
	height : 30,
	top : 70,
	left : 10,
	color : 'white',
	font : {
		fontSize : 14,
		fontFamily : 'Helvetica',
		fontWeight : 'bold'
	},
	text : 'Password: '
});
view.add(labelPassword);

var tfPassword = Ti.UI.createTextField({
	width : 200,
	height : 30,
	top : 70,
	right : 10,
	borderStyle : Ti.UI.INPUT_BORDERSTYLE_ROUNDED,
	returnKeyType : Ti.UI.RETURNKEY_DONE,
	passwordMask : true,
	hintText : 'password'
});

view.add(tfUsername);
view.add(tfPassword);

// create our Button to login
var buttonLogin = Ti.UI.createButton({
	image : 'images/button-login.png',
	id : 1,
	top : 120,
	width : 74,
	height : 24,
	left : 123,
	backgroundColor : 'black'
});

buttonLogin.addEventListener('click', loginUser);

view.add(buttonLogin);
settingsWindow.add(view);

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
		text : 'Authenticating'
	});

	view.add(labelAuthenticating);

	// Make a call out to openshift to validate / create user
	// First, you'll want to check the user is connected to the intertubes
	if(Titanium.Network.online == true) {

		// I could set a global var here that is a boolean to block until a response is received
		// maybe have an animated gif imgView or something
		var request = Titanium.Network.createHTTPClient();
		var getURL = APIHost + 'user/username/' + tfUsername.value;
		request.open('GET', getURL);
		request.send();
		request.onload = function() {
			var statusCode = request.status;
			if(statusCode == 404) {
				// The username doesn't exist so lets create a new user
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
							title : 'Bad Password',
							message : 'Password is not correct for this user'
						});
						alertDialog.show();
						buttonLogin.visible = true;
					}
				}
			}
		}
	}
}