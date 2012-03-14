/*
	CASA Lib for ActionScript 3.0
	Copyright (c) 2010, Aaron Clinger & Contributors of CASA Lib
	All rights reserved.
	
	Redistribution and use in source and binary forms, with or without
	modification, are permitted provided that the following conditions are met:
	
	- Redistributions of source code must retain the above copyright notice,
	  this list of conditions and the following disclaimer.
	
	- Redistributions in binary form must reproduce the above copyright notice,
	  this list of conditions and the following disclaimer in the documentation
	  and/or other materials provided with the distribution.
	
	- Neither the name of the CASA Lib nor the names of its contributors
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
package org.casalib.collection.iterators {
	import flash.events.IEventDispatcher;

	/**
	 * @author Jon Adams
	 * @version 09/22/10
	 */
	public interface IIterator extends IEventDispatcher {

		/**
		 * Determines if an element exists in the first posotion.
		*/
		function hasFirst():Boolean;
		
		/**
		 * Determines if an element exists in the last posotion.
		*/
		function hasLast():Boolean;
		
		/**
		 * Determines if an element exists in the next posotion.
		*/
		function hasNext():Boolean;
		
		/**
		 * Determines if an element exists in the previous posotion.
		*/
		function hasPrevious():Boolean;
		
		/**
		 * Changes current to and returns the first element. 
		*/
		function first():*;
		
		/**
		 * Changes current to and returns the last element. 
		*/
		function last():*;
		
		/**
		 * Changes current to and returns the next element. 
		*/
		function next():*;
		
		/**
		 * Changes current to and returns the previous element. 
		*/
		function previous():*;
		
		/**
		 * Returns the current index. 
		*/
		function get currentIndex():int;
		
		/**
		 * Sets the current index and dispatches a change. 
		*/
		function set currentIndex(index:int):void;
		
		/**
		 * Returns the current element. 
		*/
		function get current():*;
		
		function reset():void
	}
}
