/*!
* xhr-polling-as3
* Copyright 2012 Sean Quinlan <squinlanesq@gmail.com>
* MIT Licensed
*/
package io
{
	import io.event.EventEmitter;
	import io.packet.AckPacket;
	import io.packet.DisconnectPacket;
	import io.packet.ErrorPacket;
	import io.packet.EventPacket;
	import io.packet.JSONPacket;
	import io.packet.MessagePacket;
	import io.packet.Packet;

	/**
	 * SocketNamespace is the interface Users will see.
	 * This class is responsible for:
	 * 		- converting packets to events
	 * 		- record keeping ack packets
	 * 		- calling ack callbacks
	 */
	public class SocketNamespace extends EventEmitter
	{
		protected var socket:Socket = null;
		protected var name:String = '';
		
		protected var ackPackets:uint = 0;
		protected var acks:Object = {};
		
		public function SocketNamespace(socket:Socket, name:String='') {
			this.socket = socket;
			this.socket.on(Socket.PACKET, onPacket);
			this.name = name || '';
			this.ackPackets = 0;
			this.acks = {};
		}
		
		protected function $emit(... arguments):void {
			super.emit.apply(this, arguments);
		}
		
		protected function of(name:String):SocketNamespace {
			return socket.of.call(this.socket, name);
		}
		
		// pass packet down to socket
		protected function packet(packet:Packet):void {
			packet.endpoint = name;
			socket.packet(packet);
		}
		
		
//		public function send(data:String, fn:Function):void {
//			var packet:MessagePacket = new MessagePacket();
//			packet.data = data;
//			
//			if (fn is Function) {
//				packet.id = (++this.ackPackets).toString();
//				packet.ack = true.toString();
//				acks[packet.id] = fn;
//			}
//			
//			this.packet(packet);
//		}
		
		public function disconnect():void {
			if (name == '') {
				socket.disconnect();
			} else {
				packet(new DisconnectPacket());
				$emit('disconnect');
			}
		}
		
		// convert event to packet and send to socket
		public override function emit(name:String, ... arguments):void {
			var lastArg:* = arguments[arguments.length - 1]
				,	packet:EventPacket = new EventPacket();
			packet.name = name;
			
			if( lastArg is Function ) {
				packet.id = (++this.ackPackets).toString();
				packet.ack = 'data';
				acks[packet.id] = lastArg;
				arguments.splice(-1, 1);
			}
			
			packet.args = arguments;
			this.packet(packet);
		}
		
		// convert packet to event and dispatch to user
		protected function onPacket(packet:Packet):void {
			var self:SocketNamespace = this;
			function ack(... arguments):void {
				var p:AckPacket = new AckPacket( packet.id );
				p.args = arguments;
				self.packet( p );
			}
			
			switch (packet.type) {
				case DisconnectPacket.TYPE:
					if (name == '') socket.onDisconnect(
						(packet as DisconnectPacket).reason || 'booted'
					);
					break;
				case MessagePacket.TYPE:
				case JSONPacket.TYPE:
					var params:Array = packet.getParams();
					if (packet.ack == 'data') params.push(ack);
					else this.packet( new AckPacket( packet.id ) );
					
					$emit.apply(this, params);
					return;
				case AckPacket.TYPE:
					var ap:AckPacket = packet as AckPacket;
					if (acks[ap.ackId]) {
						acks[ap.ackId].apply(this, ap.args);
						delete acks[ap.ackId];
					}
					break;
				case ErrorPacket.TYPE:
					if ((packet as ErrorPacket).advice) 
						return socket.onError(packet as ErrorPacket);
			}
			
			$emit.apply(this, packet.getParams());
		}
	}
}