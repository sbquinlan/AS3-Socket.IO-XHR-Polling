/*!
* xhr-polling-as3
* Copyright 2012 Sean Quinlan <squinlanesq@gmail.com>
* MIT Licensed
*/
package io.request
{
	public interface IPostRequestDelegate extends IHTTPRequestDelegate
	{
		function postRequestOnSuccess( ):void;
		function postRequestOnError( ):void;
	}
}