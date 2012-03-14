﻿// com.adam.utils.GenericSingleton// Adam Riggs//package com.adam.utils {	import com.adam.events.MuleEvent;	import com.adam.utils.AppData;		import flash.events.*;		public class GenericSingleton{				//vars				//objects		private var appData:AppData=AppData.instance;				//const		public const NAME:String="genericObject";		public const RETURNTYPE:String=NAME;				/** Storage for the singleton instance. */		private static const _instance:GenericSingleton = new GenericSingleton(GenericSingletonLock);				public function GenericSingleton(lock:Class){			// Verify that the lock is the correct class reference.			if (lock != GenericSingletonLock)			{				throw new Error("Invalid GenericSingleton access.  Use GenericSingleton.instance instead.");			} else {				init();			}		}		//*****Initialization Routines				public function init():void{			debug("init()");						initVars();			initEvents();			initObjs();		}				private function initVars():void{					}				private function initEvents():void{			appData.eventManager.listen(NAME, onGenericSingleton);			appData.eventManager.listen("sql", onSQL);		}				private function initObjs():void{					}		//*****Core Functionality				public static function get instance():GenericSingleton{return _instance;}		//*****Event Handlers				private function onSQL(e:MuleEvent):void{			/*debug("onSQL()");			debug("e.data.sender=="+e.data.sender);			debug("e.data.type=="+e.data.type);*/			switch(e.data.type){								case RETURNTYPE:									break;							}		}				private function onGenericSingleton(e:MuleEvent):void{			/*debug("onGenericSingleton()");			debug("e.data.sender=="+e.data.sender);			debug("e.data.type=="+e.data.type);*/			switch(e.data.type){															}		}				//*****Gets and Sets						//*****Utility Functions				//**debug		private function debug(str:String):void{			appData.debug(NAME,str);		}				}//end class}//end packageclass GenericSingletonLock{}