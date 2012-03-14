package com.app
{	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	//import com.gsolo.encryption.MD5;
	import com.dave.events.*;
	import com.adam.events.*;

	import flash.events.IOErrorEvent;
	
	public class YouTube
	{
		
		private var urlLoader:URLLoader;
		private var apikey:String;
		private var url:String;
		
		private var xml:XML;
		private var atom:Namespace;
		private var media:Namespace;
		private var opensearch:Namespace;
		private var google:Namespace;
		private var youtube:Namespace;
		
		private var page:int;
		
		public function YouTube()
		{
			init();
		}
		
//*****Initalization Functions
		
		private function init():void{
			EventManager.listen("flickr", onFlickr);
			
			initNamespaces();
			page=0;
			
			apikey="AI39si4PjlO4wtfwZ39rRZecvccDFqhRIAIP4AY4-JkQe199MLngH20KceOEOHBRExUBYiobtg7SmNIdUSACdRO5sNbt5g9";
			url="http://gdata.youtube.com/feeds/api/standardfeeds/top_favorites";
			//url="http://gdata.youtube.com/feeds/api/videos?category=comedy%2C-Comedy&v=2";
			//url="http://gdata.youtube.com/feeds/api/users/adamriggs/playlists?v=2";
			//url="http://gdata.youtube.com/feeds/api/users/adamriggs/uploads";
			urlLoader=new URLLoader(new URLRequest(url));
			urlLoader.addEventListener(Event.COMPLETE, onComplete);
			urlLoader.addEventListener(IOErrorEvent.IO_ERROR, onError);
			trace("url=="+url);
		}
		
		private function initNamespaces():void{
			
			atom=new Namespace("http://www.w3.org/2005/Atom");
			media=new Namespace("http://search.yahoo.com/mrss/");
			opensearch=new Namespace("http://a9.com/-/spec/opensearchrss/1.0/");
			google=new Namespace("http://schemas.google.com/g/2005");
			youtube=new Namespace("http://gdata.youtube.com/schemas/2007");
		}
		
//*****Core Functionality
		
		public function returnFirstVideoURL():String{
			
			var vidUrl:String;
			var vidId:String;
			
			vidId=xml.atom::entry[0].atom::id;
			vidId=vidId.slice(vidId.lastIndexOf("/")+1);
			vidUrl="http://www.youtube.com/watch?v="+vidId;
			
			trace("thumb url==http://img.youtube.com/vi/"+vidId+"/2.jpg");
			trace("title=="+xml.atom::entry[0].atom::title);
			trace("description=="+xml.atom::entry[0].atom::content);
			
			return vidUrl;
		}
		
		public function makeNode(index:int):XML{
			var nodeXML:XML;
			var vidId:String;
			var thumb:String;
			var main:String;
			
			vidId=xml.atom::entry[index].atom::id;
			vidId=vidId.slice(vidId.lastIndexOf("/")+1);
			
			thumb="http://img.youtube.com/vi/"+vidId+"/2.jpg";
			main="http://www.youtube.com/watch?v="+vidId;
			
			nodeXML=
			<youtube>
				<type>youtube</type>
				<id>{vidId}</id>
				<thumb>{thumb}</thumb>
				<main>{main}</main>
				<title>{xml.atom::entry[index].atom::title.toString()}</title>
				<description>{xml.atom::entry[index].atom::content}</description>
			</youtube>
			
			return nodeXML;
		}
		
		private function recycleLoader():void{
			urlLoader.removeEventListener(Event.COMPLETE, onNextPage);
			urlLoader.removeEventListener(IOErrorEvent.IO_ERROR, onError);
			
			urlLoader=new URLLoader();
			
			urlLoader.addEventListener(Event.COMPLETE, onNextPage);
			urlLoader.addEventListener(IOErrorEvent.IO_ERROR, onError);
		}
		
		private function requestNextPage():void{
			recycleLoader();
			urlLoader.load(new URLRequest(url+"&page="+page++));
		}
		
//*****Event Handlers
		
		private function onFlickr(e:MuleEvent):void{
			switch(e.data.type){
				
				case "getNextPage":
					trace("YouTube getNextPage");
					//requestNextPage();
				break;
				
			}
		}
		
		private function onNextPage(e:Event):void{
			
			//add the next page data to the master xml list
			
			
			//broadcast next page event with page length
			
			
		}
		
		private function onComplete(e:Event):void{
			trace("load complete");
			xml=new XML(urlLoader.data);
			//initNamespaces();
			//trace(xml.atom::entry[0].atom::id);
			//trace(xml.atom::entry.length());
			//trace("returnFirstVideoURL()=="+returnFirstVideoURL());
			urlLoader.removeEventListener(Event.COMPLETE, onComplete);
			urlLoader.addEventListener(Event.COMPLETE, onNextPage);
			trace("xml length=="+xml.opensearch::totalResults);
			trace("xml=="+xml);
			EventManager.dispatch("flickr", {type:"xmlLoaded", xml:xml, xmlLength:xml.opensearch::itemsPerPage, total:xml.opensearch::totalResults});
			EventManager.dispatch("picture", {type:"update", node:makeNode(0), index:0});
		}
		
		private function onError(e:IOErrorEvent):void{
			trace("error loading");
			trace(e.text);
		}
	}
}