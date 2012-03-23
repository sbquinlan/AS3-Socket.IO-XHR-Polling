/*!
* xhr-polling-as3
* Copyright 2012 Sean Quinlan <squinlanesq@gmail.com>
* MIT Licensed
*/
package io.event
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.utils.Dictionary;
	
	public class EventEmitter extends EventDispatcher
	{
		// Event Emitter Interface
		protected var callbacks:Dictionary = new Dictionary();
		
		public function on(type:String, cb:Function):void {
			if (!callbacks[cb])
				callbacks[cb] = function(e:EmitterEvent):void { cb.apply(null, e.arguments); };
			
			addEventListener(type, callbacks[cb], false, 0, true);
		}
		
		public override function removeEventListener(type:String, listener:Function, useCapture:Boolean=false):void {
			super.removeEventListener(type, callbacks[listener] || listener, useCapture);
		}
		
		public function once(type:String, cb:Function):void {
			var self:EventEmitter = this;
			function event_remover():void {
				cb();
				self.removeEventListener(type, event_remover());
			}
			
			on(type, event_remover);
		}
		
		public function emit(name:String, ... arguments):void {
			dispatchEvent( new EmitterEvent(name, arguments) );
		}
	}
}