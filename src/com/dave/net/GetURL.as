// GetURL.as
// // Copyright 2007 Dave Cole - All Rights Reserved

package com.dave.net{
    import flash.net.navigateToURL;
    import flash.net.URLRequest;
    import flash.net.URLVariables;
	
	public class GetURL {
		//protected var variables:URLVariables;
		protected var request:URLRequest;
		
		public function GetURL(url:String, target:String = "", variables:URLVariables=null){
			//variables = new URLVariables();
            //variables.exampleSessionId = new Date().getTime();
            //variables.exampleUserLabel = "Flash";
           	request = new URLRequest(url);
			if (variables != null){
           	   request.data = variables;
			}
            try {            
				if (target != ""){
					navigateToURL(request, target);
				} else {
                	navigateToURL(request, "_self");
				}
            }
            catch (e:Error) {
                // handle error here
            }

		}
		
		
	}
}