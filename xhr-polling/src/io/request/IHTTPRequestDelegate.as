/*!
 * xhr-polling-as3
 * Copyright 2012 Sean Quinlan <squinlanesq@gmail.com>
 * MIT Licensed
 */
package io.request
{
	public interface IHTTPRequestDelegate
	{
		function getURLFor(req:HTTPRequest):String;
	}
}