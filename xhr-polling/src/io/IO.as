/*!
* xhr-polling-as3
* Copyright 2012 Sean Quinlan <squinlanesq@gmail.com>
* MIT Licensed
*/
package io
{
	import flash.utils.Dictionary;
	
	import io.utils.IOUtils;
	import io.utils.URI;
	
	import mx.utils.ObjectUtil;
	import mx.utils.URLUtil;

	public class IO
	{
		protected static var sockets:Dictionary = new Dictionary();
		
		public static var transport:String = 'xhr-polling';
		public static var protocol:String = '1';
		
		public static function connect(host:String, user_options:Options=null):SocketNamespace {
			var options:Options = new Options()
			, 	uri:URI         = URI.buildURI(host);
			
			options.host = uri.host;
			options.secure = uri.protocol == 'https';
			options.port = parseInt(uri.port) || (options.secure ? 443 : 80);
			options.query = uri.query;
			
			for(var prop:String in user_options) options[prop] = user_options[prop];
			
			var socket:Socket = IO.sockets[host];
			if (!IO.sockets[host])
				IO.sockets[host] = socket = new Socket(options);
			
			socket = socket || IO.sockets[host];
			
			// if path is not root
			return socket.of(uri.path.length > 1 ? uri.path : '');
		}
	}
}