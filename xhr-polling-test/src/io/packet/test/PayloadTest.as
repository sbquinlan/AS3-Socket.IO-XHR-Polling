/*!
* xhr-polling-as3
* Copyright 2012 Sean Quinlan <squinlanesq@gmail.com>
* MIT Licensed
*/
package io.packet.test
{
	import io.packet.DisconnectPacket;
	import io.packet.MessagePacket;
	import io.packet.Packet;
	import io.packet.PacketFactory;
	
	import org.flexunit.asserts.assertEquals;
	import org.flexunit.asserts.assertTrue;

	public class PayloadTest
	{		
		[Test]
		public function decodePayload():void {
			var packets:Vector.<Packet> = PacketFactory.decodePayload(
				'\ufffd5\ufffd3:::5\ufffd7\ufffd3:::53d\ufffd3\ufffd0::'
			);
			
			var packet_one:MessagePacket = new MessagePacket();
			packet_one.data = '5';
			var packet_two:MessagePacket = new MessagePacket();
			packet_two.data = '53d';
			var packet_three:DisconnectPacket = new DisconnectPacket();
			
			
			assertTrue( packets[0], packet_one );
			assertTrue( packets[1], packet_two );
			assertTrue( packets[2], packet_three );
		}
		
		[Test]
		public function encodePayload():void {
			var packets:Vector.<Packet> = new Vector.<Packet>();
			
			var packet_one:MessagePacket = new MessagePacket();
			packet_one.data = '5';
			var packet_two:MessagePacket = new MessagePacket();
			packet_two.data = '53d';
			var packet_three:DisconnectPacket = new DisconnectPacket();
			
			packets.push( packet_one );
			packets.push( packet_two );
			packets.push( packet_three );
			
			assertEquals( 
				'\ufffd5\ufffd3:::5\ufffd7\ufffd3:::53d\ufffd3\ufffd0::',
				PacketFactory.encodePayload( packets )
			);
		}
		
		[Test]
		public function decodeNewline():void {
			var packet:MessagePacket = new MessagePacket();
			packet.data = '\n';
			
			assertTrue(
				packet.equals( PacketFactory.decodePacket('3:::\n') )
			);
		}
	}
}