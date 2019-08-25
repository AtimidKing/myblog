-module(test).

-export([i/0]).

i() ->
    io:format("None=~p~n",[{?MODULE, ?LINE, 'none'}]),
    ok.