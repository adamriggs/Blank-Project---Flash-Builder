//

package com.adam.apis {
	
	import com.adam.events.MuleEvent;
	import com.adam.utils.AppData;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	
	public class Flickr{
		
		//flickr api id info
		private var key:String = "2b6e6ffa4d1850dad7ee4973d77d6edf";
        private var secret:String = "d7909c80b6669891";
		
		//url related vars
		private var _url:String;
		private var urlBase:String;
		private var _reqType:String;
		
		//paging vars
		private var _page:int;
		private var totalPages:int;
		
		//xml request stuff
		public var loader:URLLoader;
		public var flickrXML:XML;
		public var xmlLoaded:Boolean=false;
		
		//from AppData.mainXML 
		public var photoset:String;
		public var nsid:String;
		
		//flickr method names
		public var mGetPhotos:String;
		public var mSearch:String;
		public var mInterestingness:String;
		
		public var appData:AppData=AppData.instance;
		
		
		/** Storage for the singleton instance. */
		private static const _instance:Flickr = new Flickr( FlickrLock );
		
		public function Flickr(lock:Class) {
			
			// Verify that the lock is the correct class reference.
			if ( lock != FlickrLock )
			{
				throw new Error( "Invalid Flickr access.  Use Flickr.instance." );
			}
				
			//init();
		}

//*****Initialization Routines
		
		public function init():void {
			appData.eventManager.listen("flickr", onFlickr);
			
			initPage();
			initURLStrings();
			initAppXML();
			initReqType();
			loadXML();
		}
		
		private function initPage():void{
			_page=1;
		}
		
		private function initURLStrings():void{
			urlBase="http://api.flickr.com/services/rest/?method=";
			mGetPhotos="flickr.photosets.getPhotos";
			mSearch="flickr.photos.Search";
			mInterestingness="flickr.interestingness.getList";
		}
		
		private function initAppXML():void{
			trace("appData.mainXML=="+appData.mainXML);
			trace("appData.mainXML.FLICKR.PHOTOSET=="+appData.mainXML.FLICKR.PHOTOSET);
			trace("appData.mainXML.FLICKR.NSID=="+appData.mainXML.FLICKR.NSID);
			photoset=appData.mainXML.FLICKR.PHOTOSET;
			nsid=appData.mainXML.FLICKR.NSID;
		}
		
		private function initReqType():void{
			if(photoset!=""){
				_reqType="photoset";
			}else if(nsid!=""){
				_reqType="user";
			}else {
				_reqType="interestingness";
			}
			makeURL();
		}

//*****Core Functionality
		
		private function makeURL():String{
			_url=urlBase;
			switch(_reqType){
				case "photoset":
					_url+=mGetPhotos+"&api_key="+key+"&photoset_id="+photoset;
				break;
				
				case "user":
					_url+=mSearch+"&api_key="+key+"&user_id="+nsid;
				break;
				
				case "interestingness":
					_url+=mInterestingness+"&api_key="+key;
				break;
			}
			
			return _url;
		}
		
		public function makeNode(index:int):XML{
			var xml:XML;
			var thumb:String="http://farm"+flickrXML..photo[index].@farm+".static.flickr.com/"+flickrXML..photo[index].@server+"/"+flickrXML..photo[index].@id+"_"+flickrXML..photo[index].@secret+"_t.jpg";
			var main:String="http://farm"+flickrXML..photo[index].@farm+".static.flickr.com/"+flickrXML..photo[index].@server+"/"+flickrXML..photo[index].@id+"_"+flickrXML..photo[index].@secret+".jpg";
			
			xml=<photo>
					<type>flickr</type>
					<id>{flickrXML..photo[index].@id}</id>
					<owner>{flickrXML..photo[index].@owner}</owner>
					<secret>{flickrXML..photo[index].@secret}</secret>
					<server>{flickrXML..photo[index].@server}</server>
					<farm>{flickrXML..photo[index].@farm}</farm>
					<title>{flickrXML..photo[index].@title}</title>
					<ispublic>{flickrXML..photo[index].@ispublic}</ispublic>
					<isfriend>{flickrXML..photo[index].@isfriend}</isfriend>
					<isprivate>{flickrXML..photo[index].@isprivate}</isprivate>
					<key>{key}</key>
					<thumb>{thumb}</thumb>
					<main>{main}</main>
				</photo>
				
			if(_reqType=="photoset"){
				xml.owner=flickrXML.photoset.@owner;
			}
			
			return xml;
		}
		
		public function loadNextPage():void{
			trace("loadNextPage");
			//var urlReq:URLRequest=new URLRequest(makeURL()+"page="+_page);
			//loader=new URLLoader(urlReq);
			loader=new URLLoader(new URLRequest(_url+"&page="+_page));
			loader.addEventListener(Event.COMPLETE, onNextPage, false, 0, true);
		}
		
		public function loadXML():void {
			initPage();
			loader=new URLLoader(new URLRequest(_url));
			loader.addEventListener(Event.COMPLETE,onDataLoad,false,0,true);
		}
		
//*****Event Handlers
		
		public function onFlickr(e:MuleEvent):void{
			switch(e.data.type){
				
				/*case "picture_nextPic":
					//add check for adding and subtracting 1 from index
					appData.eventManager.dispatch("picture", {type:"update", node:makeNode(e.data.index+1), index: e.data.index+1});
				break;
				
				case "picture_prevPic":
					appData.eventManager.dispatch("picture", {type:"update", node:makeNode(e.data.index-1), index: e.data.index-1});
				break;
				
				case "getNode":
					appData.eventManager.dispatch("flickr", {type:"setNode", index:e.data.index, node:makeNode(e.data.index)});
				break;*/
				
				case "getNextPage":
					if(_page<totalPages){
						_page++;
						loadNextPage();
					}
				break;
				
				case "init":
					init();
				break;
			}
			
		}
		
		public function onNextPage(e:Event):void{
			trace("onNextPage");
			
			var nextPageXML:XML=new XML(loader.data);
			var nextPageXMLList:XMLList=new XMLList(nextPageXML.photos.*);
			
			loader.removeEventListener(Event.COMPLETE, onNextPage);
			
			for(var i:uint=0; i<nextPageXMLList.length();i++){
				flickrXML.photos.appendChild(nextPageXMLList[i]);
			}
			trace("nextPageXMLList.length()=="+nextPageXMLList.length());
			trace("Flickr onNextPage i=="+i);
			appData.eventManager.dispatch("flickr", {type:"setNextPage", xmlList:nextPageXMLList, length:nextPageXMLList.length()});
		}
		
		public function onDataLoad(e:Event):void {
			flickrXML=new XML(loader.data);
			loader.removeEventListener(Event.COMPLETE, onDataLoad);
			xmlLoaded=true;
			trace("loader.data=="+loader.data);
			
			var flickrXMLList:XMLList=new XMLList(flickrXML.photos.*);
			//trace("flickrXMLList=="+flickrXMLList);
			
			totalPages=int(flickrXML.photos.@pages);
			trace("totalPages=="+totalPages);
			
			//trace("flickrXML=="+flickrXML);
			
			appData.eventManager.dispatch("picture", {type:"update", node:makeNode(0), index:0});
			switch(_reqType){
				case "photoset":
					appData.eventManager.dispatch("flickr", {type:"xmlLoaded", xml:flickrXML, xmlLength:flickrXML..photo.length(), total:flickrXML.photoset.@total});
				break;
				
				case "user":
					appData.eventManager.dispatch("flickr", {type:"xmlLoaded", xml:flickrXML, xmlLength:flickrXML..photo.length(), total:flickrXML.photos.@total});
				break;
				
				case "interestingness":
					appData.eventManager.dispatch("flickr", {type:"xmlLoaded", xml:flickrXML, xmlLength:flickrXML..photo.length(), total:flickrXML.photos.@total});
				break;
			}
			//appData.picture.setNode(makeNode(0), 0);
		}
		
//*****Gets and Sets
		
		private function get url():String{return _url}
		private function set url(value:String):void{_url=value;}
		
		private function get reqType():String{return _reqType;}
		private function set reqType(value:String):void{_reqType=value;}
		
		private function get page():int{return _page;}
		private function set page(value:int):void{_page=value;}
		
		/** Provides singleton access to the instance. */
		// We can use the Bindable metadata with an event name to prevent
		// Flex from reporting that "instance is not bindable".  We have to
		// use a custom event name because you cannot just use [Bindable]
		// with a static function (it's a compiler error).
		//
		// Since we never actually change the instance, we never need to 
		// dispatch an event, so there is no negative side effects here.  If 
		// you're  getting warnings in the console log, try uncommenting the line
		// below.  This isn't necessary with recent Flex 3 builds, but it is for
		// Flex 2.
		//[Bindable( "instanceChange" )]
		public static function get instance():Flickr
		{
			return _instance;
		}
		
	}
}


/**
 * This is a private class declared outside of the package
 * that is only accessible to classes inside of the Singleton.as
 * file.  Because of that, no outside code is able to get a
 * reference to this class to pass to the constructor, which
 * enables us to prevent outside instantiation.
 */
class FlickrLock
{
} 