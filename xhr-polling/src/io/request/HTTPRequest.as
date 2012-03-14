/*!
 * xhr-polling-as3
 * Copyright 2012 Sean Quinlan <squinlanesq@gmail.com>
 * MIT Licensed
 */
package io.request
{
	import flash.events.Event;
	import flash.events.HTTPStatusEvent;
	import flash.events.IOErrorEvent;
	import flash.net.URLRequest;
	import flash.net.URLStream;

	public class HTTPRequest
	{
		protected var _delegate:IHTTPRequestDelegate;
		
		protected var request:URLRequest = new URLRequest(  );
		protected var stream:URLStream = new URLStream();;
		
		public function HTTPRequest( d:IHTTPRequestDelegate )
		{
			_delegate = d;
			
			stream.addEventListener(IOErrorEvent.IO_ERROR, onError, false, 0, true);
			stream.addEventListener(Event.COMPLETE, onComplete, false, 0, true);
		}
		
		public function start():void {
			request.url = _delegate.getURLFor(this);
			stream.load( request );
		}
		
		public function stop():void {
			if (stream.connected) stream.close();
		}
		
		protected function onError(event:IOErrorEvent):void { }
		protected function onComplete(event:Event):void { }
	}
}