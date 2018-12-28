
/* JavaScript content from js/main.js in folder common */

/* JavaScript content from js/main.js in folder common */
function wlCommonInit(){
	/*
	 * Use of WL.Client.connect() API before any connectivity to a MobileFirst Server is required. 
	 * This API should be called only once, before any other WL.Client methods that communicate with the MobileFirst Server.
	 * Don't forget to specify and implement onSuccess and onFailure callback functions for WL.Client.connect(), e.g:
	 *    
	 *    WL.Client.connect({
	 *    		onSuccess: onConnectSuccess,
	 *    		onFailure: onConnectFailure
	 *    });
	 *     
	 */
	
	// Common initialization code goes here
	WL.Client.connect({
		onSuccess: function () {
			WL.Logger.info("Successfully connected to IBM MobileFirst Server.");
		},
		onFailure: function (error) {
			WL.Logger.info("Error connecting to IBM MobileFirst Server: " + error);
		}
	});
}

/* JavaScript content from js/main.js in folder android */
// This method is invoked after loading the main HTML and successful initialization of the IBM MobileFirst Platform runtime.
function wlEnvInit(){
    wlCommonInit();
    // Environment initialization code goes here
}

function updateContactKey(contactKey) {
    if (!cordova.plugins.MCCordovaPlugin)
        return;

    cordova.plugins.MCCordovaPlugin.setContactKey((success) => {
            console.log("success set contact key");
            console.log(success);
            alert(success);
        }, (error) => {
            console.log("error set contact key");
            console.log(error);
        }, contactKey.value);
}

function getContactKey() {
    if (!cordova.plugins.MCCordovaPlugin)
            return;

    cordova.plugins.MCCordovaPlugin.getContactKey((contactKey) => {
        console.log(contactKey);
        alert(contactKey);
    }, (error) => {
        console.log(error);
    });
}

function isPushEnabled() {
    if (!cordova.plugins.MCCordovaPlugin)
                return;

    cordova.plugins.MCCordovaPlugin.isPushEnabled((isPushEnabled) => {
        console.log(isPushEnabled);
        alert(isPushEnabled);
    }, (error) => {
        console.log(error);
    });
}

function enablePush(){
	console.log("Enabeling push..");
    if (!cordova.plugins.MCCordovaPlugin)
        return;
    cordova.plugins.MCCordovaPlugin.enablePush();
}

function getSystemToken() {
    if (!cordova.plugins.MCCordovaPlugin)
        return;

    cordova.plugins.MCCordovaPlugin.getSystemToken((systemToken) => {
        console.log(systemToken);
        alert(systemToken);
    }, (error) => {
        console.log(error);
    });
}

function getTags() {
    if (!cordova.plugins.MCCordovaPlugin)
            return;

    cordova.plugins.MCCordovaPlugin.getTags((tags) => {
        console.log(tags);
        alert(tags);
    }, (error) => {
        console.log(error);
    });
}
/* JavaScript content from js/main.js in folder iphone */
// This method is invoked after loading the main HTML and successful initialization of the IBM MobileFirst Platform runtime.
function wlEnvInit(){
    wlCommonInit();
    // Environment initialization code goes here
}