# Actionscript 3 Socket.IO XHR-Polling

## How to Install

    import the 'xhr-polling' project into FlashBuilder
    import the 'xhr-polling-text' project if you want to test it.

## How to Use

Edit your Flex/Actionscript/Air project's build path properties 
(by right clicking on the project) to include the xhr-polling project
as a dependency.

```js
var options:Options = new io.Options();
// change options if you want

var socket:SocketNamespace = IO.connect('http://localhost/', options);

socket.emit('some event', { hello: 'world'});

socket.on('other event', function(args:Object):void {
  // do something
});

socket.once('only catch this once', function(... arguments):void {
  trace(arguments);
});

socket.disconnect();
```

## Notes

Big ups to learnboost. This is totally based on socket.io-client. 
I wrote this in a weekend for a small project on heroku, which doesn't 
support websockets or flashsockets at the moment. This is by no means 
production-ready and probably buggy.

## License 

(The MIT License)

Copyright (c) 2012 Sean Quinlan &lt;squinlanesq@gmail.com&gt;

Permission is hereby granted, free of charge, to any person obtaining
a copy of this software and associated documentation files (the
'Software'), to deal in the Software without restriction, including
without limitation the rights to use, copy, modify, merge, publish,
distribute, sublicense, and/or sell copies of the Software, and to
permit persons to whom the Software is furnished to do so, subject to
the following conditions:

The above copyright notice and this permission notice shall be
included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED 'AS IS', WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
