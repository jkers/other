-module(s).
-export([client/0]).

client() ->
    case gen_tcp:connect("127.0.0.1",6000,[binary]) of
	{ok,Socket} ->
	    send(Socket);   
	{error,Reason} ->
	    io:format("connect failed;~p",[Reason])
   end.
send(Socket) ->
    case gen_tcp:send(Socket,ct:test()) of
	ok -> ok;
	{error,Reason} ->
	    io:format("send failed:~p~n",[Reason])
    end,
    send(Socket).
    
    
