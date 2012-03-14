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

	public class PostRequest extends HTTPRequest
	{
		public function PostRequest(d:IPostRequestDelegate) {
			super(d);
			
			request.method = URLRequestMethod.POST;
			request.contentType = 'text/plain;charset=UTF-8';
		}
		
		protected var _data:String;
		public function set data(d:String):void {
			_data = d;
		}
		
		protected function get delegate():IPostRequestDelegate {
			return _delegate as IPostRequestDelegate;
		}
		
		public override function start():void {
			request.data = _data;
			super.start();
			trace("[post request] sending: "+_data);
		}
		
		protected override function onError(event:IOErrorEvent):void { 
			delegate.postRequestOnError();
		}
		
		protected override function onComplete(event:Event):void { 
			delegate.postRequestOnSuccess();
			trace("[post request] sent");
		}
	}
}