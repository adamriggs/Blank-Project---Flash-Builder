/*
	CASA Framework for ActionScript 3.0
	Copyright (c) 2009, Contributors of CASA Framework
	All rights reserved.
	
	Redistribution and use in source and binary forms, with or without
	modification, are permitted provided that the following conditions are met:
	
	- Redistributions of source code must retain the above copyright notice,
	  this list of conditions and the following disclaimer.
	
	- Redistributions in binary form must reproduce the above copyright notice,
	  this list of conditions and the following disclaimer in the documentation
	  and/or other materials provided with the distribution.
	
	- Neither the name of the CASA Framework nor the names of its contributors
	  may be used to endorse or promote products derived from this software
	  without specific prior written permission.
	
	THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
	AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
	IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
	ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE
	LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
	CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
	SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
	INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
	CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
	ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
	POSSIBILITY OF SUCH DAMAGE.
*/
package org.casalib.navigation {
	import org.casalib.events.RemovableEventDispatcher;
	import org.casalib.time.Interval;
	import org.casalib.events.SectionChangerEvent;
	
	[Event(name="sectionChange", type="com.aaronclinger.events.SectionChangerEvent")]
	[Event(name="sectionChanged", type="com.aaronclinger.events.SectionChangerEvent")]
	
	/**
		Manages and dispatches section change requests.
		
		@author Aaron Clinger
		@version 01/06/09
	*/
	public class SectionChanger extends RemovableEventDispatcher {
		private static var _instanceMap:Object;
		private var _id:String;
		private var _timeout:Interval;
		private var _changingSections:Boolean;
		private var _requestedSection:String;
		private var _section:String;
		private var _queuedSection:String;
		
		
		/**
			Returns or creates an instance of SectionChanger.
			
			@param id: The unique reference name for the instance of SectionChanger.
			@return A previously created or newly created instance of SectionChanger.
		*/
		public static function getInstanceById(id:String):SectionChanger {
			if (SectionChanger._instanceMap == null)
				SectionChanger._instanceMap = new Object();
			
			if (SectionChanger._instanceMap[id] != null)
				return SectionChanger._instanceMap[id];
			
			SectionChanger._instanceMap[id] = new SectionChanger(new SingletonEnforcer(), id);
			
			return SectionChanger._instanceMap[id];
		}
		
		/**
			@exclude
		*/
		public function SectionChanger(singletonEnforcer:SingletonEnforcer, id:String) {
			super();
			
			this._id               = id;
			this._changingSections = false;
			this._timeout          = Interval.setTimeout(this._sectionChangeDelayComplete, 500);
		}
		
		/**
			The delay between {@link #requestSection} and dispatching the section change event. This delay helps prevent unnecessary section switches.
			
			@usageNote Defaults to to {@code 500} milliseconds.
		*/
		public function set delay(amount:uint):void {
			amount = (amount == 0) ? 1 : amount;
			
			if (amount == this.delay)
				return;
			
			this._timeout.delay = amount;
		}
		
		public function get delay():uint {
			return this._timeout.delay;
		}
		
		/**
			The reference name for this instance of SectionChanger.
		*/
		public function get id():String {
			return this._id;
		}
		
		/**
			Sends a request to change sections.
			
			@param sectionId: Identifier of the section you are requesting.
		*/
		public function requestSection(sectionId:String):void {
			if (sectionId == this._queuedSection || sectionId == this._requestedSection)
				return;
			
			if (sectionId == this.section) {
				this._timeout.reset();
				
				this._queuedSection = null;
				
				return;
			}
			
			this._requestedSection = sectionId;
			
			this._timeout.reset();
			this._timeout.start();
		}
		
		private function _sectionChangeDelayComplete():void {
			if (this._changingSections)
				this._queuedSection = this._requestedSection;
			else
				this._startSectionChange(this._requestedSection);
			
			this._requestedSection = null;
		}
		
		private function _startSectionChange(sectionId:String):void {
			this._section          = sectionId;
			this._queuedSection    = null;
			this._changingSections = true;
			
			var e:SectionChangerEvent = new SectionChangerEvent(SectionChangerEvent.SECTION_CHANGE);
			e.section                 = this.section;
			this.dispatchEvent(e);
		}
		
		/**
			Notifies SectionChanger that the application has reacted to the section change event and is able to handle another section change.
		*/
		public function sectionChangeComplete():void {
			if (!this._changingSections)
				return;
			
			this._changingSections = false;
			
			var e:SectionChangerEvent = new SectionChangerEvent(SectionChangerEvent.SECTION_CHANGED);
			e.section                 = this.section;
			this.dispatchEvent(e);
			
			if (this._queuedSection != null)
				this._startSectionChange(this._queuedSection);
		}
		
		/**
			The identifier of the current or currently requested section.
		*/
		public function get section():String {
			return this._section;
		}
		
		/**
			The identifier of a queued section if any; otherwise {@code null}.
		*/
		public function get queuedSection():String {
			return this._queuedSection;
		}
		
		/**
			Removes any queued section request and stops waiting for a call to {@link #sectionChangeComplete}.
		*/
		public function clear():void {
			this._timeout.reset();
			
			this._queuedSection    = null;
			this._requestedSection = null;
			this._changingSections = false;
		}
		
		/**
			Resets the SectionChanger instance.
		*/
		public function reset():void {
			this._section = null;
			this.clear();
		}
	}
}

class SingletonEnforcer {}