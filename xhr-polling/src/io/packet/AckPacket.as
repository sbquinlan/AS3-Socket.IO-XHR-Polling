/*!
* xhr-polling-as3
* Copyright 2012 Sean Quinlan <squinlanesq@gmail.com>
* MIT Licensed
*/
package io.packet
{
	import org.hamcrest.assertThat;

	public class AckPacket extends Packet
	{
		public static const TYPE:String = '6';
		public override function get type():String { return TYPE; }
		
		public var ackId:String;
		public var args:Array;
		
		public function AckPacket(aId:String = ''):void {
			this.ackId = aId;
		}
		
		protected override function parseData(pieces:Array, data:String):void {
			pieces = data.match(/^([0-9]+)(\+)?(.*)/);
			if (pieces) {
				ackId = pieces[1];
				args = pieces[3] ? (JSON.parse(pieces[3]) as Array) : [];
			}
		}
		
		protected override function getData():String {
			return ackId + ((args && args.length > 0) ? '+' + JSON.stringify(args) : '');
		}
		
		public override function getParams():Array {
			return [];
		}
		
		public override function equals(packet:Packet):Boolean {
			return ( super.equals(packet) && 
					 ackId == packet['ackId'] );
		}
	}
}