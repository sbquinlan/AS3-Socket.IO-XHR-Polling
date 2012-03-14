/*!
* xhr-polling-as3
* Copyright 2012 Sean Quinlan <squinlanesq@gmail.com>
* MIT Licensed
*/
package io.packet.test
{
	import io.packet.DisconnectPacket;
	import io.packet.PacketFactory;
	
	import org.flexunit.asserts.assertEquals;
	import org.flexunit.asserts.assertTrue;

	public class DisconnectPacketTest
	{		
		[Test]
		public function decodeDisconnectPacket():void {
			var packet:DisconnectPacket = new DisconnectPacket();
			var decode:DisconnectPacket = 
				PacketFactory.decodePacket('0::/woot') as DisconnectPacket;
			packet.endpoint = '/woot';
			
			assertTrue( packet.equals( decode ) );
		}
		
		[Test]
		public function encodeDisconnectPacket():void {
			var packet:DisconnectPacket = new DisconnectPacket();
			packet.endpoint = '/woot';
			
			assertEquals( '0::/woot', PacketFactory.encodePacket(packet) );
		}
	}
}