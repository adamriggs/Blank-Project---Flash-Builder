// com.dave.utils.GoogleMap
// Dave Cole
//
package com.dave.utils {
	import flash.display.Sprite;
	import flash.display.MovieClip;
	import flash.geom.Point;
	import flash.events.*;
	import caurina.transitions.*;
	import flash.system.Security;
	
	import com.app.Application;
	import com.dave.utils.DaveTimer;
	import com.dave.events.*;
	import com.dave.utils.JSON2Array;
	
	import com.google.maps.services.ClientGeocoderOptions;
	import com.google.maps.LatLng;
	import com.google.maps.Map;
	import com.google.maps.MapEvent;
	import com.google.maps.MapMouseEvent;
	import com.google.maps.MapType;
	import com.google.maps.styles.FillStyle;
	import com.google.maps.services.ClientGeocoder;
	import com.google.maps.services.GeocodingEvent;
	import com.google.maps.overlays.Marker;
	import com.google.maps.overlays.MarkerOptions;
	import com.google.maps.InfoWindowOptions;
	import com.google.maps.controls.ZoomControl; 
	
	public class GoogleMap extends Sprite {
		public var showing:Boolean = true;
		public var map:Map;
		private var multigeocoder,geocoder:ClientGeocoder;
		public var playerWidth,playerHeight:int;
		private var username:String;
		private var pins:Array;
		private var i:int;
		private var multipin:Boolean = true;
		private var _isUGC:Boolean = false;
		private var _dataSet:Array;
		private var mapQueue:Array;
		private var queueIndex:Number = -1;
		private var json:JSON2Array;
		
		public function GoogleMap(w:int,h:int){
			init(w,h);
		}
		
		public function init(w:int,h:int):void{
			trace("GoogleMap() init");
			//Security.loadPolicyFile("http://");
			playerWidth = w;
			playerHeight = h;
			pins = new Array();
			mapQueue = new Array();
		}
		
		public function setSize(w:int,h:int):void{
			map.setSize(new Point(w,h));
			playerWidth = w;
			playerHeight = h;
		}
		
		public function lateInit(e:Event=null):void{
			map = new Map();
			map.addEventListener(MapEvent.MAP_READY, onMapReady);
			map.key = Application.googleMapKey;
			setSize(playerWidth,playerHeight);
			this.addChild(map);
			
			
		}
		
		function onMapReady(event:Event):void {
			trace("GoogleMap.onMapReady()");
			map.addControl(new ZoomControl());  
			//map.addControl(new PositionControl());  
			//map.addControl(new MapTypeControl());
			//map.enableScrollWheelZoom();        
			map.enableContinuousZoom(); 
			geocoder = new ClientGeocoder();
			geocoder.addEventListener(GeocodingEvent.GEOCODING_SUCCESS, handleGeocodingSuccess);
			geocoder.addEventListener(GeocodingEvent.GEOCODING_FAILURE, handleGeocodingFailure);
			
			multigeocoder = new ClientGeocoder();
			multigeocoder.addEventListener(GeocodingEvent.GEOCODING_SUCCESS, handleMultiGeocodingSuccess);
			multigeocoder.addEventListener(GeocodingEvent.GEOCODING_FAILURE, handleMultiGeocodingFailure);
			
			
			//map.setCenter(new LatLng(40.736072,-73.992062), 14, MapType.NORMAL_MAP_TYPE);
		}
		
		
		
		public function doGeocode(address:String, isUGC:Boolean=false, name:String=""):void {
			trace("GoogleMap.doGeocode("+address+")");
			username = name;
			_isUGC=isUGC;
			geocoder.geocode(address);
		}
		
		public function doMultiGeocode(address:String, name:String=""):void{
			trace("GoogleMap.doMultiGeocode("+address+")");
			
			multigeocoder.geocode(address);
		}
		
		public function wipeMap():void{
			trace("GoogleMap.wipeMap()");
			for (i=0; i < pins.length; i++){
				if (pins[i].marker){
					map.removeOverlay(pins[i].marker);
				}
				pins[i] = null;
			} 
			pins = new Array();
			mapQueue = new Array();
			queueIndex = -1;
		}
		
		
		
		private function doNextQueueItem():void{
			
			queueIndex += 1;
			if (queueIndex < mapQueue.length){
				trace("GoogleMap.doNextQueueItem() - queueIndex == "+ (queueIndex + 1) + "/" + mapQueue.length );
				for (var obj in mapQueue[queueIndex].info){
					trace("mapQueue["+queueIndex+"].info["+obj+"] == "+mapQueue[queueIndex].info[obj]);
				}
				doMultiGeocode(mapQueue[queueIndex].info.City + " " + mapQueue[queueIndex].info.StateProvince + " " + mapQueue[queueIndex].info.PostalCode + " " + mapQueue[queueIndex].info.CountryEN);
				
			} else {
				// at end of queue
				
			}
		}
		
		private function handleMultiGeocodingSuccess(event:GeocodingEvent):void{
			pins.push({ info: mapQueue[queueIndex].info, placemarks: event.response.placemarks, marker: event.response.placemarks.length > 0 ? new Marker(event.response.placemarks[0].point) : null });
			trace("handleMultiGeocodingSuccess "+pins[pins.length - 1].marker);
			
			if (pins[pins.length - 1].marker){
				trace("adding pin at "+pins[pins.length - 1].marker.getLatLng());
				var o:MarkerOptions = pins[pins.length - 1].marker.getOptions();
				map.addOverlay(pins[pins.length - 1].marker);
				o.hasShadow = true;
				o.clickable = true;
				o.draggable = false;
				
				o.tooltip = pins[pins.length - 1].info.YouTubeFirstName + " "+ pins[pins.length - 1].info.YouTubeLastName + "<br>\n" + pins[pins.length - 1].info.City;
				pins[pins.length - 1].marker.addEventListener(MapMouseEvent.CLICK, multi_marker_click);
				
				
				pins[pins.length - 1].marker.setOptions(o);
			}
			
			doNextQueueItem();
		}
		
		private function handleGeocodingSuccess(event:GeocodingEvent):void {
			trace("GoogleMaps.handleGeocodingSuccess() "+event.response.placemarks.length);
			var placemarks:Array = event.response.placemarks;        
			if (placemarks.length > 0) {          
				map.setCenter(placemarks[0].point, 3, MapType.NORMAL_MAP_TYPE);          
				if (!multipin || _isUGC){
					var marker:Marker = new Marker(placemarks[0].point);         
					map.addOverlay(marker);
					var options:MarkerOptions = marker.getOptions();
					options.tooltip = username;
					options.hasShadow = true;
					options.clickable = false;
					options.draggable = false;
					//var options:MarkerOptions = new MarkerOptions({  strokeStyle: {    color: 0x987654  },  fillStyle: {    color: 0x223344,    alpha: 0.8  },  label: "",  labelFormat: {    bold: true  },  tooltip: username,  radius: 12,  hasShadow: true,  clickable: false,  draggable: false,  gravity: 0.5,  distanceScaling: false});
					marker.setOptions(options);
					
					//marker.tooltip = "";
					//marker.addEventListener(MapMouseEvent.CLICK, marker_click);
					//marker.addEventListener(MapMouseEvent.CLICK, function(event:MapEvent):void { marker.openInfoWindow(new InfoWindowOptions({ title: "Geocoded Result",content: placemarks[0].address }));   });   
				} else {
					for (i=0; i < pins.length; i++){
						var o:MarkerOptions = pins[i].marker.getOptions();
						if (event.response.placemarks.length > 0){
							var m:Marker = new Marker(event.response.placemarks[0].point);
							if (pins[i].marker.getLatLng().distanceFrom(m.getLatLng()) < 5){
								o.fillStyle = new FillStyle( { color: 0xFF0000, alpha: 1 } );
							} else {
								o.fillStyle = new FillStyle( { color: 0xADA689, alpha: 1 } );
							}
						} else {
							o.fillStyle = new FillStyle( { color: 0xADA689, alpha: 1 } );
						}
						pins[i].marker.setOptions(o);
					}
				}
			}
			dispatchEvent(new Event("DONELOADING"));
		}
		
		private function marker_click(e:MapEvent):void{
			
		}
		private function multi_marker_click(e:MapEvent):void{
			
		}
		
		
		private function handleGeocodingFailure(event:GeocodingEvent):void {
			trace("Geocoding failed");        
		}
		
		private function handleMultiGeocodingFailure(event:GeocodingEvent):void {
			trace("Geocoding failed");    
			doNextQueueItem();
		}
		
		//public function doGeocode(address:String):void {  trace("GoogleMap.doGeocode("+address+")");       var geocoder:ClientGeocoder = new ClientGeocoder();                  geocoder.addEventListener(           GeocodingEvent.GEOCODING_SUCCESS,           function(event:GeocodingEvent):void {           var placemarks:Array = event.response.placemarks;           if (placemarks.length > 0) {             map.setCenter(placemarks[0].point);             var marker:Marker = new Marker(placemarks[0].point);  map.addOverlay(marker);   dispatchEvent(new Event("DONELOADING"));        }         });         geocoder.addEventListener(           GeocodingEvent.GEOCODING_FAILURE,           function(event:GeocodingEvent):void {             trace("Geocoding failed");             trace(event);             trace(event.status);           });         geocoder.geocode(address); } 
		
		/*
		public function doGeocode(address:String){
			dispatchEvent(new Event("DONELOADING"));
		}
		*/
		
		
		public function resizeHandler():void{
			
		}
		
		
		
		
		public function show():void{
			trace("GoogleMap.show() "+showing+" "+playerWidth+" "+playerHeight+" "+x+","+y);
			if (!showing){
				Tweener.removeTweens(this);
				this.alpha = 0;
				this.visible = true;
				Tweener.addTween(this, { alpha: 1, time: 0.5, transition: "easeInOutQuad" });
				showing = true;
			}
			
		}
		
		public function hide():void{
			if (showing){
				Tweener.removeTweens(this);
				Tweener.addTween(this, { alpha: 0, time: 0, transition: "easeInOutQuad", onComplete:function(){ this.visible = false; } });
				showing = false;
			}
			
		}
		
	
	}
}