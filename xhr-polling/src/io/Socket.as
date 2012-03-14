/*!
* xhr-polling-as3
* Copyright 2012 Sean Quinlan <squinlanesq@gmail.com>
* MIT Licensed
*/
package io
{
	import flash.events.HTTPStatusEvent;
	import flash.events.IOErrorEvent;
	import flash.net.URLRequest;
	import flash.net.URLStream;
	import flash.utils.Dictionary;
	import flash.utils.Timer;
	
	import io.event.EventEmitter;
	import io.packet.ConnectPacket;
	import io.packet.DisconnectPacket;
	import io.packet.Packet;
	import io.utils.IOUtils;

	/**
	 * Socket is responsible for:
	 * 
	 *  - buffering data to be sent to server
	 *  - maintaining session
	 *  - managing transport layer
	 *  	- communicating session changes
	 * 		- sending buffered data through transport
	 *  	- negotiating transport layer w/server
	 * 			(irrelevant because this lib only supports xhr-polling, but
	 *           totally could be added in the future)
	 *  - bubbling transport activity to User / SocketNamespace
	 */
	public class Socket extends EventEmitter
	{
		/* CONSTANTS */
		public static const CONNECT:String = 'connect';
		public static const CONNECTING:String = 'connecting';
		public static const CONNECT_FAILED:String = 'connect_failed';
		
		public static const RECONNECT:String = 'reconnect';
		public static const RECONNECTING:String = 'reconnecting';
		public static const RECONNECT_FAILED:String = 'reconnect_failed';
		
		public static const OPEN:String = 'open';
		public static const CLOSE:String = 'close';
		public static const DISCONNECT:String = 'disconnect';
		public static const ERROR:String = 'error';
		public static const PACKET:String = 'packet';
		public static const BOOTED:String = 'booted';
		
		public var options:Options = new Options();
		
		/* STATE VARIABLES */
		protected var _connected:Boolean = false;
		public function get connected():Boolean { return _connected; }
		
		protected var _open:Boolean = false;
		public function get open():Boolean { return _open; }
		
		protected var _connecting:Boolean = false;
		public function get connecting():Boolean { return _connecting; }
		
		protected var _reconnecting:Boolean = false;
		public function get reconnecting():Boolean { return _reconnecting; }
		
		protected var transport:Transport = null;
		protected var connectTimeoutTimer:Timer = null;
		
		protected var namespaces:Dictionary = new Dictionary();
		
		protected var buffer:Vector.<Packet> = new Vector.<Packet>();
		protected var doBuffer:Boolean = false;
		
		protected var reconnectionAttempts:uint = 0;
		protected var reconnectionTimer:Timer = null;
		protected var reconnectionDelay:uint = 0;
		
		public function Socket(options:Options)  {
			super();
			
			transport = new Transport(this);
			transport.on(PACKET, onPacket);
			transport.on(CLOSE, onClose);
			transport.on(OPEN, onOpen);
			transport.on(DISCONNECT, onDisconnect);
			
			if (options) this.options = options;
			if (options.auto_connect) connect();
		}
		
		public function of(name:String):SocketNamespace {
			if (!namespaces[name]) {
				namespaces[name] = new SocketNamespace(this, name);
				
				if (name != '') {;
					var connect:ConnectPacket = new ConnectPacket()
					connect.endpoint = name;
					packet(connect);
				}
			}
			
			return this.namespaces[name];
		}
		
		public function connect():void {
			if (connecting || connected) return;
			
			doHandshake();
		}
		
		public function disconnect():void {
			if (connected) {
				if (open) packet(new DisconnectPacket());
				onDisconnect(BOOTED);
			}
		}
		
		public function packet(data:Packet):void {
			if (connected && !doBuffer) {
				// transport.payload(data);
			} else buffer.push(data);
		}
		
		protected function publish(... arguments):void {
			emit.apply(this, arguments);
			for (var i:String in namespaces) emit.apply(of(i), arguments);
		}
		
		protected function getRequest():URLRequest {
			var url:String = IOUtils.getRequestURL(this.options);
			var xhr:URLRequest = new URLRequest(url);
			
			return xhr;
		}
		
		protected function doHandshake():void {
			var xhr:URLRequest = this.getRequest();
			var loader:URLStream = new URLStream();
			
			loader.addEventListener(
				IOErrorEvent.IO_ERROR, 
				function (event:IOErrorEvent):void {
					onError( loader.readUTFBytes(loader.bytesAvailable) );
				}, false, 0, true);
			
			loader.addEventListener(
				HTTPStatusEvent.HTTP_STATUS, 
				function (event:HTTPStatusEvent):void {
					var data:String = loader.bytesAvailable ? 
						loader.readUTFBytes(loader.bytesAvailable) : '';
					
					if (event.status == 200)
						onHandshake.apply(this, data.split(':'));
					else
						!reconnecting && onError( data );
				}, false, 0, true);
			
			loader.load(xhr);
		}
		
		protected function onHandshake(sid:String, heartbeat:Number, 
									   close:Number, transports:String):void {
			if (transports.split(',').indexOf('xhr-polling') == -1)
				return publish(CONNECT_FAILED);
			
			transport.init(sid, heartbeat * 1000, close * 1000);
			
			_connecting = true;
			publish(CONNECTING);
			
			if (options.connect_timeout) {
				IOUtils.createTimer(
					options.connect_timeout, 
					function():void {
						if (!connected) _connecting = false;
					}
				);
			}
		}
		
		protected function reconnect():void {
			if (reconnecting && connected) {
				// success
				for (var i:String in namespaces) 
					if (i != '') namespaces[i].packet( new ConnectPacket() );
				
				publish(RECONNECT, 'xhr-polling', reconnectionAttempts);
				return reset_reconnect();
				
			} else if (reconnecting && reconnectionAttempts < options.max_reconnection_attempts) {
				// ran out of attempts
				reset_reconnect();
				return publish(RECONNECT_FAILED);
				
			} else if (reconnecting && connecting) {
				// recheck in a second
				reconnectionTimer = IOUtils.createTimer( 1000, reconnect );
				return;
				
			} else if (reconnecting) {
				// continue trying
				if (reconnectionDelay < options.reconnection_limit)
					reconnectionDelay *= 2;
			} else {
				// start and add event recursion
				on(CONNECT_FAILED, reconnect);
				on(CONNECT, reconnect);
			}
			
			// start reconnecting
			_reconnecting = true;
			reconnectionTimer = IOUtils.createTimer(reconnectionDelay, reconnect);
			
			connect();
			publish(RECONNECTING);
		}
		
		protected function reset_reconnect():void {
			reconnectionTimer.stop();
			_reconnecting = false;
			reconnectionAttempts = 0;
			
			removeEventListener(CONNECT_FAILED, reconnect);
			removeEventListener(CONNECT, reconnect);
		}
		
		public function setBuffer(b:Boolean):void {
			doBuffer = b;
			
			// flush buffer?
			if (!doBuffer && connected && buffer.length) {
				transport.payload(buffer);
				buffer = new Vector.<Packet>();
			}
		}
		
		/*
		 * ON METHODS
		 */
		
		protected function onOpen():void {
			_open = true;
		}
		
		protected function onClose():void {
			_open = false;
		}
		
		protected function onConnect():void {
			if (!this.connected) {
				this._connected = true;
				this._connecting = false;
				
				this.setBuffer(false);
				this.emit(CONNECT);
			}
		}
		
		// namespace needs this
		public function onDisconnect(reason:String):void {
			var wasConnected:Boolean = connected;
			
			_connected = false;
			_connecting = false;
			_open = false;
			
			if (wasConnected) {
				transport.disconnect();
				publish(DISCONNECT);
				
				if (BOOTED != reason && options.reconnect && !reconnecting)
					reconnect();
			}
		}
		
		// pass packet up to namespace
		protected function onPacket(packet:Packet):void {
			if (packet.type == ConnectPacket.TYPE && packet.endpoint == '') {
				onConnect();
			}
			
			emit(Socket.PACKET, packet);
		}
		
		// namespace needs thi
		public function onError(err:Object):void {
			if (err && err.advice && options.reconnect && err.advice == RECONNECT && connected) {
				disconnect();
				reconnect();
			}
			
			publish(ERROR, err && err.reason ? err.reason : err);
		}
		
	}
}