/*!
* xhr-polling-as3
* Copyright 2012 Sean Quinlan <squinlanesq@gmail.com>
* MIT Licensed
*/
package io.packet.test
{
	import io.packet.AckPacket;
	import io.packet.Packet;
	import io.packet.PacketFactory;
	
	import org.flexunit.asserts.assertEquals;
	import org.flexunit.asserts.assertTrue;
	import org.hamcrest.assertThat;
	import org.hamcrest.collection.array;
	import org.hamcrest.collection.emptyArray;
	import org.hamcrest.object.equalTo;

	public class AckPacketTest
	{
		
		[Test]
		public function decodeAckPacket():void {
			var packet:AckPacket = new AckPacket();
			packet.ackId = '140';
			packet.endpoint = '';
			packet.args = [];
			
			assertTrue(
				packet.equals( PacketFactory.decodePacket('6:::140') )
			);
			assertThat(
				PacketFactory.decodePacket('6:::140')['args'], emptyArray()
			);
		}
		
		[Test]
		public function encodeAckPacket():void {
			var packet:AckPacket = new AckPacket();
			packet.ackId = '140';
			packet.endpoint = '';
			packet.args = [];
			
			assertEquals(
				'6:::140', PacketFactory.encodePacket(packet)
			);			
		}
		
		[Test]
		public function decodeAckPacketWithArgs():void {
			var packet:AckPacket = new AckPacket();
			packet.ackId = '12';
			packet.endpoint = '';
			packet.args = ['woot', 'wa'];
			
			assertTrue(
				packet.equals( PacketFactory.decodePacket('6:::12+["woot","wa"]') )
			);
			assertThat(
				PacketFactory.decodePacket('6:::12+["woot","wa"]')['args'],
				array('woot', 'wa')
			);
		}
		
		[Test]
		public function encodeAckPacketWithArgs():void {
			var packet:AckPacket = new AckPacket();
			packet.ackId = '12';
			packet.endpoint = '';
			packet.args = ['woot', 'wa'];
			
			assertEquals(
				'6:::12+["woot","wa"]', PacketFactory.encodePacket(packet)
			);
		}
		
		[Test]
		public function decodeAckPacketWithBadJSON():void {
			var thrown:Boolean = false;
			
			try {
				PacketFactory.decodePacket('6:::1+{"++]');
			} catch (e:SyntaxError) {
				thrown = true;
			}
			
			assertTrue(thrown);
		}
	}
}