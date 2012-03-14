/*!
 * xhr-polling-as3
 * Copyright 2012 Sean Quinlan <squinlanesq@gmail.com>
 * MIT Licensed
 */
package io.request
{
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.net.URLRequestMethod;

	public class PollingRequest extends HTTPRequest
	{
		public function PollingRequest(delegate:IPollingRequestDelegate) {
			super(delegate);
			
			request.method = URLRequestMethod.GET;
			request.idleTimeout = 30000; // air only
		}
		
		protected function get delegate():IPollingRequestDelegate {
			return _delegate as IPollingRequestDelegate;
		}
		
		public override function start():void {
			super.start();
			trace("[polling request] opening: "+request.url);
		}
		
		protected override function onError(event:IOErrorEvent):void { 
			delegate.pollingRequestOnError();
		}
		
		protected override function onComplete(event:Event):void { 
			if (stream.bytesAvailable)
				delegate.pollingRequestOnData(  
					stream.readUTFBytes( stream.bytesAvailable ) 
				);
		}
	}
}