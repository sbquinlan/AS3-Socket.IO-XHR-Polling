/*!
* xhr-polling-as3
* Copyright 2012 Sean Quinlan <squinlanesq@gmail.com>
* MIT Licensed
*/
package io.packet.test
{
	import io.packet.ConnectPacket;
	import io.packet.PacketFactory;
	
	import org.flexunit.asserts.assertEquals;
	import org.flexunit.asserts.assertTrue;

	public class ConnectPacketTest
	{		
		[Test]
		public function decodeHeartbeatPacket():void {
			var packet:ConnectPacket = new ConnectPacket();
			var decode:ConnectPacket = 
				PacketFactory.decodePacket('1::/tobi') as ConnectPacket;
			packet.endpoint = '/tobi';
			packet.qs = '';
			
			assertTrue( packet.equals( decode ) );
		}
		
		[Test]
		public function encodeHeartbeatPacket():void {
			var packet:ConnectPacket = new ConnectPacket();
			packet.endpoint = '/tobi';
			packet.qs = '';
			
			assertEquals( '1::/tobi', PacketFactory.encodePacket(packet) );
		}
		
		[Test]
		public function decodeHeartbeatPacketWithQueryString():void {
			var packet:ConnectPacket = new ConnectPacket();
			var decode:ConnectPacket = 
				PacketFactory.decodePacket('1::/test:?test=1') as ConnectPacket;
			packet.endpoint = '/test';
			packet.qs = '?test=1';
			
			assertTrue( packet.equals( decode ) );
		}
		
		[Test]
		public function encodeHeartbeatPacketWithQueryString():void {
			var packet:ConnectPacket = new ConnectPacket();
			packet.endpoint = '/test';
			packet.qs = '?test=1';
			
			assertEquals( '1::/test:?test=1', PacketFactory.encodePacket(packet) );
		}
	}
}