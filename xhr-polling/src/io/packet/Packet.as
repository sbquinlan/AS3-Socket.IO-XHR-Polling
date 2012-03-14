/*!
* xhr-polling-as3
* Copyright 2012 Sean Quinlan <squinlanesq@gmail.com>
* MIT Licensed
*/
package io.packet
{
	public class /*Noop*/Packet
	{
		// override these
		public static const TYPE:String = '8';
		public function get type():String { return TYPE; }
		
		public var endpoint:String = '';
		public var id:String = '';
		public var ack:String = '';

		public function fromData(pieces:Array):Packet { 
			endpoint = pieces[4] || '';
			
			if (pieces[2]) {
				id = pieces[2] || '';
				ack = pieces[3] ? 'data' : 'true';
			}
			
			parseData(pieces, pieces[5] || '');
			
			return this; 
		}
		
		// override this
		protected function parseData(pieces:Array, data:String):void { }
		
		public function toData():String { 
			var encoded:Array = [
				type,
				id + (ack == 'data' ? '+' : ''),
				endpoint
			];
			
			if (getData()) encoded.push( getData() );
			
			return encoded.join(':');
		}
		
		// override this
		protected function getData():String { return ''; }
		
		public function getParams():Array {
			return ['noop'];
		}
		
		public function equals(packet:Packet):Boolean {
			return (type == packet.type &&
					endpoint == packet.endpoint &&
					id == packet.id &&
					ack == packet.ack);
		}
	}
}