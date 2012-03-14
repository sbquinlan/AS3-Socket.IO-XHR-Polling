/*!
* xhr-polling-as3
* Copyright 2012 Sean Quinlan <squinlanesq@gmail.com>
* MIT Licensed
*/
package io.packet.test
{
	import io.packet.MessagePacket;
	import io.packet.PacketFactory;
	
	import org.flexunit.asserts.assertEquals;
	import org.flexunit.asserts.assertTrue;

	public class MessagePacketTest
	{		
		[Test]
		public function decodeMessagePacket():void {
			var packet:MessagePacket = new MessagePacket();
			var decode:MessagePacket = 
				PacketFactory.decodePacket('3:::woot') as MessagePacket;
			packet.endpoint = '';
			packet.data = 'woot';
			
			assertTrue( packet.equals( decode ) );
		}
		
		[Test]
		public function encodeMessagePacket():void {
			var packet:MessagePacket = new MessagePacket();
			packet.endpoint = '';
			packet.data = 'woot';
			
			assertEquals( '3:::woot', PacketFactory.encodePacket(packet) );
		}
		
		[Test]
		public function decodeMessagePacketWithIdEndpoint():void {
			var packet:MessagePacket = new MessagePacket();
			var decode:MessagePacket = 
				PacketFactory.decodePacket('3:5:/tobi') as MessagePacket;
			packet.id = '5';
			packet.ack = 'true';
			packet.endpoint = '/tobi';
			packet.data = '';
			
			assertTrue( packet.equals( decode ) );
		}
		
		[Test]
		public function encodeMessagePacketWithIdEndpoint():void {
			var packet:MessagePacket = new MessagePacket();
			packet.id = '5';
			packet.ack = 'true';
			packet.endpoint = '/tobi';
			packet.data = '';
			
			assertEquals( '3:5:/tobi', PacketFactory.encodePacket(packet) );
		}
	}
}