/*!
* xhr-polling-as3
* Copyright 2012 Sean Quinlan <squinlanesq@gmail.com>
* MIT Licensed
*/
package io.packet
{
	public class HeartbeatPacket extends Packet
	{
		public static const TYPE:String = '2';
		public override function get type():String { return TYPE; }
	}
}