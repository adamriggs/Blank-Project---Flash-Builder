var as_swf_name = "flashContainer";

//--- Facebook	
var fbSession;

function fbAsyncInit(app_id) {	
	window.fbAsyncInit = function() {
		FB.init({
			appId  : app_id,
			status : true, // check login status
			cookie : true, // enable cookies to allow the server to access the session
			xfbml  : false  // parse XFBML
		});
	};

  (function() {
    var e = document.createElement('script');
    e.src = document.location.protocol + '//connect.facebook.net/en_US/all.js';
    e.async = true;
    document.getElementById('fb-root').appendChild(e);
  }());
}

function fbInit(app_id) {
	FB.init({appId: app_id, status: true, cookie: true, xfbml: false});
}

function fbLogin(permissions) {
	FB.login(fbLoginHandler, {perms:permissions});
}

function fbLoginHandler(response) {
	fbSession = response.session;
	if (fbSession) {
    	fbUserInfo(fbSession, null);
		flashCallBack("fbLoginComplete", fbSession);
	}
	else {
		flashCallBack("fbLoginCanceled");
	}		
}

function fbUserInfo(uid, handler) {
	if (!handler) handler = fbUserInfoHandler;
	if (fbSession) {
		FB.api('/me', handler);
	} else if (uid) {
		FB.api('/'+uid, handler);
	} else {
		alert('Please profile a uid or have a user login.');
		return;
	}	
}

function fbUserInfoHandler(response) {	
	return response;
}

function fbUserProfilePicture(uid,type) {
	if (!type) type = "large";
	if (fbSession) {
		uid = fbSession.uid;
	} else if (uid) {
		
	} else {
		alert('Please profile a uid or have a user login.');
		return;
	}
	var imgURL = "http://graph.facebook.com/"+uid+"/picture?type="+type;
	
	return imgURL;
}

function fbUserPhotos() {
	//https://graph.facebook.com/126560690717911/photos/?access_token=2227470867|2.Wxc_rYila7VwahKDca9tpA__.3600.1277071200-100000919438748|qv3LY7KAlOTZUjwpF8nGPbnGJqg.
	//https://graph.facebook.com/126560690717911/photos/?access_token=2227470867|2.Wxc_rYila7VwahKDca9tpA__.3600.1277071200-100000919438748|qv3LY7KAlOTZUjwpF8nGPbnGJqg.
}

function fbCreateImageMedia(src,link) {
	var mediaObj = {
		type: 'image',
		src: src,
		link: link
	};
	return mediaObj;
}

function fbCreateSWFMedia(swfsrc,imgsrc,width,height,exp_width,exp_height) {

	var swfObj ={
		type: 'flash',
		swfsrc: swfsrc,
		imgsrc: imgsrc,
		width: width,
		height: height,
		expanded_width: exp_width,
		expanded_height: exp_height
	};
	return swfObj;
}

function fbCreateAttachment(name,link,description,media) {
	var attachment = {
				name: name,
				href: link,
				description: description,
				media: media
			};
	return attachment;
}

function fbPostToStream(message,attachment,action_links,target_id) {
	FB.api(
		{
		method:'stream.publish', 
		message: message, 
		attachment: attachment,
		action_links: action_links,
		target_id: target_id
		}
		, fbPostToStreamHandler);
}

function fbPostToStreamHandler(response) {
	if (!response || response.error) {
    	alert('Error occured');
  	} else {
   	 	//alert('Post ID: ' + response);
   	 	flashCallBack("fbPostToStreamComplete",fbSession);
  	}
}

function fbPostMessage(body) {
	if (!fbSession) alert('Please have a user login.');
	FB.api('/me/feed', 'post', { message: body }, fbPostToWallHandler);
}

function fbPostToWallHandler(response) {
	if (!response || response.error) {
    	alert('Error occured');
  	} else {
   	 	//alert('Post ID: ' + response);
   	 	flashCallBack("fbPostToWallComplete",fbSession);
  	}
}

function fbGetSession() {
	return FB.getLoginStatus();
}


//--- Flash Callback

function flashCallBack ( func ) {
  if (g_flashLoaded) {        //only run this area if flash exists other get js error
  	if( arguments.length > 1 ){
  		document[as_swf_name][func]( Array.prototype.slice.call(arguments).slice(1)[0]);
  	}else{
  		document[as_swf_name][func]();
  	}
  }
}
