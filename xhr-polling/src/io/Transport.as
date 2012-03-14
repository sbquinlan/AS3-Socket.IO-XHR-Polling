/*!
* xhr-polling-as3
* Copyright 2012 Sean Quinlan <squinlanesq@gmail.com>
* MIT Licensed
*/
package io
{
	import avmplus.getQualifiedClassName;
	
	import flash.utils.Timer;
	
	import io.event.EventEmitter;
	import io.packet.HeartbeatPacket;
	import io.packet.Packet;
	import io.packet.PacketFactory;
	import io.request.HTTPRequest;
	import io.request.IPollingRequestDelegate;
	import io.request.IPostRequestDelegate;
	import io.request.PollingRequest;
	import io.request.PostRequest;
	import io.utils.IOUtils;

	public class Transport extends EventEmitter implements IPollingRequestDelegate, IPostRequestDelegate
	{
		protected var socket:Socket;
		
		protected var pollingRequest:PollingRequest;
		protected var postRequest:PostRequest;
		
		protected var session_id:String = null;
		protected var closeTimer:Timer;
		
		protected var opened:Boolean = false;
		protected var closed:Boolean = false;
		
		public function Transport(socket:Socket) {
			this.socket = socket;
			
			pollingRequest = new PollingRequest(this);
			postRequest = new PostRequest(this);
		}
		
		// socket needs this
		public function init(sid:String, heartbeat:Number, close:Number):void {
			trace('[transport] session: '+sid+'\n\tclosetimeout: '+close.toString() + ' (ms)');
			session_id = sid;
			closeTimer = IOUtils.createTimer( close, onDisconnect );
			onOpen();
		}
		
		public function getURLFor(req:HTTPRequest):String {
			return IOUtils.getSessionRequestURL(socket.options, session_id);
		}
		
		public function disconnect():void {
			onDisconnect(Socket.BOOTED);
		}
		
		/*
		 * GET METHODS
		 */
		
		protected function get():void {
			if (!this.opened) return;
			pollingRequest.start();
		}
		
		public function pollingRequestOnData( data:String ):void {
			onData( data );
			get();
		}
		
		public function pollingRequestOnError():void {
			onClose();
		}
		
		/*
		 * POST METHODS
		 */
		public function packet(packet:Packet):void {
			post( PacketFactory.encodePacket(packet) );
		}
		
		public function payload(payload:Vector.<Packet>):void {
			post( PacketFactory.encodePayload(payload) );
		}
		
		protected function post(data:String):void {
			this.socket.setBuffer(true); // fill buffer
			
			postRequest.data = data;
			postRequest.start();
		}
		
		public function postRequestOnSuccess( ):void {
			socket.setBuffer(false); // flush buffer
		}
		
		public function postRequestOnError():void {
			onClose();
		}
		
		/*
		 * ON METHODS
		 */
		
		protected function onOpen():void {
			trace('[transport] onOpen');
			socket.setBuffer(false); // flush buffer
			
			// old onOpen function
			opened = true;
			emit(Socket.OPEN);
			
			// start polling
			get();
			closeTimer.reset();
			closeTimer.start();
		}
		
		// socket needs this
		protected function onClose():void {
			trace('[transport] onClose');
			opened = false;
			emit(Socket.CLOSE);
			
			pollingRequest.stop();
		}
		
		protected function onDisconnect(reason:String):void {
			trace('[transport] onDisconnect: '+reason);
			if (closed && opened) onClose();
			closeTimer.reset();
			emit(Socket.DISCONNECT, reason);
		}
		
		protected function onData(data:String):void {
			trace('[transport] onData: '+data);
			closeTimer.reset();
			
			if (socket.connected || socket.connecting || socket.reconnecting)
				closeTimer.start();
			
			if (data !== '') {
				var msgs:Vector.<Packet> = PacketFactory.decodePayload(data);
				
				if (msgs && msgs.length) {
					for (var i:uint = 0, l:uint = msgs.length; i < l; i++)
						onPacket(msgs[i]);
				}
			}
		}
		
		// intercept heartbeats
		protected function onPacket(packet:Packet):void {
			trace('[transport] onPacket: '+ getQualifiedClassName(packet));
			if (packet.type == HeartbeatPacket.TYPE) {
				post( PacketFactory.encodePacket( new HeartbeatPacket() ) );
				return;
			}
			
			emit(Socket.PACKET, packet);
		}
	}
}