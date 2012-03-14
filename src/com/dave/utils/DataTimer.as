/**
 * http://blog.flexexamples.com/2008/02/20/creating-custom-timers-by-extending-the-timer-class/
 */
package com.dave.utils {
    import flash.utils.Timer;

    public class DataTimer extends Timer {
        private var _data:Object;

        public function DataTimer(delay:Number, repeatCount:int=0) {
            super(delay, repeatCount);
            _data = {};
        }

        public function get data():Object {
            return _data;
        }

        public function set data(value:Object):void {
            _data = value;
        }
    }
}