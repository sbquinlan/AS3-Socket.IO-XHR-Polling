/*!
* xhr-polling-as3
* Copyright 2012 Sean Quinlan <squinlanesq@gmail.com>
* MIT Licensed
*/
package io.packet.test
{
	import io.packet.HeartbeatPacket;
	import io.packet.PacketFactory;
	
	import org.flexunit.asserts.assertEquals;
	import org.flexunit.asserts.assertTrue;

	public class HeartbeatPacketTest
	{		
		[Test]
		public function decodeHeartbeatPacket():void {
			var packet:HeartbeatPacket = new HeartbeatPacket();
			var decode:HeartbeatPacket = 
				PacketFactory.decodePacket('2::') as HeartbeatPacket;
			packet.endpoint = '';
			
			assertTrue( packet.equals( decode ) );
		}
		
		[Test]
		public function encodeHeartbeatPacket():void {
			var packet:HeartbeatPacket = new HeartbeatPacket();
			packet.endpoint = '';
			
			assertEquals( '2::', PacketFactory.encodePacket(packet) );
		}
	}
}