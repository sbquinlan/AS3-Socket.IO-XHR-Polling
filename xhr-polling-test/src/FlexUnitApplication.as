/*!
* xhr-polling-as3
* Copyright 2012 Sean Quinlan <squinlanesq@gmail.com>
* MIT Licensed
*/
package
{
	import Array;
	
	import flash.display.Sprite;
	
	import flexunit.flexui.FlexUnitTestRunnerUIAS;
	
	import io.packet.test.AckPacketTest;
	import io.packet.test.ConnectPacketTest;
	import io.packet.test.DisconnectPacketTest;
	import io.packet.test.ErrorPacketTest;
	import io.packet.test.EventPacketTest;
	import io.packet.test.HeartbeatPacketTest;
	import io.packet.test.JSONPacketTest;
	import io.packet.test.MessagePacketTest;
	import io.packet.test.PayloadTest;
	
	public class FlexUnitApplication extends Sprite
	{
		public function FlexUnitApplication()
		{
			onCreationComplete();
		}
		
		private function onCreationComplete():void
		{
			var testRunner:FlexUnitTestRunnerUIAS=new FlexUnitTestRunnerUIAS();
			testRunner.portNumber=8765; 
			this.addChild(testRunner); 
			testRunner.runWithFlexUnit4Runner(currentRunTestSuite(), "xhr-polling-test");
		}
		
		public function currentRunTestSuite():Array
		{
			var testsToRun:Array = new Array();
			testsToRun.push(io.packet.test.JSONPacketTest);
			testsToRun.push(io.packet.test.ConnectPacketTest);
			testsToRun.push(io.packet.test.HeartbeatPacketTest);
			testsToRun.push(io.packet.test.PayloadTest);
			testsToRun.push(io.packet.test.MessagePacketTest);
			testsToRun.push(io.packet.test.EventPacketTest);
			testsToRun.push(io.packet.test.DisconnectPacketTest);
			testsToRun.push(io.packet.test.ErrorPacketTest);
			testsToRun.push(io.packet.test.AckPacketTest);
			return testsToRun;
		}
	}
}