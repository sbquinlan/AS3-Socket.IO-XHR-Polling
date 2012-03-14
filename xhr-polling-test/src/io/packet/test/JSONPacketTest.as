/*!
* xhr-polling-as3
* Copyright 2012 Sean Quinlan <squinlanesq@gmail.com>
* MIT Licensed
*/
package io.packet.test
{
	import io.packet.JSONPacket;
	import io.packet.PacketFactory;
	
	import org.flexunit.asserts.assertEquals;
	import org.flexunit.asserts.assertTrue;
	import org.hamcrest.assertThat;
	import org.hamcrest.object.equalTo;
	import org.hamcrest.object.hasPropertyWithValue;

	public class JSONPacketTest
	{		
		
		[Test]
		public function decodeJSONPacket():void {
			var decoded:JSONPacket = PacketFactory.decodePacket('4:::"2"') as JSONPacket;
			var packet:JSONPacket = new JSONPacket();
			packet.endpoint = '';
			packet.data = '2';
			
			assertTrue(
				packet.equals( decoded )
			);
			assertThat(
				decoded.data,
				equalTo(packet.data)
			);
		}
		
		[Test]
		public function encodeJSONPacket():void {
			var packet:JSONPacket = new JSONPacket();
			packet.endpoint = '';
			packet.data = '2';
			
			assertEquals(
				'4:::"2"', PacketFactory.encodePacket( packet )
			);
		}
		
		[Test]
		public function decodeJSONPacketWithIdAndAck():void {
			var decoded:JSONPacket = PacketFactory.decodePacket('4:1+::{"a":"b"}') as JSONPacket;
			var packet:JSONPacket = new JSONPacket();
			packet.id = '1';
			packet.ack = 'data';
			packet.endpoint = '';
			packet.data = { a : 'b' };
			
			assertTrue(
				packet.equals( decoded )
			);
			assertThat(
				decoded.data, 
				hasPropertyWithValue('a', 'b')
			);
		}
		
		[Test]
		public function encodeJSONPacketWithIdAndAck():void {
			var packet:JSONPacket = new JSONPacket();
			packet.id = '1';
			packet.ack = 'data';
			packet.endpoint = '';
			packet.data = { a : 'b' };
			
			assertEquals(
				'4:1+::{"a":"b"}', PacketFactory.encodePacket(packet)
			);			
		}
	}
}