-module(start).
-export([s/0]). 

s()->
    application:start(crypto),
	application:start(cowlib),
	application:start(asn1),
	application:start(public_key),
	application:start(ssl),
	application:start(ranch),
	application:start(cowboy),
	application:start(myblog).