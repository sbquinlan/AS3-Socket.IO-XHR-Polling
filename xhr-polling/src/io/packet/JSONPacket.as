/*!
* xhr-polling-as3
* Copyright 2012 Sean Quinlan <squinlanesq@gmail.com>
* MIT Licensed
*/
package io.packet
{
	public class JSONPacket extends Packet
	{
		public static const TYPE:String = '4';
		public override function get type():String { return TYPE; }
		
		public var data:Object = {};
		
		protected override function parseData(pieces:Array, data:String):void {
			this.data = JSON.parse(data);
		}
		
		protected override function getData():String {
			return JSON.stringify(data);
		}
		
		public override function getParams():Array {
			var ret:Array = ['message', data];
			(ack == 'data') && ret.push(ack);
			return ret;
		}
	}
}