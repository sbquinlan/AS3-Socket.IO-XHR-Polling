/*!
* xhr-polling-as3
* Copyright 2012 Sean Quinlan <squinlanesq@gmail.com>
* MIT Licensed
*/
package io.packet
{
	public class ConnectPacket extends Packet
	{
		public static const TYPE:String = '1';
		public override function get type():String { return TYPE; }
		
		public var qs:String = null;
		
		protected override function parseData(pieces:Array, data:String):void {
			qs = data || '';
		}
		
		protected override function getData():String {
			return qs;
		}
		
		public override function getParams():Array {
			return ['connect'];
		}
		
		public override function equals(packet:Packet):Boolean {
			return ( super.equals(packet) && qs == packet['qs'] );
		}
	}
}