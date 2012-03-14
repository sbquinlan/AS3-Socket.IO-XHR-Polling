/*!
* xhr-polling-as3
* Copyright 2012 Sean Quinlan <squinlanesq@gmail.com>
* MIT Licensed
*/
package io.packet.test
{
	import io.packet.EventPacket;
	import io.packet.PacketFactory;
	
	import org.flexunit.asserts.assertEquals;
	import org.flexunit.asserts.assertTrue;
	import org.hamcrest.assertThat;
	import org.hamcrest.collection.array;
	import org.hamcrest.collection.emptyArray;
	import org.hamcrest.object.hasProperties;
	import org.hamcrest.object.hasPropertyWithValue;

	public class EventPacketTest
	{		
		
		[Test]
		public function decodeEventPacket():void {
			var packet:EventPacket = new EventPacket();
			var decode:EventPacket = 
				PacketFactory.decodePacket('5:::{"name":"woot"}') as EventPacket;
			packet.endpoint = '';
			packet.name = 'woot';
			packet.args = [];
			
			assertTrue( packet.equals( 
				decode
			) );
			assertThat(
				decode.args, emptyArray()
			);
		}
		
		[Test]
		public function encodeEventPacket():void {
			var packet:EventPacket = new EventPacket();
			packet.endpoint = '';
			packet.name = 'woot';
			packet.args = [];
			
			assertEquals(
				'5:::{"name":"woot"}', PacketFactory.encodePacket(packet)
			);
		}
		
		[Test]
		public function decodeEventPacketWithIdAck():void {
			var packet:EventPacket = new EventPacket();
			var decode:EventPacket = 
				PacketFactory.decodePacket('5:1+::{"name":"tobi"}') as EventPacket;
			packet.id = '1';
			packet.ack = 'data';
			packet.endpoint = '';
			packet.name = 'tobi';
			packet.args = [];
			
			assertTrue( packet.equals(  decode ) );
			assertThat( decode.args, emptyArray() );
		}
		
		[Test]
		public function encodeEventPacketWithIdAck():void {
			var packet:EventPacket = new EventPacket();
			packet.id = '1';
			packet.ack = 'data';
			packet.endpoint = '';
			packet.name = 'tobi';
			packet.args = [];
			
			assertEquals(
				'5:1+::{"name":"tobi"}', PacketFactory.encodePacket(packet)
			);
		}
		
		[Test]
		public function decodeEventPacketWithData():void {
			var packet:EventPacket = new EventPacket();
			var decode:EventPacket = 
				PacketFactory.decodePacket('5:::{"name":"edwald","args":[{"a":"b"},2,"3"]}') as EventPacket;
			packet.name = 'edwald';
			packet.endpoint = '';
			packet.args = [
				{"a" : "b"},
				2,
				"3"
			];
			
			assertTrue( packet.equals( decode ) );
			assertThat( decode.args, array( hasPropertyWithValue("a", "b"), 2, "3" ) );
		}
		
		[Test]
		public function encodeEventPacketWithData():void {
			var packet:EventPacket = new EventPacket();
			packet.name = 'edwald';
			packet.endpoint = '';
			packet.args = [
				{"a" : "b"},
				2,
				"3"
			];
			
			assertEquals(
				'5:::{"name":"edwald","args":[{"a":"b"},2,"3"]}', 
				PacketFactory.encodePacket(packet)
			);
		}
		
		
		
	}
}