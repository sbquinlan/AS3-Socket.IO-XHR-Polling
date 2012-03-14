/*!
* xhr-polling-as3
* Copyright 2012 Sean Quinlan <squinlanesq@gmail.com>
* MIT Licensed
*/
package io
{
	import flash.net.getClassByAlias;
	import flash.utils.getQualifiedClassName;

	public class Options
	{
		public var host:String = 'localhost';
		public var port:uint = 80;
		public var query:String = '';
		public var resource:String = 'socket.io';
		public var secure:Boolean = false;
		
		public var connect_timeout:uint = 10000;
		public var reconnect:Boolean = true;
		public var reconnection_delay:uint = 500;
		public var reconnection_limit:Number = Number.POSITIVE_INFINITY;
		public var reopen_delay:uint = 3000;
		public var max_reconnection_attempts:uint = 10;
		
		public var sync_disconnect:Boolean = false;
		public var auto_connect:Boolean = true;
		
		// prolly not the best idea
		public function mergeWith(options:Object):void {
			for (var prop:* in options) if ( this.hasOwnProperty(prop) ) this[prop] = options[prop];
		}
		
	}
}