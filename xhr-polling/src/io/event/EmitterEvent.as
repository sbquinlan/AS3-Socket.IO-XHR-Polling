/*!
* xhr-polling-as3
* Copyright 2012 Sean Quinlan <squinlanesq@gmail.com>
* MIT Licensed
*/
package io.event
{
	import flash.events.Event;
	
	public class EmitterEvent extends Event
	{
		public static const EMIT:String = "EmitterEvent";
		
		protected var _arguments:Array = [];
		public function get arguments():Array { return _arguments; }
		
		public function EmitterEvent(type:String, arguments:Array, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			this._arguments = arguments;
			super(type, bubbles, cancelable);
		}
		
		public override function clone():Event {
			return new EmitterEvent(this.type, this.arguments);
		}
		
		public override function toString():String {
			return formatToString("AlarmEvent", "type", "bubbles", "cancelable", "eventPhase", "message");
		}
	}
}