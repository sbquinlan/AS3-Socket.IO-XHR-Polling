/*!
* xhr-polling-as3
* Copyright 2012 Sean Quinlan <squinlanesq@gmail.com>
* MIT Licensed
*/
package io.utils
{
	public class URI
	{
		protected static var re:RegExp = /^(?:(?![^:@]+:[^:@\/]*@)([^:\/?#.]+):)?(?:\/\/)?((?:(([^:@]*)(?::([^:@]*))?)?@)?([^:\/?#]*)(?::(\d*))?)(((\/(?:[^?#](?![^?#\/]*\.[^?#\/.]+(?:[?#]|$)))*\/?)?([^?#\/]*))(?:\?([^#]*))?(?:#(.*))?)/;
		protected static var parts:Array = [
			'source', 'protocol', 'authority', 'userInfo', 'user', 'password',
			'host', 'port', 'relative', 'path', 'directory', 'file', 'query',
			'anchor'];
		
		public static function buildURI(str:String=''):URI {
			var m:Object   	   = str.match(re)
				,	uri:URI    = new URI()
				,	i:uint     = 14;
			
			while (i--) uri[parts[i]] = m[i] || '';
			return uri;
		}
		
		public var source:String;
		public var protocol:String;
		public var authority:String;
		public var userInfo:String;
		public var user:String;
		public var password:String;
		public var host:String;
		public var port:String;
		public var relative:String;
		public var path:String;
		public var directory:String;
		public var file:String;
		public var query:String;
		public var anchor:String;
	}
}