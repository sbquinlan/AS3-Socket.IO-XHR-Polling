/*!
* xhr-polling-as3
* Copyright 2012 Sean Quinlan <squinlanesq@gmail.com>
* MIT Licensed
*/
package io.packet
{
	public class MessagePacket extends Packet
	{
		public static const TYPE:String = '3';
		public override function get type():String { return TYPE; }
		
		public var data:String = '';
		
		protected override function parseData(pieces:Array, data:String):void {
			this.data = data;
		}
		
		protected override function getData():String {
			return data;
		}
		
		public override function getParams():Array {
			return ['message', data];
		}
		
		public override function equals(packet:Packet):Boolean {
			return ( super.equals(packet) && data == packet['data'] );
		}
	}
}