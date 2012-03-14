/*!
* xhr-polling-as3
* Copyright 2012 Sean Quinlan <squinlanesq@gmail.com>
* MIT Licensed
*/
package io.packet
{
	public class DisconnectPacket extends Packet
	{
		public static const TYPE:String = '0';
		public override function get type():String { return TYPE; }
		
		// not externalized
		public var reason:String = null;
		
		public override function getParams():Array {
			return ['disconnect', reason];
		}
		
		public override function equals(packet:Packet):Boolean {
			return ( super.equals(packet) && reason == packet['reason'] );
		}
	}
}