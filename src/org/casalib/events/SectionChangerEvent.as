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
package org.casalib.events {
	import flash.events.Event;
	
	/**
		An event dispatched when a load request is retried after previously failing.
		
		@author Aaron Clinger
		@version 04/11/08
	*/
	public class SectionChangerEvent extends Event {
		public static const SECTION_CHANGE:String  = 'sectionChange';
		public static const SECTION_CHANGED:String = 'sectionChanged';
		protected var _section:String;
		
		
		/**
			Created a new SectionChangerEvent.
			
			@param type: The type of event.
			@param bubbles: Determines whether the Event object participates in the bubbling stage of the event flow.
			@param cancelable: Determines whether the Event object can be canceled.
		*/
		public function SectionChangerEvent(type:String, bubbles:Boolean = false, cancelable:Boolean = false) {
			super(type, bubbles, cancelable);
		}
		
		/**
			The identifier of the current or currently requested section.
		*/
		public function get section():String {
			return this._section;
		}
		
		public function set section(id:String):void {
			this._section = id;
		}
		
		/**
			@return A string containing all the properties of the event.
		*/
		override public function toString():String {
			return formatToString('SectionChangerEvent', 'type', 'bubbles', 'cancelable', 'section');
		}
		
		/**
			@return Duplicates an instance of the event.
		*/
		override public function clone():Event {
			var e:SectionChangerEvent = new SectionChangerEvent(this.type, this.bubbles, this.cancelable);
			e.section                 = this.section;
			
			return e;
		}
	}
}