/*!
* xhr-polling-as3
* Copyright 2012 Sean Quinlan <squinlanesq@gmail.com>
* MIT Licensed
*/
package io.packet.test
{
	import io.packet.ErrorPacket;
	import io.packet.PacketFactory;
	
	import org.flexunit.asserts.assertEquals;
	import org.flexunit.asserts.assertTrue;

	public class ErrorPacketTest
	{
		[Test]
		public function decodeErrorPacket():void {
			var packet:ErrorPacket = new ErrorPacket();
			packet.reason = '';
			packet.advice = '';
			packet.endpoint = '';
			
			assertTrue(
				packet.equals( PacketFactory.decodePacket('7::') )
			);
		}
		
		[Test]
		public function encodeErrorPacket():void {
			var packet:ErrorPacket = new ErrorPacket();
			packet.reason = '';
			packet.advice = '';
			packet.endpoint = '';
			
			assertEquals(
				'7::', PacketFactory.encodePacket(packet)
			);
		}
		
		[Test]
		public function decodeErrorPacketWithReason():void {
			var packet:ErrorPacket = new ErrorPacket();
			packet.reason = 'transport not supported';
			packet.advice = '';
			packet.endpoint = '';
			
			assertTrue(
				packet.equals( PacketFactory.decodePacket('7:::0') )
			);
		}
		
		[Test]
		public function encodeErrorPacketWithReason():void {
			var packet:ErrorPacket = new ErrorPacket();
			packet.reason = 'transport not supported';
			packet.advice = '';
			packet.endpoint = '';
			
			assertEquals(
				'7:::0', PacketFactory.encodePacket(packet)
			);
		}
		
		[Test]
		public function decodeErrorPacketWithReasonAdvice():void {
			var packet:ErrorPacket = new ErrorPacket();
			packet.reason = 'unauthorized';
			packet.advice = 'reconnect';
			packet.endpoint = '';
			
			assertTrue(
				packet.equals( PacketFactory.decodePacket('7:::2+0') )
			);
		}
		
		[Test]
		public function encodeErrorPacketWithReasonAdvice():void {
			var packet:ErrorPacket = new ErrorPacket();
			packet.reason = 'unauthorized';
			packet.advice = 'reconnect';
			packet.endpoint = '';
			
			assertEquals(
				'7:::2+0', PacketFactory.encodePacket(packet)
			);
		}
		
		[Test]
		public function decodeErrorPacketWithEndpoint():void {
			var packet:ErrorPacket = new ErrorPacket();
			packet.reason = '';
			packet.advice = '';
			packet.endpoint = '/woot';
			
			assertTrue(
				packet.equals( PacketFactory.decodePacket('7::/woot') )
			);
		}
		
		[Test]
		public function encodeErrorPacketWithEndpoint():void {
			var packet:ErrorPacket = new ErrorPacket();
			packet.reason = '';
			packet.advice = '';
			packet.endpoint = '/woot';
			
			assertEquals(
				'7::/woot', PacketFactory.encodePacket(packet)
			);
		}
		
	}
}