-module(ct).  
-define(SYSTEM_ELEMENTS, "0123456789ABCDEFGHIJKLMNOPQRSTUVWSYZ").  
-compile(export_all).  
-export([test/0, test/3]).  
  
%%test  
test()  ->  
    Seed = "0123",  
    Width = 4,  
    Count = 30,  
    test(Seed, Count, Width).  
      
test(Seed, Count, Width)    ->  
    NL = random_nums(Seed, Count, Width).  
    %io:format(" format NL:  ~p ~n",[NL]),  
    %ok.  
      
random_nums(Seed, Count, Width) ->  
    case is_args_reasonable(Seed, Count, Width) of  
    ok ->  
        random_numbers(Seed, Count, Width);  
    {error,_} = Reason ->  
        Reason  
    end.  
      
is_args_reasonable(Seed, Count, Width) ->  
    System = length(Seed),  
    LimitWidth = get_limit_width(System, Count),  
    is_args_reasonable(Width, LimitWidth).  
is_args_reasonable(Width, LimitWidth) when Width >= LimitWidth ->  
      ok;  
is_args_reasonable(_Width, _LimitWidth)  ->  
      {error, overflow}.  
      
get_limit_width(Num, Count) ->  
    get_limit_width(Num, Count, 1).  
      
get_limit_width(Num, Count, LimitWidth) when Count > Num ->    
    get_limit_width(Num, Count/Num, LimitWidth+1);  
get_limit_width(_Num, _Count, LimitWidth) ->  
    LimitWidth.  
      
random_numbers(Seed, Count, Width) ->  
    L = sub_random_nums(Count),  
    format(Seed, Width, shuffle(L)).  
      
sub_random_nums(Count) ->  
    sub_random_numbers(Count, Count,[]).  
sub_random_numbers(Upper, Count, L) when Count > 0 ->  
    KV = {get_random(Upper), Count-1},  
    sub_random_numbers(Upper, Count-1, [KV|L]);  
sub_random_numbers(_Upper, _Count, L)  ->  
    L.  
get_random(Upper) when is_integer(Upper) ->  
    random:uniform(Upper);  
get_random(_Upper) ->  
    random:uniform(10000).  
      
shuffle(L) when is_list(L) ->  
    {_, NL} = lists:unzip(lists:keysort(1, L)),  
    NL.  
      
format(Seed, Width, L) when is_list(L) andalso is_integer(Width) ->  
    System = length(Seed),  
    Farmat = lists:concat(['~', Width, '.', System, '.0X']),  
    NL = [lists:flatten(io_lib:format(Farmat, [X,""])) || X <- L],  
    case lists:prefix(Seed, ?SYSTEM_ELEMENTS) of  
    true  -> NL;  
    false -> replace(Seed, NL)  
    end.  
      
replace(Seed, L) ->  
   replace(Seed, L ,[]).   
replace(_Seed, [] ,NL) ->  
    NL;  
replace(Seed, [H|Tail] ,NL) ->  
    NH = sub_replace(Seed, H),  
    replace(Seed, Tail, [NH|NL]).  
      
sub_replace(Seed, L) ->  
   Len = length(L),  
   sub_replace(Seed, L , Len, []).   
sub_replace(_, _, 0, NL) -> lists:reverse(lists:concat(NL));  
sub_replace(Seed, [H|Tail] , Count, NL) ->  
    NH = string:substr(Seed,string:str(?SYSTEM_ELEMENTS,[H]),1),  
    sub_replace(Seed, Tail, Count-1, [NH|NL]). 