-module(s).
-export([send/1]).

send(N) ->
    {ok,Sock} = gen_tcp:connect("192.168.0.64",6000,[binary,{packet,0}]),
    lists:foreach(fun(_) -> gen_tcp:send(Sock, ct:test()) end, lists:seq(1, N)),
    ok = gen_tcp:close(Sock).
    
