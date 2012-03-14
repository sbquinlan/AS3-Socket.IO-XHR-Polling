/*!
 * xhr-polling-as3
 * Copyright 2012 Sean Quinlan <squinlanesq@gmail.com>
 * MIT Licensed
 */
package io.request
{
	public interface IPollingRequestDelegate extends IHTTPRequestDelegate
	{
		function pollingRequestOnData( data:String ):void;
		function pollingRequestOnError( ):void;
	}
}