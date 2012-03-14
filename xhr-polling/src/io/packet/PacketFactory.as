/*!
* xhr-polling-as3
* Copyright 2012 Sean Quinlan <squinlanesq@gmail.com>
* MIT Licensed
*/
package io.packet
{
	import flash.utils.Dictionary;
	
	import mx.core.ClassFactory;
	
	public class PacketFactory
	{
		public static var PACKET_TYPE_MAP:Dictionary = new Dictionary();
		
		// static {
		PACKET_TYPE_MAP[DisconnectPacket.TYPE] = DisconnectPacket;
		PACKET_TYPE_MAP[ConnectPacket.TYPE]    = ConnectPacket;
		PACKET_TYPE_MAP[HeartbeatPacket.TYPE]  = HeartbeatPacket;
		PACKET_TYPE_MAP[MessagePacket.TYPE]    = MessagePacket;
		PACKET_TYPE_MAP[JSONPacket.TYPE]       = JSONPacket;
		PACKET_TYPE_MAP[EventPacket.TYPE]      = EventPacket;
		PACKET_TYPE_MAP[AckPacket.TYPE]        = AckPacket;
		PACKET_TYPE_MAP[ErrorPacket.TYPE]      = ErrorPacket;
		PACKET_TYPE_MAP[Packet.TYPE]           = Packet;
		// }
		
		public static function decodePacket(data:String):Packet {
			var pieces:Array = data.match(
				/([^:]+):([0-9]+)?(\+)?:([^:]+)?:?([\s\S]*)?/);
			
			if (PACKET_TYPE_MAP[pieces[1]] is Class) {
				return new (PACKET_TYPE_MAP[pieces[1]] as Class)().fromData(pieces);
			}
			
			return null;
		}
		
		public static function decodePayload(data:String):Vector.<Packet> {
			var ret:Vector.<Packet> = new Vector.<Packet>();
			
			if (data.charAt(0) == '\ufffd') {
				for(var i:uint = 1, length:String = ''; i < data.length; i++) {
					if (data.charAt(i) == '\ufffd') {
						ret.push( decodePacket( 
							data.substr(i + 1).substr(0, parseInt(length)) 
						) );
						i += Number(length) + 1;
						length = '';
					} else {
						length += data.charAt(i);
					}
				}
			} else {
				ret.push( decodePacket(data) );
			}
			
			return ret;
		}
		
		public static function encodePacket(packet:Packet):String {
			return packet.toData();
		}
		
		public static function encodePayload(packets:Vector.<Packet>):String {
			var encoded:String = '';
			
			if (packets.length == 1)
				return packets[0].toData();
			
			for (var i:uint = 0, l:uint = packets.length; i < l; i++) {
				var packet:String = packets[i].toData();;
				encoded += '\ufffd' + packet.length + '\ufffd' + packet;
			}
			
			return encoded;
		}
	}
}