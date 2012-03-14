/*!
* xhr-polling-as3
* Copyright 2012 Sean Quinlan <squinlanesq@gmail.com>
* MIT Licensed
*/
package io.packet
{
	import flash.utils.IExternalizable;

	public class ErrorPacket extends Packet
	{
		protected static var REASONS:Array = [
			'transport not supported'
			, 'client not handshaken'
			, 'unauthorized'
		];
		
		protected static var ADVICE:String = 'reconnect';
		
		public static const TYPE:String = '7';
		public override function get type():String { return TYPE; }
		
		protected var _reason:String = '';
		public function get reason():String { return _reason; }
		public function set reason(r:String):void {
			if (REASONS.indexOf(r) > -1) {
				_reason = r;
			}
		}
		
		protected var _advice:String = '';
		public function get advice():String { return _advice; }
		public function set advice(a:String):void {
			if (ADVICE == a) _advice = a;
		}
		
		protected override function parseData(pieces:Array, data:String):void {
			pieces = data.split('+');
			_reason = REASONS[pieces[0]] || '';
			_advice = pieces[1] == '0' ? ADVICE : '';
		}
		
		protected override function getData():String {
			return (reason.length ? REASONS.indexOf(reason) : '') + (advice.length ? '+0' : '');
		}
		
		public override function getParams():Array {
			return [
				(reason == REASONS[2] ? 'connect_failed' : 'error')
			,	 reason
			];
		}
		
		public override function equals(packet:Packet):Boolean {
			return ( super.equals(packet) && 
					 reason == packet['reason'] &&
					 advice == packet['advice'] );
		}
	}
}