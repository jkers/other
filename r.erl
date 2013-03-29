-module(r).
-export([server/0]).

server() ->
    spawn(fun() -> do() end).
do() ->
    case gen_tcp:listen(6000,[binary,{reuseaddr,true},{active,false}]) of
	{ok,Sock} -> 
	    case gen_tcp:accept(Sock) of
		{ok,Cs} -> recv(Cs);
		{error,Reason} -> io:format("accept failed:~p",[Reason])
	    end;
	{error,Reason} -> io:format("listen 6000 failed:~p",[Reason])
   end.
  
recv(Cs) -> 
    case gen_tcp:recv(Cs, 0) of
        {ok, B} ->
            io:format("~p~n",[B]),
            recv(Cs);
        {error, Reason} ->
            io:format("recv failed:~p",[Reason]);
	{error,closed} ->
	    io:format("closed.")
    end. 
