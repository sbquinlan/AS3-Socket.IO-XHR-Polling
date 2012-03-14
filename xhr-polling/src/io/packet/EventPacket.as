/*!
* xhr-polling-as3
* Copyright 2012 Sean Quinlan <squinlanesq@gmail.com>
* MIT Licensed
*/
package io.packet
{
	public class EventPacket extends Packet
	{
		public static const TYPE:String = '5';
		public override function get type():String { return TYPE; }
		
		public var args:Array = [];
		public var name:String = '';
		
		protected override function parseData(pieces:Array, data:String):void {
			try {
				var opts:Object = JSON.parse(data);
				name = opts.name;
				args = opts.args || [];
			} catch (e:SyntaxError) { }
		}
		
		protected override function getData():String {
			var ev:Object = { name : this.name };
			if (args && args.length)
				ev.args = args;
			
			return JSON.stringify(ev);
		}
		
		public override function getParams():Array {
			var ret:Array = [name].concat(args);
			(ack == 'data') && ret.push(ack);
			return ret;
		}
		
		public override function equals(packet:Packet):Boolean {
			return ( super.equals(packet) &&
					 name == packet['name']);
		}
	}
}